#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_addJammerZeus.sqf
Parameters: pos, _unit
Return: none

Zeus dialog to set object as TFAR jammer

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//ZEN dialog, just ignore ARES, as that mod itself is EOL and links to ZEN
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_rad",
		"_strength"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
	
	// if object is null, we spawn a dataterminal on the selected position instead
	if (isNull _unit) then {
		// no obj selected 
		private _posAGL = ASLToAGL _pos;
		private _dataTerminal = createVehicle ["Land_DataTerminal_01_F", _posAGL, [], 0, "NONE"];

		// set zeus editable 
		["zen_common_addObjects", [[_dataTerminal], objNull]] call CBA_fnc_serverEvent;

		// set as jam object
		_unit = _dataTerminal;
	};

	// broadcast event to all clients and JIP
	[QEGVAR(main,addJammer), [_unit, _rad, _strength]] call CBA_fnc_globalEventJIP;

	// broadcast sound to server for sound handling - Means we don't get duplicate broadcasts due to JIP.
	// params ["_unit", "_delay", "_range", "_repeat", "_aliveCondition", "_sound", "_startDelay", "_volume"];
	[getPosATL _unit, 50, "jam_start", 3] call EFUNC(sounds,playSoundPos);
	[QEGVAR(sounds,addSound), [_unit, 0.5, 50, true, true, "jam_loop", 3, 3]] call CBA_fnc_serverEvent;

};
[
	"TFAR Jammer", 
	[
		["SLIDER","Jamming Radius",[10,5000,500,0]], //10 to 5000, default 500 and showing 0 decimal.
		["SLIDER","Jamming Strength",[0,100,50,0]] //0 to 100, default 50 and showing 0 decimal
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;