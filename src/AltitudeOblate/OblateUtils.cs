using System;
using UnityEngine;

namespace AltitudeOblate;

public static class OblateUtils
{
    public static bool IsSpherical(CelestialBody body) =>
        body.scaledElipRadMult.x == 1.0 && body.scaledElipRadMult.z == 1.0;

    public static double GetSeaLevelRadius(CelestialBody body, double latitudeRad)
    {
        if (IsSpherical(body))
            return body.Radius;

        double a = body.scaledElipRadMult.x * body.Radius;
        double b = body.scaledElipRadMult.z * body.Radius;
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
        if (IsSpherical(body))
            return body.Radius;

        double sinLat = localDir.z / magnitude;
        double latRad = Math.Asin(sinLat);
        return GetSeaLevelRadius(body, latRad);
    }

    /// <summary>
    /// Returns the spherical altitude (distance from body center minus equatorial
    /// Radius). Used by buoyancy, which must match the spherical ocean mesh.
    /// </summary>
    public static double GetAltitudeAtPosSpherical(Vector3d position, CelestialBody body) =>
        Vector3d.Distance(position, body.position) - body.Radius;

    public static float GetAltitudeAtPosSpherical(Vector3 position, CelestialBody body) =>
        (float)GetAltitudeAtPosSpherical((Vector3d)position, body);

    /// <summary>
    /// Computes the geodetic surface normal (true "up") for an oblate body at the
    /// given world position. For spherical bodies, returns the radial direction.
    /// </summary>
    public static Vector3d GetGeodeticUp(CelestialBody body, Vector3d worldPos)
    {
        if (IsSpherical(body))
            return (worldPos - body.position).normalized;

        Vector3d relPos = worldPos - body.position;
        // Convert to body-local coordinates (note the .xzy swizzle that KSP uses)
        Vector3d local = body.BodyFrame.WorldToLocal(relPos.xzy);

        // Geodetic normal on ellipsoid: scale each component by 1/axis²
        double a = body.scaledElipRadMult.x * body.Radius;
        double b = body.scaledElipRadMult.z * body.Radius;
        double a2 = a * a;
        double b2 = b * b;

        Vector3d normal = new Vector3d(local.x / a2, local.y / a2, local.z / b2);
        normal = normal.normalized;

        // Transform back to world coordinates (inverse of the .xzy + WorldToLocal)
        return body.BodyFrame.LocalToWorld(normal).xzy.normalized;
    }
}
