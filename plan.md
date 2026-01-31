# Non-Spherical Celestial Bodies: Implementation Plan

## Problem Statement

KSP defines "zero altitude" (sea level) as a perfect sphere with a single scalar `CelestialBody.Radius`. Every altitude calculation reduces to `altitude = distance_from_center - Radius`. To support oblate or otherwise non-spherical bodies, the reference radius must vary by position — typically as a function of latitude.

## Existing Infrastructure

### What KSP already has:
- **`CelestialBody.scaledEllipsoid` / `scaledElipRadMult`** (CelestialBody.cs:42-44) — A Vector3d per-axis radius multiplier, but only used for CommNet occlusion (CommNetBody.cs:40-41). Does not affect physics or altitude.
- **`PQSMod_VertexHeightOblate`** — Deforms the terrain mesh using `sin(pi*v)^pow * height`, creating visual oblateness. Does NOT change the reference sea level — altitude=0 remains a sphere.
- **PQS terrain pipeline** — Already handles arbitrary radial deformation. `PQS.GetSurfaceHeight()` runs all modifiers starting from `PQS.radius` and returns the actual surface distance from center. The variable-radius infrastructure exists in the terrain layer.

### The fundamental formula used everywhere:
```csharp
// ~44 call sites across ~18 files
altitude = distance_from_body_center - Radius   // single scalar
```

---

## Implementation Plan

### Step 1: Add Ellipsoid Parameters to CelestialBody

**File: CelestialBody.cs**

Add new fields alongside existing `Radius`:

```csharp
public double RadiusEquatorial;    // = Radius (backward compatible)
public double RadiusPolar;         // new — smaller for oblate bodies
public double Flattening => 1.0 - RadiusPolar / RadiusEquatorial;

// Precomputed for performance (set in SetupConstants)
private double _a2, _b2, _a4, _b4;
```

Add the core method:

```csharp
/// <summary>
/// Returns the sea-level radius at a given geodetic latitude.
/// For a sphere, returns Radius everywhere.
/// For an oblate spheroid: R(lat) = sqrt((a^4 cos^2 + b^4 sin^2) / (a^2 cos^2 + b^2 sin^2))
/// </summary>
public double GetSeaLevelRadius(double latitudeRad)
{
    if (_a2 == _b2) return RadiusEquatorial; // fast path for spheres
    double cos2 = Math.Cos(latitudeRad); cos2 *= cos2;
    double sin2 = 1.0 - cos2;
    return Math.Sqrt((_a4 * cos2 + _b4 * sin2) / (_a2 * cos2 + _b2 * sin2));
}
```

For bodies that need more customization than an ellipsoid (e.g., egg-shaped, pear-shaped), add an optional override:

```csharp
public FloatCurve seaLevelRadiusCurve;  // latitude -> radius, if non-null overrides ellipsoid
```

**Backward compatibility:** Set `RadiusPolar = RadiusEquatorial = Radius` when loading bodies that don't specify polar radius. All existing bodies behave identically.

Precompute `_a2, _b2, _a4, _b4` in `SetupConstants()` (CelestialBody.cs:363).

### Step 2: Fix the Core Altitude Pipeline

These are the highest-priority changes — every other system depends on them.

#### 2a: CelestialBody.GetAltitude (CelestialBody.cs:758)

**Current:**
```csharp
public double GetAltitude(Vector3d worldPos)
{
    return (worldPos - position).magnitude - Radius;
}
```

**New:**
```csharp
public double GetAltitude(Vector3d worldPos)
{
    Vector3d relPos = worldPos - position;
    double magnitude = relPos.magnitude;
    // Derive latitude from direction vector (cheap — no atan2 needed for ellipsoid formula)
    Vector3d localDir = BodyFrame.WorldToLocal(relPos.xzy);
    double sinLat = localDir.z / magnitude;  // z in local frame is polar axis
    double latRad = Math.Asin(sinLat);
    return magnitude - GetSeaLevelRadius(latRad);
}
```

**Performance note:** This adds one `Asin` + the ellipsoid formula. For spherical bodies the fast path returns immediately. Consider caching per-vessel per-frame if profiling shows issues.

