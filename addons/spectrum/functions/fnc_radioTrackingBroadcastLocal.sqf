#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_radioTrackingBroadcastLocal.sqf
Parameters: 
Return: none

// get called when player uses the radio. We put out signal source based on this 
// ONLY TESTED WITH TFAR Beta

*///////////////////////////////////////////////
params ["_unit", "_radioclass", "_radioType", "_additionalChannel", "_buttonDown"];

// when we start transmission, buttonDown == true, when we stop its false. 
if (_buttonDown) then {
	private _freq = -1;
	private _range = -1;
	private _radio = "";

	// diag_log format ["radio class: %1, type: %2, buttonDown: %3", _radioclass, _radioType, _buttonDown];

	// 0 == SR, 1 == LR, 2 == underwater
	switch (_radioType) do {
		case 0: {
			_freq = parseNumber ((call TFAR_fnc_ActiveSwRadio) call TFAR_fnc_getSwFrequency);
			_range = getNumber(configfile >> "CfgWeapons" >> (call TFAR_fnc_ActiveSwRadio) >> "tf_range");
			_radio = call TFAR_fnc_ActiveSwRadio;
		};
		case 1: {
			_freq = parseNumber ((call TFAR_fnc_ActiveLrRadio) call TFAR_fnc_getLrFrequency);
			_range = getNumber(configfile >> "CfgVehicles" >> typeOf(call TFAR_fnc_activeLrRadio select 0) >> "tf_range");
			_radio = call TFAR_fnc_ActiveLrRadio;
		};
	};

	// EMP support, test if radio is disabled, and then do not create a signal
	if (!([_radio] call TFAR_fnc_radioOn)) exitWith {};

	// systemChat format["freq: %1, range: %2, onTangent: btnDown: %3", _freq, _range, _buttonDown];

	if (_freq isEqualTo -1 || _range isEqualTo -1) exitWith {};

	// Randomize the digits of signal to try and avoid multiple signals override eachother, while we want to symbolize multiple signals
	_freq = _freq + ((random 900)/10000); //changing the 0.0xx part only

	// add signal source - NOT on JIP, as they are shorter bursts and we don't want to fill up the JIP. Such short messages should never be a problem requiring JIP.
	[QGVAR(addBeacon), [_unit, _freq, _range, "radio"]] call CBA_fnc_globalEvent;

} else {
	// remove signal, shouldn't be a problem with JIP. As same unit would overwrite next transmission anyway, even if it gets stuck in either state
	// systemChat format["Rm signal onTangent: btnDown: %1", _buttonDown];
	[QGVAR(removeBeacon), [_unit]] call CBA_fnc_globalEvent;
};
