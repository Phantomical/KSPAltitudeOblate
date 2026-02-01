using Kopernicus;

namespace AltitudeOblate;

public class PQSMod_AltitudeOblate : PQSMod
{
    public double polarRadius;
    public double equatorialRadius;

    public override void OnSetup()
    {
        var body = Utility.GetCelestialBody(sphere);
        double x = equatorialRadius > 0 ? equatorialRadius / body.Radius : 1.0;
        double z = polarRadius > 0 ? polarRadius / body.Radius : 1.0;
        body.scaledElipRadMult = new Vector3d(x, x, z);
    }
}
