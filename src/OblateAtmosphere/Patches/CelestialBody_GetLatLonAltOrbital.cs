using System;
using HarmonyLib;

namespace OblateAtmosphere.Patches;

[HarmonyPatch(typeof(CelestialBody), nameof(CelestialBody.GetLatLonAltOrbital))]
internal static class CelestialBody_GetLatLonAltOrbital
{
    public static bool Prefix(
        CelestialBody __instance,
        Vector3d worldPos,
        ref double lat,
        ref double lon,
        ref double alt
    )
    {
        if (__instance.scaledElipRadMult.z == 1.0)
            return true;

        Vector3d rPos = __instance.BodyFrame.WorldToLocal(worldPos);
        double magnitude = rPos.magnitude;
        rPos /= magnitude;

        double latRad = Math.Asin(rPos.z);
        lat = latRad * UtilMath.Rad2Deg;
        lon = Math.Atan2(rPos.y, rPos.x) * UtilMath.Rad2Deg;

        if (double.IsNaN(lat))
            lat = 0.0;
        if (double.IsNaN(lon))
            lon = 0.0;

        alt = magnitude - OblateUtils.GetSeaLevelRadius(__instance, latRad);
        return false;
    }
}
