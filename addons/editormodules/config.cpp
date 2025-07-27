#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {
            QGVAR(moduleAddSignalSource),
            QGVAR(moduleAddJammer),
            QGVAR(moduleFireEMP),
            QGVAR(moduleImmuneEMP),
            QGVAR(moduleRadioTrackerChatter),
            QGVAR(moduleSetJammable),
            QGVAR(moduleSetTrackingTfar)            
        };
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"crowsEW_main", "crowsEW_spectrum"};
        author = "Crowdedlight";
        VERSION_CONFIG;
    };
};

#include "CfgEventhandlers.hpp"
#include "CfgFactionClasses.hpp"
#include "CfgVehicles.hpp"
