using Kopernicus;

namespace AltitudeOblate;

public class PQSMod_AltitudeOblate : PQSMod
{
    public double polarRadius;

    public override void OnSetup()
    {
        var body = Utility.GetCelestialBody(sphere);
        body.scaledElipRadMult = new Vector3d(1.0, 1.0, polarRadius / body.Radius);
    }
}