#### 2b: CelestialBody.GetLatLonAlt (CelestialBody.cs:763)

**Current:**
```csharp
alt = magnitude - Radius;
```

**New:** Latitude is already being computed in this method. Use it:
```csharp
double latRad = Math.Asin(rPos.z);  // already computed
alt = magnitude - GetSeaLevelRadius(latRad);
```

#### 2c: CelestialBody.GetLatLonAltOrbital (CelestialBody.cs:781)

Same change as 2b — latitude is already available.

#### 2d: CelestialBody.GetRelSurfacePosition (CelestialBody.cs:671)

**Current:**
```csharp
return GetRelSurfaceNVector(lat, lon) * (Radius + alt);
```

**New:**
```csharp
return GetRelSurfaceNVector(lat, lon) * (GetSeaLevelRadius(lat * UtilMath.Deg2Rad) + alt);
```

#### 2e: LatLon.cs Static Methods (LatLon.cs:21, 99, 108)

These take `double Radius` as a parameter. Two options:

**Option A (minimal change):** Have callers pass the correct local radius:
```csharp
// Callers change from:
LatLon.GetAltitude(bodyFrame, bodyPos, body.Radius, worldPos)
// To:
LatLon.GetAltitude(bodyFrame, bodyPos, body.GetSeaLevelRadius(lat), worldPos)
```

**Option B (cleaner):** Add overloads that take a CelestialBody and compute internally. Deprecate the scalar-radius versions.

Recommend **Option B** for new code, keep Option A versions for backward compat.

#### 2f: FlightGlobals.getAltitudeAtPos (FlightGlobals.cs:1471)

**Current:**
```csharp
return Vector3d.Distance(position, body.position) - body.Radius;
```

**New:** Delegate to `body.GetAltitude(position)` which handles ellipsoid internally.

#### 2g: FlightGlobals.GetSqrAltitude (FlightGlobals.cs:1476)

