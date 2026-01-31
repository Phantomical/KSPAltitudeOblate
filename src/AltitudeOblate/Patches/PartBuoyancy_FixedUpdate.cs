using System;
using System.Collections.Generic;
using System.Reflection.Emit;
using HarmonyLib;
using UnityEngine;

namespace AltitudeOblate.Patches;

/// <summary>
/// Replaces all FlightGlobals.getAltitudeAtPos calls in PartBuoyancy.FixedUpdate
/// with OblateUtils.GetAltitudeAtPosSpherical. The ocean mesh is rendered by PQS
/// which is spherical, so buoyancy depth must use spherical altitude to match.
/// </summary>
[HarmonyPatch(typeof(PartBuoyancy), "FixedUpdate")]
internal static class PartBuoyancy_FixedUpdate
{
    static IEnumerable<CodeInstruction> Transpiler(IEnumerable<CodeInstruction> instructions)
    {
        var altDouble = SymbolExtensions.GetMethodInfo(() =>
            FlightGlobals.getAltitudeAtPos(default(Vector3d), default)
        );
        var altFloat = SymbolExtensions.GetMethodInfo(() =>
            FlightGlobals.getAltitudeAtPos(default(Vector3), default)
        );

        var sphericalDouble = SymbolExtensions.GetMethodInfo(() =>
            OblateUtils.GetAltitudeAtPosSpherical(default(Vector3d), default)
        );
        var sphericalFloat = SymbolExtensions.GetMethodInfo(() =>
            OblateUtils.GetAltitudeAtPosSpherical(default(Vector3), default)
        );

        return new CodeMatcher(instructions)
            .MatchStartForward(new CodeMatch(OpCodes.Call, altDouble))
            .Repeat(m => m.SetOperandAndAdvance(sphericalDouble))
            .Start()
            .MatchStartForward(new CodeMatch(OpCodes.Call, altFloat))
            .Repeat(m => m.SetOperandAndAdvance(sphericalFloat))
            .InstructionEnumeration();
    }
}
