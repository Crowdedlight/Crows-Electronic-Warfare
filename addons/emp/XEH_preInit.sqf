#include "script_component.hpp"
#include "XEH_PREP.hpp"

ADDON = true;

// special helmets that has NV/TI, or launchers that has electronics. 
GVAR(electronicHelmets) = ["H_PilotHelmetFighter_B", "H_PilotHelmetFighter_O","H_HelmetO_ViperSP_ghex_F","H_PilotHelmetFighter_I","H_HelmetO_ViperSP_hex_F"];
GVAR(electronicLaunchers) = ["launch_RPG32_F","launch_Titan_base","launch_MRAWS_base_F","LOP_IA_Static_AT4","launch_O_Titan_F","launch_O_Titan_short_F","launch_MRAWS_sand_F","launch_NLAW_F","launch_B_Titan_short_F","launch_B_Titan_F","launch_B_Titan_short_tna_F","launch_B_Titan_tna_F","launch_MRAWS_green_F","launch_MRAWS_olive_rail_F","launch_I_Titan_short_F","launch_I_Titan_F","launch_RPG32_ghex_F","launch_O_Vorona_green_F","launch_O_Titan_short_ghex_F","launch_O_Titan_ghex_F","launch_O_Vorona_brown_F"];

GVAR(baseBinoculars) = ["rhsusf_bino_leopold_mk4","Binocular","rhsusf_bino_m24","rhsusf_bino_m24_ARD","ace_dragon_sight","rhs_tr8_periscope","rhs_tr8_periscope_pip","rhssaf_zrak_rd7j"];

// code to get base parent of weapons and split string to just the parent - Used for tests
// private _parentLauncher = str(inheritsFrom (configFile >> "CfgWeapons" >> secondaryWeapon _this));  
// _parentLauncher = ([_parentLauncher, "/"] call BIS_fnc_splitString); 
// _parentLauncher = _parentLauncher select (count _parentLauncher - 1); 
// diag_log (_parentLauncher);