using HarmonyLib;

namespace AltitudeOblate.Patches;

[HarmonyPatch(typeof(FlightGlobals), nameof(FlightGlobals.getUpAxis))]
internal static class FlightGlobals_getUpAxis
{
    public static bool Prefix(CelestialBody body, Vector3d position, ref Vector3d __result)
    {
        if (body.scaledElipRadMult.z == 1.0)
            return true;

        __result = OblateUtils.GetGeodeticUp(body, position);
        return false;
    }
}
