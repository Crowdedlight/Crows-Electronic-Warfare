#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_addSpectrumBeaconZeus.sqf
Parameters: pos, _unit
Return: none

Zeus dialog to set object as Spectrum signal source

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//ZEN dialog, just ignore ARES, as that mod itself is EOL and links to ZEN
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_freq",
		"_range"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
	
	// if object is null, we can't start the jamming
	if (_unit == objNull) exitWith {hint "You have to select a object as signal source";};

	// broadcast event to all clients and JIP
	[QEGVAR(spectrum,addBeacon), [_unit, _freq, _range, "zeus"]] call CBA_fnc_serverEvent;
};
[
	"Set Spectrum Signal Source", 
	[
		["SLIDER","Frequency (Unique)",[390,500,460,1]], //390 to 500, default 460 and showing 1 decimal
		["SLIDER","Range it can be seen from",[1,5000,300,0]] //1 to 5000, default 300 and showing 0 decimal
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;
