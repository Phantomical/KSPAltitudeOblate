using HarmonyLib;

namespace OblateAtmosphere.Patches;

[HarmonyPatch(typeof(FlightGlobals), nameof(FlightGlobals.getAltitudeAtPos))]
internal static class FlightGlobals_getAltitudeAtPos
{
    public static bool Prefix(Vector3d position, CelestialBody body, ref double __result)
    {
        if (body.scaledElipRadMult.z == 1.0)
            return true;

        __result = body.GetAltitude(position);
        return false;
    }
}
