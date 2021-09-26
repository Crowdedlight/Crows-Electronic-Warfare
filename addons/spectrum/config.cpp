#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = QUOTE(COMPONENT);
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"crowsEW_main", "crowsEW_zeus", "A3_Data_F_AoW_Loadorder"};
        author = "Crowdedlight";
        VERSION_CONFIG;
    };
};

#include "CfgEventhandlers.hpp"
#include "CfgSounds.hpp"
#include "CfgSoundsPolice.hpp"
#include "CfgSoundsAlienElectronic.hpp"
#include "CfgSoundsElectronic.hpp"
#include "CfgSoundsMorseCode.hpp"
#include "CfgSoundsBritish.hpp"
#include "CfgWeapons.hpp"