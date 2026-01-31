using System;
using HarmonyLib;

namespace OblateAtmosphere.Patches;

[HarmonyPatch(typeof(CelestialBody), nameof(CelestialBody.TerrainAltitude))]
public static class CelestialBody_TerrainAltitude
{
    public static bool Prefix(
        CelestialBody __instance,
        double latitude,
        double longitude,
        bool allowNegative,
        ref double __result
    )
    {
        if (__instance.scaledElipRadMult.z == 1.0)
            return true;

        if (__instance.pqsController == null)
        {
            __result = 0.0;
            return false;
        }

        Vector3d relSurfaceNVector = __instance.GetRelSurfaceNVector(latitude, longitude);
        double surfaceHeight = __instance.pqsController.GetSurfaceHeight(relSurfaceNVector);
        double latRad = latitude * UtilMath.Deg2Rad;
        double seaLevelR = OblateUtils.GetSeaLevelRadius(__instance, latRad);
        double num = surfaceHeight - seaLevelR;

        if (!allowNegative && num < 0.0)
            num = 0.0;

        __result = num;
        return false;
    }
}
