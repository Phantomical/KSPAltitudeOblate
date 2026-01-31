using System;
using HarmonyLib;

namespace AltitudeOblate.Patches;

[HarmonyPatch(typeof(Vessel), "getCorrectedLandedAltitude")]
internal static class Vessel_getCorrectedLandedAltitude
{
    public static bool Prefix(
        Vessel __instance,
        double lat,
        double lon,
        double alt,
        CelestialBody body,
        ref double __result
    )
    {
        if (body.scaledElipRadMult.z == 1.0)
            return true;

        Vector3d relSurfaceNVector = body.GetRelSurfaceNVector(lat, lon);
        double surfaceHeight = body.pqsController.GetSurfaceHeight(relSurfaceNVector);
        double latRad = lat * UtilMath.Deg2Rad;
        double seaLevelR = OblateUtils.GetSeaLevelRadius(body, latRad);
        double val = surfaceHeight - seaLevelR;
        __result = Math.Max(alt, val);
        return false;
    }
}
