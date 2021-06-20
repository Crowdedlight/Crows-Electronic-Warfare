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
		"_range"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
	
	// fire EMP
	[QEGVAR(emp,eventFireEMP), [_pos, _unit, _range]] call CBA_fnc_serverEvent;
};
[
	"Fire EMP", 
	[
		["SLIDER","Range (m)",[50,5000,2000,0]]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;