#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_unitRemoveItems.sqf
Parameters: _unit
Return: none

Removes electronic items from unit

*///////////////////////////////////////////////
params ["_unit"];

// remove equipment
_unit removeWeaponGlobal "Rangefinder";
_unit removeWeaponGlobal "Laserdesignator"; 

// remove attachments of electronic variaty
{
	_unit removePrimaryWeaponItem _x;
	_unit removeHandgunItem _x;
} forEach ["acc_pointer_IR","acc_flashlight","optic_Nightstalker","optic_NVS","optic_tws","	optic_tws_mg","acc_esd_01_flashlight_broken","acc_flashlight_smg_01","acc_flashlight_pistol","rhsusf_acc_anpeq15_wmx_light"];

// remove if electronic helmet
if (headgear _unit in GVAR(electronicHelmets)) then {removeHeadgear _unit};

// remove if launcher is electronic
if (secondaryWeapon _unit in GVAR(electronicLaunchers)) then {_unit removeWeaponGlobal (secondaryWeapon _unit)};

// unassign and remove items
{
	_unit unassignItem _x; //some will fail, but that should be fine and it will carry on per WIKI
	_unit removeItems _x;
} forEach ["Rangefinder", 
			"Laserdesignator","	Laserdesignator_02","Laserdesignator_03","Laserdesignator_01_khk_F",
			"ItemGPS", "ItemRadio","TFAR_anprc152_6",
			"NVGoggles","O_NVGoggles_hex_F","O_NVGoggles_urb_F","O_NVGoggles_ghex_F","NVGoggles_OPFOR","NVGoggles_INDEP","NVGoggles_tna_F","NVGogglesB_blk_F","NVGogglesB_grn_F","NVGogglesB_gry_F","Integrated_NVG_F","Integrated_NVG_TI_0_F","Integrated_NVG_TI_1_F",
			"MineDetector","B_UavTerminal","O_UavTerminal","I_UavTerminal","C_UavTerminal","I_E_UavTerminal"
		];


// if its own, we can turn the shoulder mounted light off by calling: _this call UDM_fnc_diveLightOnOff; 