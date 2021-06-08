#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = QUOTE(COMPONENT);
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main", "zen_main", "task_force_radio"};
        author = "Crowdedlight";
        VERSION_CONFIG;
    };
};
#include "CfgFactionClasses.hpp"