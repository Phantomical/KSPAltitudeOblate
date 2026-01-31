using System;
using HarmonyLib;

namespace OblateAtmosphere.Patches
{
    [HarmonyPatch(typeof(Vessel), nameof(Vessel.PQSAltitude))]
    public static class Vessel_PQSAltitude
    {
        public static bool Prefix(Vessel __instance, ref double __result)
        {
            if (__instance.mainBody.scaledElipRadMult.z == 1.0)
                return true;

            if (__instance.mainBody.pqsController == null)
            {
                __result = -1.0;
                return false;
            }

            Vector3d relSurfaceNVector =
                __instance.mainBody.GetRelSurfaceNVector(
                    __instance.latitude,
                    __instance.longitude
                );
            double surfaceHeight =
                __instance.mainBody.pqsController.GetSurfaceHeight(
                    relSurfaceNVector
                );
            double latRad = __instance.latitude * UtilMath.Deg2Rad;
            double seaLevelR = OblateUtils.GetSeaLevelRadius(
                __instance.mainBody,
                latRad
            );
            __result = surfaceHeight - seaLevelR;
            return false;
        }
    }
}
