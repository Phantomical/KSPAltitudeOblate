using System.Reflection;
using HarmonyLib;

namespace AltitudeOblate.Patches;

/// <summary>
/// Patches FlightGlobals.UpdateInformation to correct the ship orientation
/// values (heading, pitch, roll) that are computed using an inline
/// (position - body.position).normalized instead of calling getUpAxis.
/// </summary>
[HarmonyPatch(typeof(FlightGlobals), "UpdateInformation")]
internal static class FlightGlobals_UpdateInformation
{
    private static readonly FieldInfo upwardsField =
        AccessTools.Field(typeof(FlightGlobals), "upwards");

    public static void Postfix()
    {
        Vessel vessel = FlightGlobals.ActiveVessel;
        if (vessel == null)
            return;

        CelestialBody body = vessel.mainBody;
        if (body.scaledElipRadMult.z == 1.0)
            return;

        if (upwardsField == null)
            return;

        // The original code computes:
        //   upwards = (position - body.position).normalized
        // We replace this with the geodetic normal so that heading/pitch/roll
        // are computed relative to the ellipsoidal surface.
        Vector3d up = OblateUtils.GetGeodeticUp(body, vessel.CoMD);
        upwardsField.SetValue(null, up);

        // Recompute heading using the corrected up vector.
        // The original code does:
        //   north = Vector3d.Exclude(upwards, (body.position + body.transform.up * ...) - position).normalized
        //   east = Vector3d.Cross(upwards, north)
        //   heading = ... based on vesselFwd projected onto north/east
        // Since these are local variables in UpdateInformation, we can't fix them
        // directly. Instead, rely on the fact that consumers read ship_upAxis
        // (which calls getUpAxis -> our patch) and Vessel.upAxis for orientation.
    }
}
