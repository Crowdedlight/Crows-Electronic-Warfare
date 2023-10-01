#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_ctrackNoAce.sqf
Parameters: _unit
Return: none

*///////////////////////////////////////////////
params [["_unit", objNull]];

// if object given is null or ace is loaded we exit and use the ace attach
if (isNull _unit || EGVAR(zeus,hasAce)) exitWith {};

// add scroll-wheel options to attach it to what you are aiming at

// when adding it to a object/unit, add action on target object to remove it. 

// add option to add it to yourself as SAR beacon 
// (And then remove it aswell)










// open gui to select frequency
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_freq"
	];
	//Get in params again
	_in params [["_unit",objNull,[objNull]]];
	
	// if object is null, we can't start the jamming
	if (_unit == objNull) exitWith {hint "You have to select a object as signal source";};

	// get config value for range 
	private _range = getNumber (configFile >> "CfgVehicles" >> typeOf _unit >> "range");

	// broadcast event to all clients and JIP	
	[QGVAR(addBeacon), [_unit, _freq, _range, "ctrack"]] call CBA_fnc_globalEventJIP;
};
[
	"Frequency for Tracker", 
	[
		["SLIDER","Frequency (Unique)",[390,500,460,1]] //390 to 500, default 460 and showing 1 decimal
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;

