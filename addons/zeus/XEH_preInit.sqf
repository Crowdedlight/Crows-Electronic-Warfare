#include "script_component.hpp"
#include "XEH_PREP.hpp"

ADDON = true;

// initial value for vars. Text display is by default enabled
GVAR(zeusTextDisplay) = true;

GVAR(zeusTextBeaconMap) = createHashMap;

// check if mods are loaded and set variable
GVAR(hasTFAR) = isClass (configFile >> "CfgPatches" >> "task_force_radio");
GVAR(hasACRE) = isClass (configFile >> "CfgPatches" >> "acre_main");
GVAR(hasAce) = isClass (configFile >> "CfgPatches" >> "ace_main");
GVAR(hasItcLandSystems) = isClass (configFile >> "CfgPatches" >> "itc_land_common");