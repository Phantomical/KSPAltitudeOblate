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
        if (body.scaledElipRadMult.z == 1.0)
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

        // Match the IL pattern for (vessel.position - body.position).normalized:
        //
        //   call      Vector3d.op_Subtraction(Vector3, Vector3d)
        //   dup; pop
        //   stloc.2
        //   ldloca.s  2
        //   call      Vector3d.get_normalized()
        //   dup; pop
        //
        // The subsequent op_Implicit(Vector3d → Vector3) is left in place.
        //
        // Replaced with:
        //   ldsfld    FlightGlobals.currentMainBody
        //   call      GetUp(Vector3, Vector3d, CelestialBody) -> Vector3d
        return new CodeMatcher(instructions)
            .MatchStartForward(
                new CodeMatch(i => i.Calls(subtractV3_V3d)),
                new CodeMatch(OpCodes.Dup),
                new CodeMatch(OpCodes.Pop),
                new CodeMatch(i => i.IsStloc(null)),
                new CodeMatch(i => i.IsLdloc(null)),
                new CodeMatch(i => i.Calls(getNormalized))
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
