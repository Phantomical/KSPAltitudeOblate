using Kopernicus.ConfigParser.Attributes;
using Kopernicus.ConfigParser.BuiltinTypeParsers;
using Kopernicus.ConfigParser.Enumerations;
using Kopernicus.Configuration.ModLoader;

namespace OblateAtmosphere;

[RequireConfigType(ConfigType.Node)]
public class AltitudeOblate : ModLoader<PQSMod_AltitudeOblate>
{
    [ParserTarget("polarRadius")]
    public NumericParser<double> PolarRadius
    {
        get { return Mod.polarRadius; }
        set { Mod.polarRadius = value; }
    }
}
