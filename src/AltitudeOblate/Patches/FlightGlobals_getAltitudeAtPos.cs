using System;
using HarmonyLib;

namespace AltitudeOblate.Patches;

[HarmonyPatch(typeof(FlightGlobals), nameof(FlightGlobals.getAltitudeAtPos),
    new Type[] { typeof(Vector3d), typeof(CelestialBody) })]
internal static class FlightGlobals_getAltitudeAtPos
{
    public static bool Prefix(Vector3d position, CelestialBody body, ref double __result)
    {
        if (OblateUtils.IsSpherical(body))
            return true;

        __result = body.GetAltitude(position);
        return false;
    }
}
