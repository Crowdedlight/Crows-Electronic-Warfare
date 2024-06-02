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
	[QGVAR(addBeacon), [_unit, _savedFreq, _savedRange, "ctrack"]] call CBA_fnc_serverEvent;
};

// open gui to select frequency
// TODO problem, if user hits "cancel" on dialog, we don't get into this function and we have an tracker put on the vehicle or ourself, that has no signal. Especially for own beacons this is a problem as it will respawn the choose dialog whenever you get in/out of vehicle
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

	// send event to server	
	[QGVAR(addBeacon), [_unit, _freq, _range, "ctrack"]] call CBA_fnc_serverEvent;

	// save frequency in variable on unit its attached to. (Only if Man, not if vehicle/object)
	private _attachedToObj = attachedTo _unit;
	if (!isNull _attachedToObj && _attachedToObj isKindOf "CAManBase") then {
		_attachedToObj setVariable[QGVAR(ctrack_attached_frequency), _freq];
		_attachedToObj setVariable[QGVAR(ctrack_attached_range), _range];
	}
};
private _signalRange = GVAR(spectrumDeviceFrequencyRange)#1;
private _half = _signalRange#0 + _signalRange#2/2;
[
	localize "STR_CROWSEW_Spectrum_ctrack_no_ace_freq", 
	[
		["SLIDER",localize "STR_CROWSEW_Spectrum_ctrack_no_ace_freq_slider",[_signalRange#0,_signalRange#1,_half,1]] //min freq to max, default midpoint and showing 1 decimal
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;

