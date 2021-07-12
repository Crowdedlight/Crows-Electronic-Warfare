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

private _freq = -1;
private _range = -1;

diag_log format ["radio class: %1, type: %2, buttonDown: %3", _radioclass, _radioType, _buttonDown];

// 0 == SR, 1 == LR, 2 == underwater
switch (_radioType) do {
	case 0: {
		_freq = (call TFAR_fnc_ActiveSwRadio) call TFAR_fnc_getSwFrequency;
		_range = getNumber(configfile >> "CfgWeapons" >> (call TFAR_fnc_ActiveSwRadio) >> "tf_range");
	};
	case 1: {
		_freq = (call TFAR_fnc_ActiveLrRadio) call TFAR_fnc_getLrFrequency;
		_range = getNumber(configfile >> "CfgVehicles" >> typeOf(call TFAR_fnc_activeLrRadio select 0) >> "tf_range");
	};
};

diag_log format["freq: %1, range: %2", _freq, _range];

if ((_freq == -1) || {_range == -1}) exitWith {};

systemChat format["onTangent: btnDown: %1", _buttonDown];

// add signal source - NOT on JIP, as they are shorter bursts and we don't want to fill up the JIP. Such short messages should never be a problem requiring JIP.
[QGVAR(addBeacon), [player, _freq, _range, "radio"]] call CBA_fnc_globalEvent;

// spawn function that runs until unit is not talking anymore, then stop the signal source
private _stopTrackingSpawn = [] spawn {

	// intial 1s sleep, as any radio comms will always be shown for 1s no matter the length
	private _start = time;
	private _initial = true;

	// do not remove until finished speaking and 1s has passed
	while {player call TFAR_fnc_isSpeaking && _initial} do {
		private _diff = (time - _start);
		if (_diff > 1) then { _initial = false; };

		sleep 0.2;
	};
	// remove signal, shouldn't be a problem with JIP. As same unit would overwrite next transmission anyway, even if it gets stuck in either state
	[QGVAR(removeBeacon), [player]] call CBA_fnc_globalEvent;
};