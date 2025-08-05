#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {
            "crowsew_ctrack_effect",
            "crowsew_ctrack_effect_2km"
        };
        weapons[] = {
            "crowsew_tfar_icom", 
            "crowsew_ctrack",
            "crowsew_cmotion"
        };
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"crowsEW_main", "crowsEW_zeus", "A3_Data_F_AoW_Loadorder"};
        author = "Crowdedlight";
        VERSION_CONFIG;
    };
};

PRELOAD_ADDONS;

#include "CfgEventhandlers.hpp"
#include "CfgSounds.hpp"

#include "radio_ids.hpp"
#include "CfgWeapons.hpp"
#include "CfgVehicles.hpp"
