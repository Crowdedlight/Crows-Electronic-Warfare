#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = QUOTE(COMPONENT);
        units[] = {"Crows_Emp_Device"};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"crowsEW_main", "crowsEW_zeus", "A3_Data_F_AoW_Loadorder"};
        author = "Crowdedlight";
        VERSION_CONFIG;
    };
};

PRELOAD_ADDONS;

#include "CfgEventhandlers.hpp"
#include "CfgSounds.hpp"
#include "CfgVehicles.hpp"
