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
		"_scopeMode",
		"_binoMode"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
	
	// fire EMP - wrapped in CBA wait and execute for the delay. Returns a handler, for now we can't stop it again.
	[QEGVAR(emp,eventFireEMP), [_pos, _unit, _range, _scopeMode, _binoMode]] call CBA_fnc_serverEvent;		
};
[
	"Fire EMP", 
	[
		["SLIDER","Range [m]",[50,5000,1000,0]],
		["TOOLBOX:wide", ["NV/Thermal Scopes", "How should scopes with built-in thermal and NV be handled"], [1, 1, 3, ["No Removal", "Replace with base-game item", "Removal"]]],
		["TOOLBOX:WIDE", ["Binoculars", "How should binoculars with built-in thermal and NV be handled"], [1, 1, 3, ["No Removal", "Replace with base-game item", "Removal"]]]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;