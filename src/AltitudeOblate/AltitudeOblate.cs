using Kopernicus.ConfigParser.Attributes;
using Kopernicus.ConfigParser.BuiltinTypeParsers;
using Kopernicus.ConfigParser.Enumerations;
using Kopernicus.Configuration.ModLoader;

namespace AltitudeOblate;

[RequireConfigType(ConfigType.Node)]
public class AltitudeOblate : ModLoader<PQSMod_AltitudeOblate>
{
    [ParserTarget("polarRadius")]
    public NumericParser<double> PolarRadius
    {
        get { return Mod.polarRadius; }
        set { Mod.polarRadius = value; }
    }

    [ParserTarget("equatorialRadius")]
    public NumericParser<double> EquatorialRadius
    {
        get { return Mod.equatorialRadius; }
        set { Mod.equatorialRadius = value; }
    }
}
