#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = QUOTE(COMPONENT);
        units[] = {
            "crowsew_ctrack_effect",
            "crowsew_ctrack_effect_2km"
        };
        weapons[] = {
            "crowsew_tfar_icom", 
            "crowsew_ctrack"
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
#include "CfgSoundsPolice.hpp"
#include "CfgSoundsAlienElectronic.hpp"
#include "CfgSoundsElectronic.hpp"
#include "CfgSoundsMorseCode.hpp"
#include "CfgSoundsBritish.hpp"

#include "radio_ids.hpp"
#include "CfgWeapons.hpp"
#include "CfgVehicles.hpp"
