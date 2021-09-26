#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_getNearestElements.sqf
Parameters: obj, range
Return: [vehicles, lights, turrents, units]

[_this, 500] call crowsEW_emp_fnc_getNearestElements;

*///////////////////////////////////////////////
params ["_pos", "_range"];

private _vehicleList = _pos nearEntities [["Car","Motorcycle","Tank","Air","Ship","Helicopter","Plane"], _range];
private _manList = _pos nearEntities [["Man","Civilian","SoldierGB","SoldierEB","SoldierWB"], _range];
private _lightList = nearestObjects [_pos, ["Lamps_Base_F", "ITC_Land_Loudspeakers", "PowerLines_base_F", "Land_PowerPoleWooden_F", "Land_LampHarbour_F", "Land_LampShabby_F", "Land_PowerPoleWooden_L_F", "Land_PowerPoleWooden_small_F", 
											"Land_LampDecor_F", "Land_LampHalogen_F", "Land_LampSolar_F", "Land_LampStreet_small_F", "Land_LampStreet_F", "Land_LampAirport_F", "Land_PowerPoleWooden_L_F",
											"Land_fs_roof_F","Land_fs_sign_F","Land_TTowerBig_2_F","Land_TTowerBig_1_F","PowerLines_Small_base_F"], _range];
private _turretList = _pos nearEntities [["B_static_AA_F", "B_static_AT_F","B_T_Static_AA_F","B_T_Static_AT_F","B_T_GMG_01_F","B_T_HMG_01_F","B_T_Mortar_01_F","B_HMG_01_high_F","B_HMG_01_A_F","B_GMG_01_F","B_GMG_01_high_F",
											"B_GMG_01_A_F","B_Mortar_01_F","B_G_Mortar_01_F","B_Static_Designator_01_F","B_AAA_System_01_F","B_SAM_System_01_F","B_SAM_System_02_F","O_HMG_01_F","O_HMG_01_high_F","O_HMG_01_A_F",
											"O_GMG_01_F","O_GMG_01_high_F","O_GMG_01_A_F","O_Mortar_01_F","O_G_Mortar_01_F","O_static_AA_F","O_static_AT_F","O_Static_Designator_02_F","I_HMG_01_F","I_HMG_01_high_F","I_HMG_01_A_F",
											"I_GMG_01_F","I_GMG_01_high_F","I_GMG_01_A_F","I_Mortar_01_F","I_G_Mortar_01_F","I_static_AA_F","I_static_AT_F"], _range]; 

// go through all vehicles and if there is a crew, add all crew members to the man list. Required as nearEntities with "Man" list do not add mounted soldiers
private _addArr = [];
{
	// push back all crew on each vehicle
	private _vic = _x;
	{
		_manList pushBack (_x select 0);
	} forEach fullCrew _vic;
} forEach _vehicleList;

// remove duplicates on man list
_manList = _manList arrayIntersect _manList;

// build array and return it
private _arr = [_vehicleList, _lightList, _turretList, _manList];
_arr

