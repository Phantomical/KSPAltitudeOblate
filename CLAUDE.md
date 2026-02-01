# CLAUDE.md

KSP mod that patches altitude calculations to support oblate (ellipsoidal) celestial bodies via Harmony and Kopernicus.

## Build

IMPORTANT: Always build the solution, never individual csproj files:

```
dotnet build AltitudeOblate.sln
```

Requires `KSPRoot` MSBuild property pointing to a KSP install with Harmony and Kopernicus. Build output goes to `GameData/AltitudeOblate/` at the repo root.

## Key conventions

- All Harmony patches must use `OblateUtils.IsSpherical(body)` to short-circuit for spherical bodies (preserves stock behavior and performance).
- Prefix patches return `false` to skip the original method; return `true` to run it (for the spherical fast-path).
- Transpiler patches use `CodeMatcher` from Harmony to replace IL instructions.
- `CelestialBody.scaledElipRadMult` stores the ellipsoid axes as ratios to `body.Radius`: `.x` and `.y` = `equatorialRadius / body.Radius`, `.z` = `polarRadius / body.Radius`. Both default to 1.0 if unset.
