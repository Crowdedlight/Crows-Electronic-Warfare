#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_ctrack_init.sqf
Parameters: _unit
Return: none

*///////////////////////////////////////////////
params [["_unit", objNull]];

// get config value for range 
private _range = getNumber (configFile >> "CfgVehicles" >> typeOf _unit >> "range");

// TODO consider moving the spectrum signal to the unit instead of the tracker for units? As otherwise when you get into vehicles the signal disappears as the item is detatched?
// if attached to man, we hide the model as it sits stupidly on the shoulder
[
	{
		diag_log (attachedTo (_this#0));
		if ((attachedTo (_this#0)) isKindOf "CAManBase") then {
			_this#0 hideObjectGlobal true;
		}
	},
	[_unit],
	1
] call CBA_fnc_waitAndExecute;

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

	// broadcast event to all clients and JIP	
	[QGVAR(addBeacon), [_unit, _freq, _range, "ctrack"]] call CBA_fnc_globalEventJIP;
};
[
	"Frequency for Tracker", 
	[
		["SLIDER","Frequency (Unique)",[390,500,460,1]], //390 to 500, default 460 and showing 1 decimal
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;




