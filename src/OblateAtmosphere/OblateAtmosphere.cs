using HarmonyLib;
using UnityEngine;

namespace OblateAtmosphere;

[KSPAddon(KSPAddon.Startup.Instantly, once: true)]
public class OblateAtmosphere : MonoBehaviour
{
    public void Awake()
    {
        var harmony = new Harmony("OblateAtmosphere");
        harmony.PatchAll();
    }
}
