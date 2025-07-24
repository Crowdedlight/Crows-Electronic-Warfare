#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_addSatcomZeus.sqf
Parameters: pos, _unit
Return: none

Zeus dialog to set object as TFAR satcom device

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//ZEN dialog, just ignore ARES, as that mod itself is EOL and links to ZEN
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_rad"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
	
	// if object is null, we exit
	if (isNull _unit) exitWith { hint localize "STR_CROWSEW_Zeus_error_on_object"};

	// broadcast event to all clients and JIP
	[QEGVAR(main,addSatcom), [_unit, round _rad]] call CBA_fnc_serverEvent;
};
[
	localize "STR_CROWSEW_Zeus_addsatcom_name", 
	[
		["SLIDER",localize "STR_CROWSEW_Zeus_addsatcom_radius",[1,50,20,0]] //10 to 5000, default 500 and showing 0 decimal.
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;
