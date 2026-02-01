using System.Collections.Generic;
using System.Reflection.Emit;
using HarmonyLib;
using UnityEngine;

namespace AltitudeOblate.Patches;

/// <summary>
/// Patches FlightGlobals.UpdateInformation to use the geodetic surface normal
/// instead of the radial direction when computing ship orientation and heading.
///
/// The original method computes (vessel.position - body.position).normalized
/// twice: once as the plane normal for the north-direction ProjectOnPlane, and
/// once as the "upwards" vector for Quaternion.LookRotation. Both are replaced
/// with the geodetic up.
/// </summary>
[HarmonyPatch(typeof(FlightGlobals), "UpdateInformation")]
internal static class FlightGlobals_UpdateInformation
{
    public static Vector3d GetUp(Vector3 vesselPos, Vector3d bodyPos, CelestialBody body)
    {
        if (OblateUtils.IsSpherical(body))
            return ((Vector3d)vesselPos - bodyPos).normalized;

        return OblateUtils.GetGeodeticUp(body, (Vector3d)vesselPos);
    }

    static IEnumerable<CodeInstruction> Transpiler(IEnumerable<CodeInstruction> instructions)
    {
        var subtractV3_V3d = AccessTools.Method(
            typeof(Vector3d),
            "op_Subtraction",
            [typeof(Vector3), typeof(Vector3d)]
        );
        var getNormalized = AccessTools.PropertyGetter(
            typeof(Vector3d),
            nameof(Vector3d.normalized)
        );
        var helper = SymbolExtensions.GetMethodInfo(() => GetUp(default, default, default));
        var currentMainBody = AccessTools.Field(
            typeof(FlightGlobals),
            nameof(FlightGlobals.currentMainBody)
        );

        return new CodeMatcher(instructions)
            .MatchStartForward(
                new CodeMatch(OpCodes.Call, subtractV3_V3d),
                new CodeMatch(OpCodes.Dup),
                new CodeMatch(OpCodes.Pop),
                new CodeMatch(i => i.IsStloc(null)),
                new CodeMatch(i => i.IsLdloc(null)),
                new CodeMatch(OpCodes.Call, getNormalized)
            )
            .ThrowIfInvalid(
                "Could not find (vessel.position - body.position).normalized pattern in FlightGlobals.UpdateInformation"
            )
            .Repeat(matcher =>
            {
                matcher
                    .RemoveInstructions(6)
                    .Insert(
                        new CodeInstruction(OpCodes.Ldsfld, currentMainBody),
                        new CodeInstruction(OpCodes.Call, helper)
                    );
            })
            .InstructionEnumeration();
    }
}
