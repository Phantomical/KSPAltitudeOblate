using UnityEngine;

namespace OblateAtmosphere
{
    [KSPAddon(KSPAddon.Startup.Flight, false)]
    public class OblateAtmosphere : MonoBehaviour
    {
        public void Start()
        {
            Debug.Log("[OblateAtmosphere] Loaded");
        }
    }
}
