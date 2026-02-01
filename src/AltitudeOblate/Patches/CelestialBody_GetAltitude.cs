using System;
using HarmonyLib;

namespace AltitudeOblate.Patches;

[HarmonyPatch(typeof(CelestialBody), nameof(CelestialBody.GetAltitude))]
internal static class CelestialBody_GetAltitude
{
    public static bool Prefix(CelestialBody __instance, Vector3d worldPos, ref double __result)
    {
        if (OblateUtils.IsSpherical(__instance))
            return true;

        Vector3d relPos = worldPos - __instance.position;
        double magnitude = relPos.magnitude;
        Vector3d localDir = __instance.BodyFrame.WorldToLocal(relPos.xzy);
        double seaLevelR = OblateUtils.GetSeaLevelRadiusFromLocalDir(
            __instance,
            localDir,
            magnitude
        );
        __result = magnitude - seaLevelR;
        return false;
    }
}