This squared-altitude optimization doesn't work cleanly with variable radius. Either:
- Remove it (check if anything performance-critical uses it)
- Approximate with equatorial radius (it's used for rough distance checks)

### Step 3: Orbital Mechanics — Keep Spherical

**Design decision:** Orbital altitude (`Orbit.altitude`, `PeA`, `ApA`) should remain referenced to equatorial radius. This matches real-world convention (orbital elements use equatorial radius) and avoids breaking maneuver planning and trajectory math.

**Files unchanged:**
- Orbit.cs:304-310 (PeA, ApA) — keep using `referenceBody.Radius` (= equatorial)
- Orbit.cs:526, 550 (altitude) — keep using `refBody.Radius`

**Rationale:** A 100km circular orbit should report 100km everywhere, not oscillate between 100km and 121km as it passes over poles vs equator. Surface-relative altitude is what changes; orbital altitude stays spherical.

### Step 4: Vessel Surface Interactions

#### 4a: Vessel.PQSAltitude (Vessel.cs:2710)

**Current:**
```csharp
return mainBody.pqsController.GetSurfaceHeight(...) - mainBody.Radius;
```

**New:**
```csharp
double seaLevelR = mainBody.GetSeaLevelRadius(latitude * UtilMath.Deg2Rad);
return mainBody.pqsController.GetSurfaceHeight(...) - seaLevelR;
```

`latitude` is already a field on `Vessel`.

#### 4b: Other Vessel altitude sites (Vessel.cs:2489, 2702)

Same pattern — substitute `mainBody.Radius` with `mainBody.GetSeaLevelRadius(latitude)`.

#### 4c: Crash detection (Vessel.cs:2753)

Uses `altitude` which will now be ellipsoid-relative. No additional changes needed — the altitude value itself is now correct.

#### 4d: Radar altitude (Vessel.cs:2795-2820)

`terrainAltitude = altitude - heightFromTerrain` — since `altitude` is now ellipsoid-relative, and `heightFromTerrain` comes from raycasting (physical), this remains correct.

### Step 5: PQS Terrain System

#### 5a: PQS base radius (PQS.cs)

The PQS vertex building pipeline starts every vertex at `vbData.vertHeight = radius` (a scalar). For ellipsoidal bodies, this should start at the ellipsoidal radius for that vertex's latitude.

**In PQS.GetSurfaceHeight (PQS.cs:3078-3091):**

**Current:**
```csharp
vbData.vertHeight = radius;  // scalar
Mod_OnVertexBuildHeight(vbData);
return vbData.vertHeight;
```

**New:**
```csharp
vbData.vertHeight = GetBaseRadiusForDirection(vbData.directionFromCenter);
Mod_OnVertexBuildHeight(vbData);
return vbData.vertHeight;
```

Where `GetBaseRadiusForDirection` derives latitude from the direction vector and calls `CelestialBody.GetSeaLevelRadius`.

**Impact on existing PQSMods:** All existing height modifiers add/subtract from `vertHeight`. If the base starts at the ellipsoidal radius instead of a constant, their offsets are now relative to the ellipsoid — which is exactly what we want. Mountains are "above sea level" where sea level follows the ellipsoid.

**However:** `PQSMod_VertexHeightOblate` would now be redundant for bodies using the ellipsoid system (it was a visual hack for what should be in the reference frame). It can remain for fine-tuning or be disabled on ellipsoidal bodies.

#### 5b: PQS.radiusMin / radiusMax (PQS.cs:2203-2206)

These are used for LOD and visibility. They should be updated:
```csharp
radiusMax = RadiusEquatorial + Mod_GetVertexMaxHeight();  // largest possible
radiusMin = RadiusPolar + Mod_GetVertexMinHeight();        // smallest possible
```

#### 5c: TerrainAltitude (CelestialBody.cs:838)

**Current:**
```csharp
double num = pqsController.GetSurfaceHeight(relSurfaceNVector) - pqsController.radius;
```

**New:** Since `GetSurfaceHeight` now returns height from the ellipsoid base:
```csharp
double num = pqsController.GetSurfaceHeight(relSurfaceNVector) - GetSeaLevelRadius(latitude * Deg2Rad);
```

This gives terrain altitude above the local sea level (ellipsoid surface).

### Step 6: Atmosphere

#### 6a: Pressure and Temperature (CelestialBody.cs:387-423)

`GetPressure(altitude)` and `GetTemperature(altitude)` take altitude as input. Since altitude is now measured from the ellipsoid, these work correctly without changes — the atmosphere follows the ellipsoid shape naturally.

#### 6b: radiusAtmoFactor (CelestialBody.cs:369)

**Current:**
```csharp
radiusAtmoFactor = Radius / atmosphereDepth * (0.0 - Math.Log(1E-06));
```

This is used for solar air mass (optical path length through atmosphere). Use mean radius `(2*a + b) / 3` or equatorial radius — it's an approximation:

```csharp
double meanRadius = (2.0 * RadiusEquatorial + RadiusPolar) / 3.0;
radiusAtmoFactor = meanRadius / atmosphereDepth * (0.0 - Math.Log(1E-06));
```

#### 6c: atmosphereDepth

Currently a scalar (meters above sea level). For an oblate body, the atmosphere follows the ellipsoid — atmosphere depth remains constant in the surface-normal direction. No change needed since altitude is now ellipsoid-relative.

### Step 7: Gameplay Systems Using Radius

These are lower priority and many can use equatorial radius unchanged:

| System | File | Recommended Change |
|---|---|---|
| TimeWarp limits | CelestialBody.cs:1019 | Use equatorial radius (limits are rough thresholds) |
| Local gravity | KerbalEVA.cs:7217 | Use equatorial radius (point-mass gravity is already approximate) |
| Horizon angle | Sun.cs:165 | Use local sea-level radius for accuracy, or equatorial for simplicity |
| Thermal radiation | AeroGUI.cs:645-648 | Use equatorial radius (approximation) |
| Arc distance | LaunchSite.cs:274 | Use local radius for accuracy (affects KSC distance display) |
| Camera threshold | FlightCamera.cs:846 | Use equatorial radius (rough threshold) |
| Scan thresholds | ModuleOrbitalSurveyor.cs:27 | Use equatorial radius |
| NavBall north | NavBall.cs:110 | Use equatorial radius (direction vector, not distance) |
| CommNet occlusion | CommNetBody.cs:40 | Already uses `scaledElipRadMult` — wire to new parameters |

### Step 8: Config/Persistence

Add loading support in the body config parser (likely in `PSystemBody` or `CelestialBody.Load`):

```
// .cfg format
Radius = 600000         // equatorial radius (backward compatible)
RadiusPolar = 588000    // optional — defaults to Radius if absent
// OR
Flattening = 0.02       // alternative way to specify (compute RadiusPolar from this)
```

For maximum customizability:
```
seaLevelRadiusCurve     // FloatCurve keyed by latitude (degrees), overrides ellipsoid
{
    key = 0   600000    // equator
    key = 45  596000
    key = 90  588000    // pole
}
```

---

## File Change Summary

| File | Changes | Scope |
|---|---|---|
| **CelestialBody.cs** | Add ellipsoid fields, `GetSeaLevelRadius()`, fix `GetAltitude`, `GetLatLonAlt`, `GetRelSurfacePosition`, `TerrainAltitude`, `SetupConstants`, atmosphere factor | ~10 methods |
| **LatLon.cs** | Add CelestialBody-aware overloads or change callers to pass local radius | ~4 methods |
| **FlightGlobals.cs** | Delegate `getAltitudeAtPos` to `body.GetAltitude()`, handle `GetSqrAltitude` | 2-3 methods |
| **Vessel.cs** | Fix `PQSAltitude()` and surface height checks to use local radius | ~5 sites |
| **PQS.cs** | Variable base radius in `GetSurfaceHeight`, update `radiusMin/radiusMax` | ~3 sites |
| **Orbit.cs** | No change (keep equatorial radius for orbital elements) | 0 |
| **Gameplay files** | ~10 files with minor Radius references | ~15 sites, most trivial |

**Total: ~18 files, ~44 call sites**

---

## Performance Considerations

- **Ellipsoid formula cost:** One `sqrt`, precomputed `cos²/sin²`. Negligible for per-vessel-per-frame.
- **PQS vertex building:** Called for thousands of vertices during quad builds. Deriving latitude from `directionFromCenter` is cheap (`asin(y)` on a unit vector). The fast-path for spherical bodies (`a == b`) returns immediately.
- **Caching:** Consider caching `GetSeaLevelRadius` result on `Vessel` per-frame since latitude barely changes between frames.
- **GetSqrAltitude:** The squared-distance optimization breaks with variable radius. Profile whether any hot path uses it; if so, approximate with equatorial radius.

---

## Risk Assessment

| Risk | Mitigation |
|---|---|
| Existing saves break | Default `RadiusPolar = Radius` makes all existing bodies spherical |
| Orbit display shows oscillating altitude | Keep orbital altitude spherical (Step 3) |
| PQS terrain seams at quad boundaries | PQS already handles variable vertex heights; no seam risk |
| PQSMod_VertexHeightOblate double-application | Disable/remove on bodies using ellipsoid system |
| Performance regression in altitude pipeline | Fast-path for spherical bodies; precomputed constants |
| Mods using `body.Radius` directly | `Radius` remains as equatorial radius; mods work approximately |

---

## Testing Strategy

1. **Verify spherical bodies unchanged** — Set `RadiusPolar = RadiusEquatorial`, confirm identical altitude/position values everywhere
2. **Oblate body smoke test** — Create a test body with visible flattening (e.g., f=0.1). Verify:
   - Sea level follows the ellipsoid (altitude=0 at poles is closer to center)
   - Terrain renders correctly on top of ellipsoid
   - Atmosphere follows the ellipsoid (consistent pressure at altitude=0 everywhere)
   - Orbital altitude stays constant for circular orbit
   - Landed vessels report altitude=0 at sea level at both equator and poles
3. **Edge cases** — Vessels transitioning between landed/flying near poles; time warp at various latitudes; CommNet over oblate bodies
