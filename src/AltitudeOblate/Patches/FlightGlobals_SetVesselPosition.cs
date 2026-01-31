using System;
using System.Collections.Generic;
using System.Reflection.Emit;
using HarmonyLib;

namespace AltitudeOblate.Patches;

/// <summary>
/// Patches FlightGlobals.SetVesselPosition to use the oblate sea-level radius
/// instead of the equatorial Radius when computing terrain height.
///
/// The original code computes terrain height as:
///   pqsController.GetSurfaceHeight(nVector) - currentMainBody.Radius
///
/// On an oblate body the PQS surface height includes the oblate deformation,
/// so subtracting the equatorial radius gives the wrong terrain altitude
/// (too negative at the poles). We replace currentMainBody.Radius with the
/// latitude-dependent sea-level radius.
/// </summary>
[HarmonyPatch(typeof(FlightGlobals), nameof(FlightGlobals.SetVesselPosition),
    new Type[] { typeof(int), typeof(double), typeof(double), typeof(double),
                 typeof(UnityEngine.Vector3), typeof(bool), typeof(bool), typeof(double) })]
internal static class FlightGlobals_SetVesselPosition
{
    public static double GetRadius(CelestialBody body, double latitude)
    {
        if (body.scaledElipRadMult.z == 1.0)
            return body.Radius;

        double latRad = latitude * UtilMath.Deg2Rad;
        return OblateUtils.GetSeaLevelRadius(body, latRad);
    }

    static IEnumerable<CodeInstruction> Transpiler(IEnumerable<CodeInstruction> instructions)
    {
        var getSurfaceHeight = SymbolExtensions.GetMethodInfo(
            () => default(PQS).GetSurfaceHeight(default(Vector3d))
        );
        var radiusField = AccessTools.Field(typeof(CelestialBody), nameof(CelestialBody.Radius));
        var helper = SymbolExtensions.GetMethodInfo(() => GetRadius(default, default));

        return new CodeMatcher(instructions)
            .MatchStartForward(
                new CodeMatch(i => i.Calls(getSurfaceHeight))
            )
            .ThrowIfInvalid(
                "Could not find GetSurfaceHeight call in FlightGlobals.SetVesselPosition")
            .MatchStartForward(
                new CodeMatch(OpCodes.Ldfld, radiusField)
            )
            .ThrowIfInvalid(
                "Could not find Radius field load after GetSurfaceHeight in FlightGlobals.SetVesselPosition")
            .RemoveInstruction()
            .Insert(
                new CodeInstruction(OpCodes.Ldarg_2),
                new CodeInstruction(OpCodes.Call, helper)
            )
            .InstructionEnumeration();
    }
}
