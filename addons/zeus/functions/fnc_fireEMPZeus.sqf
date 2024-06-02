#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_playSoundZeus.sqf
Parameters: pos, _unit
Return: none

Fires EMP at location with chosen options 

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//ZEN dialog, just ignore ARES, as that mod itself is EOL and links to ZEN
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_range",
		"_spawnDevice",
		"_scopeMode",
		"_binoMode"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
	
	// fire EMP - wrapped in CBA wait and execute for the delay. Returns a handler, for now we can't stop it again.
	[QEGVAR(emp,eventFireEMP), [_pos, _unit, _range, _spawnDevice, _scopeMode, _binoMode]] call CBA_fnc_serverEvent;		
};
[
	localize "STR_CROWSEW_Zeus_fireemp_name", 
	[
		["SLIDER",localize "STR_CROWSEW_Zeus_fireemp_range",[50,2500,500,0]],
		["CHECKBOX",[localize "STR_CROWSEW_Zeus_fireemp_spawn_device", localize "STR_CROWSEW_Zeus_fireemp_spawn_device_tooltip"],[false]],
		["TOOLBOX:wide", [localize "STR_CROWSEW_Editormodules_emp_scopes_name", localize "STR_CROWSEW_Editormodules_emp_scopes_tooltip"], [1, 1, 3, [localize "STR_CROWSEW_Editormodules_emp_options_no_removal", localize "STR_CROWSEW_Editormodules_emp_options_replace_basegame", localize "STR_CROWSEW_Editormodules_emp_options_removal"]]],
		["TOOLBOX:WIDE", [localize "STR_CROWSEW_Editormodules_emp_bino_name", localize "STR_CROWSEW_Editormodules_emp_bino_tooltip"], [1, 1, 3, [localize "STR_CROWSEW_Editormodules_emp_options_no_removal", localize "STR_CROWSEW_Editormodules_emp_options_replace_basegame", localize "STR_CROWSEW_Editormodules_emp_options_removal"]]]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;
