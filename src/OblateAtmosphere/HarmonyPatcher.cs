using HarmonyLib;
using UnityEngine;

namespace AltitudeOblate;

[KSPAddon(KSPAddon.Startup.Instantly, once: true)]
public class AltitudeOblate : MonoBehaviour
{
    public void Awake()
    {
        var harmony = new Harmony("AltitudeOblate");
        harmony.PatchAll();
    }
}
