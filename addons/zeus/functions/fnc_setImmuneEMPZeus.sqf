#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_setImmuneEMPZeus.sqf
Parameters: pos, _unit
Return: none

Sets if the unit is immune to EMPs - Mainy used to EMP proof vehicles

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

if (isNull _unit) exitWith { hint "Need to select a object"};

//ZEN dialog, just ignore ARES, as that mod itself is EOL and links to ZEN
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_immunity"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
	
	// set immunity on unit and broadcast so everyone/server knows
	_unit setVariable [QEGVAR(emp,immuneEMP), _immunity, true];
};

// get current value and set default value of toggle based on that
private _empImmune = _unit getVariable [QEGVAR(emp,immuneEMP), false];
[
	"Set Immune to EMP", 
	[
		["TOOLBOX:YESNO", ["Immunity to EMP", "Makes the unit immune to EMPs"], _empImmune]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;