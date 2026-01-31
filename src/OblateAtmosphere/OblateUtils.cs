using System;

namespace OblateAtmosphere;

public static class OblateUtils
{
    public static double GetSeaLevelRadius(CelestialBody body, double latitudeRad)
    {
        double f = body.scaledElipRadMult.z;
        if (f == 1.0)
            return body.Radius;

        double a = body.Radius;
        double b = f * a;
        double a2 = a * a;
        double b2 = b * b;
        double cos = Math.Cos(latitudeRad);
        double sin = Math.Sin(latitudeRad);
        double cos2 = cos * cos;
        double sin2 = sin * sin;
        return Math.Sqrt((a2 * a2 * cos2 + b2 * b2 * sin2) / (a2 * cos2 + b2 * sin2));
    }

    public static double GetSeaLevelRadiusFromLocalDir(
        CelestialBody body,
        Vector3d localDir,
        double magnitude
    )
    {
        if (body.scaledElipRadMult.z == 1.0)
            return body.Radius;

        double sinLat = localDir.z / magnitude;
        double latRad = Math.Asin(sinLat);
        return GetSeaLevelRadius(body, latRad);
    }
}
