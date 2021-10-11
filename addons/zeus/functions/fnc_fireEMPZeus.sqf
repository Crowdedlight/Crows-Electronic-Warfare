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
	"Fire EMP", 
	[
		["SLIDER","Range [m]",[50,2500,500,0]],
		["CHECKBOX",["Spawn EMP Object?", "Spawn 'the device' object as EMP source?"],[false]],
		["TOOLBOX:wide", ["NV/Thermal Scopes", "How should scopes with built-in thermal and NV be handled"], [1, 1, 3, ["No Removal", "Replace with base-game item", "Removal"]]],
		["TOOLBOX:WIDE", ["Binoculars", "How should binoculars with built-in thermal and NV be handled"], [1, 1, 3, ["No Removal", "Replace with base-game item", "Removal"]]]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;


// _pos: position asl
// _unit: the object/unit its placed on, objNull if using position instead of unit
// _range: The range the EMP is effective in meters. It can be seen further away, but this is the range of the "growing half-dome effect" and the radius where units will loose electric equipment
// _spawnDevice: spawning a "device" at position of EMP, or fire the EMP without spawning a device
// _scopeMode: How should it handle scope with built-in NV or Thermal. 0: Do not remove, 1: replace with basegame 1x scope, 2: remove without giving a replacement 
// _binoMode: How should it handle binoculars with built-in NV or Thermal. 0: Do not remove, 1: replace with basegame binocular, 2: remove without giving a replacement 
["crowsEW_emp_eventFireEMP", [_pos, _unit, _range, _spawnDevice, _scopeMode, _binoMode]] call CBA_fnc_serverEvent;

//example: Fire EMP at position with 500m radius without spawning a "device" object and remove any scopes or binos with NV or thermal built-in.  
["crowsEW_emp_eventFireEMP", [[2508.64,5681.47,171.718], objNull, 500, false, 2, 2]] call CBA_fnc_serverEvent;