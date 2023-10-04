#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_ctrackInit.sqf
Parameters: _unit
Return: none

*///////////////////////////////////////////////
params [["_unit", objNull]];

if (!local _unit) exitWith {};

// if attached to man, we hide the model as it sits stupidly on the shoulder
[
	{
		if ((attachedTo (_this#0)) isKindOf "CAManBase") then {
			[_this#0, true] remoteExec ["hideObjectGlobal", 2];
		}
	},
	[_unit],
	1
] call CBA_fnc_waitAndExecute;

["zen_common_addObjects", [[_unit], objNull]] call CBA_fnc_serverEvent;

// handle reattach, if variables are not 0, we are having a reattach and skip
private _attachedToObj = attachedTo _unit;
private _savedFreq = _attachedToObj getVariable[QGVAR(ctrack_attached_frequency), 0];
private _savedRange = _attachedToObj getVariable[QGVAR(ctrack_attached_range), 0];

// if we are readding because we left vehicle, then exit without showing gui and applying the saved settings
if (_savedFreq != 0) exitWith{
	// set new beacon again 
	private _jipID = [QGVAR(addBeacon), [_unit, _savedFreq, _savedRange, "ctrack"]] call CBA_fnc_globalEventJIP;

	// update jip id 
	_attachedToObj setVariable[QGVAR(ctrack_attached_jipID), _jipID];
};

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
	if (_unit == objNull) exitWith {};

	// get config value for range 
	private _range = getNumber (configFile >> "CfgVehicles" >> typeOf _unit >> "range");

	// broadcast event to all clients and JIP	
	private _ctrackJip = [QGVAR(addBeacon), [_unit, _freq, _range, "ctrack"]] call CBA_fnc_globalEventJIP;

	// save frequency in variable on unit its attached to. (Only if Man, not if vehicle/object)
	private _attachedToObj = attachedTo _unit;
	if (!isNull _attachedToObj && _attachedToObj isKindOf "CAManBase") then {
		_attachedToObj setVariable[QGVAR(ctrack_attached_frequency), _freq];
		_attachedToObj setVariable[QGVAR(ctrack_attached_range), _range];
		_attachedToObj setVariable[QGVAR(ctrack_attached_jipID), _ctrackJip];
	}
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

