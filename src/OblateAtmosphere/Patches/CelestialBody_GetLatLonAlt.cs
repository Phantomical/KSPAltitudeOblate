using System;
using HarmonyLib;

namespace OblateAtmosphere.Patches
{
    [HarmonyPatch(typeof(CelestialBody), nameof(CelestialBody.GetLatLonAlt))]
    public static class CelestialBody_GetLatLonAlt
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

            Vector3d rPos = __instance.BodyFrame.WorldToLocal(
                (worldPos - __instance.position).xzy
            );
            double magnitude = rPos.magnitude;
            rPos /= magnitude;

            lat = Math.Asin(rPos.z) * (180.0 / Math.PI);
            lon = Math.Atan2(rPos.y, rPos.x) * (180.0 / Math.PI);

            if (double.IsNaN(lat))
                lat = 0.0;
            if (double.IsNaN(lon))
                lon = 0.0;

            double latRad = lat * (Math.PI / 180.0);
            alt =
                magnitude
                - OblateUtils.GetSeaLevelRadius(__instance, latRad);
            return false;
        }
    }
}
