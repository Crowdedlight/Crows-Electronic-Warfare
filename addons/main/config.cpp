#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {"Crows_dataterminal"};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main", "zen_main"};
        author = "Crowdedlight";
        VERSION_CONFIG;
    };
};


PRELOAD_ADDONS;

#include "CfgEventhandlers.hpp"
#include "CfgUnitInsignia.hpp"
#include "CfgVehicles.hpp"