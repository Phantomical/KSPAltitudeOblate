using System;
using HarmonyLib;

namespace OblateAtmosphere.Patches
{
    [HarmonyPatch(typeof(CelestialBody))]
    public static class CelestialBody_GetRelSurfacePosition
    {
        [HarmonyPatch(
            nameof(CelestialBody.GetRelSurfacePosition),
            new[] { typeof(double), typeof(double), typeof(double) }
        )]
        [HarmonyPrefix]
        public static bool Prefix3(
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
            double seaLevelR = OblateUtils.GetSeaLevelRadius(
                __instance,
                latRad
            );
            __result =
                __instance.GetRelSurfaceNVector(lat, lon)
                * (seaLevelR + alt);
            return false;
        }
    }
}
