using System.Collections.Generic;
using System.Reflection.Emit;
using HarmonyLib;
using KSP.UI.Screens.Flight;
using UnityEngine;

namespace AltitudeOblate.Patches;

/// <summary>
/// Corrects the navball horizon to follow the geodetic normal rather than the
/// radial direction on oblate bodies.
///
/// NavBall.Update computes the "up" direction used for the horizon as
///     (target.position - currentMainBody.position).normalized
/// in two places (for ProjectOnPlane and LookRotation). This transpiler
/// replaces both with a call to the geodetic up computation.
/// </summary>
[HarmonyPatch(typeof(NavBall), "Update")]
internal static class NavBall_Update
{
    /// <summary>
    /// Helper called by the transpiled code. Takes the same inputs that were on
    /// the stack (target position as Vector3, body position as Vector3d) plus the
    /// body from local var 0, and returns the geodetic up as Vector3.
    ///
    /// The original code computed: (targetPos - bodyPos).normalized converted to Vector3.
    /// We replace that with the geodetic normal at targetPos.
    /// </summary>
    public static Vector3 GetNavBallUp(Vector3 targetPos, Vector3d bodyPos, CelestialBody body)
    {
        if (body.scaledElipRadMult.z == 1.0)
            return (Vector3)(((Vector3d)targetPos - bodyPos).normalized);

        return (Vector3)OblateUtils.GetGeodeticUp(body, (Vector3d)targetPos);
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
        var implicitV3dToV3 = AccessTools.Method(
            typeof(Vector3d),
            "op_Implicit",
            [typeof(Vector3d)]
        );
        var helper = SymbolExtensions.GetMethodInfo(() => GetNavBallUp(default, default, default));

        // Match the IL pattern for (target.position - body.position).normalized
        // cast to Vector3. The dup/pop pairs are from the obfuscated IL.
        //
        // Original IL:
        //   call      Vector3d.op_Subtraction(Vector3, Vector3d)
        //   dup; pop
        //   stloc.1
        //   ldloca.s  1
        //   call      Vector3d.get_normalized()
        //   dup; pop
        //   call      Vector3d.op_Implicit(Vector3d)
        //   dup; pop
        //
        // Replaced with:
        //   ldloc.0              ; push CelestialBody from local 0
        //   call GetNavBallUp    ; (Vector3, Vector3d, CelestialBody) -> Vector3
        return new CodeMatcher(instructions)
            .MatchStartForward(
                new CodeMatch(i => i.Calls(subtractV3_V3d)),
                new CodeMatch(OpCodes.Dup),
                new CodeMatch(OpCodes.Pop),
                new CodeMatch(i => i.IsStloc(null)),
                new CodeMatch(i => i.IsLdloc(null)),
                new CodeMatch(i => i.Calls(getNormalized)),
                new CodeMatch(OpCodes.Dup),
                new CodeMatch(OpCodes.Pop),
                new CodeMatch(i => i.Calls(implicitV3dToV3)),
                new CodeMatch(OpCodes.Dup),
                new CodeMatch(OpCodes.Pop)
            )
            .ThrowIfInvalid(
                "Could not find (target.position - body.position).normalized pattern in NavBall.Update"
            )
            .Repeat(matcher =>
            {
                matcher
                    .RemoveInstructions(11)
                    .Insert(
                        new CodeInstruction(OpCodes.Ldloc_0),
                        new CodeInstruction(OpCodes.Call, helper)
                    );
            })
            .InstructionEnumeration();
    }
}
