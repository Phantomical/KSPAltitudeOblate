using HarmonyLib;
using UnityEngine;

namespace OblateAtmosphere;

[KSPAddon(KSPAddon.Startup.Flight, false)]
public class OblateAtmosphere : MonoBehaviour
{
    private static Harmony _harmony;

    public void Start()
    {
        if (_harmony == null)
        {
            _harmony = new Harmony("OblateAtmosphere");
            _harmony.PatchAll();
            Debug.Log("[OblateAtmosphere] Harmony patches applied");
        }
    }
}
