# Altitude Oblate

A mod for Kerbal Space program that adds support for non-spherical atmospheres.
It does this by patching the game's altitude calculations to match those of an
oblate spheroid when configured.

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

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for build instructions and contribution
guidelines.
