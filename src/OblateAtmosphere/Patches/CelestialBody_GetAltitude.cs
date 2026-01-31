using System;
using HarmonyLib;

namespace OblateAtmosphere.Patches
{
    [HarmonyPatch(typeof(CelestialBody), nameof(CelestialBody.GetAltitude))]
    public static class CelestialBody_GetAltitude
    {
        public static bool Prefix(
            CelestialBody __instance,
            Vector3d worldPos,
            ref double __result
        )
        {
            if (__instance.scaledElipRadMult.z == 1.0)
                return true;

            Vector3d relPos = worldPos - __instance.position;
            double magnitude = relPos.magnitude;
            Vector3d localDir = __instance.BodyFrame.WorldToLocal(
                relPos.xzy
            );
            double seaLevelR =
                OblateUtils.GetSeaLevelRadiusFromLocalDir(
                    __instance,
                    localDir,
                    magnitude
                );
            __result = magnitude - seaLevelR;
            return false;
        }
    }
}
