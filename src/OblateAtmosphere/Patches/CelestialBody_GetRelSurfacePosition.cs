using System;
using HarmonyLib;

namespace OblateAtmosphere.Patches;

[HarmonyPatch(
    typeof(CelestialBody),
    nameof(CelestialBody.GetRelSurfacePosition),
    new[] { typeof(double), typeof(double), typeof(double) }
)]
internal static class CelestialBody_GetRelSurfacePosition
{
    public static bool Prefix(
        CelestialBody __instance,
        double lat,
        double lon,
        double alt,
        ref Vector3d __result
    )
    {
        if (__instance.scaledElipRadMult.z == 1.0)
            return true;

        double latRad = lat * UtilMath.Deg2Rad;
        double seaLevelR = OblateUtils.GetSeaLevelRadius(__instance, latRad);
        __result = __instance.GetRelSurfaceNVector(lat, lon) * (seaLevelR + alt);
        return false;
    }
}
