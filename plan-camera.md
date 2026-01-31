# Camera Up / Surface Normal Changes for Non-Spherical Bodies

## The Core Problem

On a sphere, the surface normal equals the radial direction: `(position - bodyCenter).normalized`. On an ellipsoid, the **geodetic surface normal** tilts toward the equator — at 45° latitude on an oblate body, "up" doesn't point at the body center, it tilts slightly equatorward.

## What Uses the Spherical "Up"

Everything flows from one function — `FlightGlobals.getUpAxis` (FlightGlobals.cs:1491):

```csharp
public static Vector3d getUpAxis(CelestialBody body, Vector3d position)
{
    return (position - body.position).normalized;  // pure radial = spherical
}
```

This propagates to:

| Consumer | Location | How it gets "up" |
|---|---|---|
| **Vessel.upAxis** | Vessel.cs:2828 | `FlightGlobals.getUpAxis(mainBody, CoMD)` — updated every physics frame |
| **FlightCamera.upAxis** | FlightCamera.cs:735 | `FlightGlobals.upAxis` — copied every frame in `UpdateCameraTransform()` |
| **Ship orientation** | FlightGlobals.cs:822-824 | `upwards = (position - body.position).normalized` — defines horizon plane for heading calculation |
| **NavBall horizon** | NavBall.cs:110 | `(target.position - body.position).normalized` — identical spherical formula, defines the attitude ball horizon |
| **NavBall radial vector** | NavBall.cs ~200 | `(wCoM - cbPos).normalized` projected onto velocity-normal plane |
| **FlightGlobals.ship_upAxis** | FlightGlobals.cs:208 | Returns `ActiveVessel.upAxis` |

## What Already Handles Ellipsoids (But Isn't Used for "Up")

`CelestialBody.GetSurfaceNVector` (CelestialBody.cs:663-669) computes a surface normal using the `BodyFrame` transform, but it takes lat/lon as input (not a world position) and is only used for terrain/position calculations — never for camera or vessel orientation:

```csharp
public Vector3d GetSurfaceNVector(double lat, double lon)
{
    Vector3d r = Planetarium.SphericalVector(lat * Deg2Rad, lon * Deg2Rad);
    return BodyFrame.LocalToWorld(r).xzy;
}
```

Note: even this is still a **geocentric** normal (unit sphere direction), not a true geodetic normal. For an ellipsoid, the geodetic normal at latitude `phi` is:

```
normal = (cos(phi)/a², 0, sin(phi)/b²).normalized
```

which differs from the geocentric `(cos(phi), 0, sin(phi))`.

## What Would Need to Change

### 1. `FlightGlobals.getUpAxis` (FlightGlobals.cs:1491)

The single most important change. Replace the radial direction with the geodetic surface normal:

```csharp
// Geodetic normal for oblate spheroid:
// Given local direction d = BodyFrame.WorldToLocal(relPos),
// the ellipsoid normal is (d.x/a², d.y/a², d.z/b²).normalized
// then transform back to world coords
```

### 2. `FlightCamera.UpdateCameraTransform` (FlightCamera.cs:735)

Gets up from `FlightGlobals.upAxis`, so it inherits the fix automatically.

### 3. `Vessel.upAxis` (Vessel.cs:2828)

Same — calls `getUpAxis`, inherits fix.

### 4. Ship orientation / heading (FlightGlobals.cs:822-824)

Uses inline `(position - body.position).normalized` rather than calling `getUpAxis`. Must be changed separately to use the geodetic normal.

### 5. NavBall horizon (NavBall.cs:110)

Also uses inline `(target.position - body.position).normalized`. Must be changed separately.

### 6. NavBall orbital radial vector

The "radial" direction in orbital mode should arguably stay geocentric (pointing from body center), since it's an orbital mechanics concept. Only the surface-mode horizon should use the geodetic normal.

## The Subtlety: "Up" vs "Radial"

There are really two different concepts being conflated in the current code:

- **Surface normal ("up")** — perpendicular to the local ground/sea-level. On an ellipsoid, this is the geodetic normal. Affects: camera orientation, navball horizon, vessel attitude, "which way does gravity pull" visually.
- **Radial direction** — from body center through the vessel. Affects: orbital mechanics, gravity vector (point-mass gravity IS radial), SOI transitions.

For oblate bodies, gravity should remain radial (unless you add J2 perturbations), but "up" for the camera and navball should follow the geodetic normal. This means the camera horizon won't be exactly perpendicular to gravity — which is physically correct (on real Earth, a plumb bob doesn't point exactly at the center).

## Summary

Only **3 actual code locations** need modification, plus one design decision:

1. **`FlightGlobals.getUpAxis()`** — compute geodetic normal instead of radial (fixes Vessel.upAxis and FlightCamera.upAxis transitively)
2. **`FlightGlobals.UpdateInformation()`** line 822 — inline up calculation for ship heading
3. **`NavBall.cs`** line 110 — inline up calculation for horizon

**Design decision:** whether orbital-mode navball radial marker should use geodetic or geocentric direction (recommend: keep geocentric for orbital, geodetic for surface mode only).
