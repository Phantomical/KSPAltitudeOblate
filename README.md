# Altitude Oblate

A mod for Kerbal Space program that adds support for non-spherical atmospheres.
It does this by patching the game's altitude calculations to match those of an
oblate spheroid when configured.

## Features

- **Ellipsoidal altitude calculations** - Sea-level altitude varies by latitude,
  following the shape of an oblate spheroid
- **Per-body configuration** - Define oblateness for any celestial body via
  Kopernicus config files
- **Backward compatible** - Bodies without oblateness configured behave exactly
  as stock KSP
- **Performance optimized** - Fast-path skips all extra math for spherical bodies

## Dependencies

- [Kopernicus](https://github.com/Kopernicus/Kopernicus)
- [HarmonyKSP](https://github.com/KSPModdingLibs/HarmonyKSP)

## Installation

Download the latest release from [GitHub Releases][releases], then extract the
`GameData` folder into your KSP installation directory.

[releases]: https://github.com/Phantomical/AltitudeOblate/releases

## Configuration

Oblateness is configured per-body through Kopernicus config files. For example,
to make Kerbin oblate:

```
@Body[Kerbin]
{
    @PQS
    {
        Mods
        {
            AltitudeOblate
            {
                polarRadius = 588000
            }
        }
    }
}
```

The `polarRadius` is specified in meters. The equatorial radius is taken from the
body's existing `Radius` property. Setting `polarRadius` equal to `Radius` (or
omitting the mod entirely) results in a standard spherical body.

## How It Works

The mod uses Harmony to patch KSP's core altitude calculation methods on
`CelestialBody`, `FlightGlobals`, and `Vessel`. When a body is configured as
oblate, these patches replace the fixed reference radius with a latitude-dependent
radius derived from the standard ellipsoid formula.

Key design decisions:
- **Orbital altitude remains spherical** - Orbit calculations continue to use the
  equatorial radius, so orbital displays don't oscillate
- **Surface altitude follows the ellipsoid** - Ground-level altitude varies by
  latitude as expected for an oblate body
- **Atmosphere follows the ellipsoid** - Atmospheric boundaries match the surface
  shape

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for build instructions and contribution
guidelines.
