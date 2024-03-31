#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_radioTrackingBroadcastLocal.sqf
Parameters: 
Return: none

// get called when player uses the radio. We put out signal source based on this 
// ONLY TESTED WITH TFAR Beta

*///////////////////////////////////////////////
params [["_unit", objNull], "_radioclass", "_radioType", "_additionalChannel", "_buttonDown"];

// when we start transmission, buttonDown == true, when we stop its false. 
if (_buttonDown) then {
	private _freq = -1;
	private _range = -1;
	private _radio = "";
	private _radioCode = "";

	// diag_log format ["radio class: %1, type: %2, buttonDown: %3", _radioclass, _radioType, _buttonDown];

	// 0 == SR, 1 == LR, 2 == underwater
	switch (_radioType) do {
		case 0: {
			_radio = call TFAR_fnc_ActiveSwRadio;
			_freq = parseNumber (_radio call TFAR_fnc_getSwFrequency);
			_range = getNumber(configfile >> "CfgWeapons" >> _radio >> "tf_range");
			_radioCode = _radio call TFAR_fnc_getSwRadioCode;
		};
		case 1: {
			_radio = call TFAR_fnc_ActiveLrRadio;
			_freq = parseNumber (_radio call TFAR_fnc_getLrFrequency);
			_range = getNumber(configfile >> "CfgVehicles" >> typeOf(_radio select 0) >> "tf_range");
			_radioCode = _radio call TFAR_fnc_getLrRadioCode;
		};
	};



	// EMP support, test if radio is disabled, and then do not create a signal
	if (!([_radio] call TFAR_fnc_radioOn)) exitWith {};

	// systemChat format["freq: %1, range: %2, onTangent: btnDown: %3", _freq, _range, _buttonDown];

	if (_freq isEqualTo -1 || _range isEqualTo -1) exitWith {};
	
	// save radio in public var for other player to get identical radio when listening in
	_unit setVariable [QGVAR(broadcastingRadio), [_radio, _radioType, _freq, _radioCode], true];

	// Randomize the digits of signal to try and avoid multiple signals override eachother, while we want to symbolize multiple signals
	_freq = _freq + ((random 900)/10000); //changing the 0.0xx part only

	// add signal source
	[QGVAR(addBeacon), [_unit, _freq, _range, "radio"]] call CBA_fnc_serverEvent;

} else {
	// remove signal, shouldn't be a problem with JIP. As same unit would overwrite next transmission anyway, even if it gets stuck in either state
	// systemChat format["Rm signal onTangent: btnDown: %1", _buttonDown];
	[QGVAR(removeBeacon), [_unit]] call CBA_fnc_serverEvent;
	
	// reset var for listening to
	_unit setVariable [QGVAR(broadcastingRadio), [], true];
};
