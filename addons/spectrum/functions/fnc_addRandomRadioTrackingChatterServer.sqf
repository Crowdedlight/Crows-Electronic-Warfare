#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_addRandomRadioTrackingChatterServer.sqf
Parameters: _unit/group, _sleepInterval
Return: none

Called from event broadcast by zeus to server
spawns loop that randomly within the chosen intervals adds spectrum signals as long as unit is alive.

Server only, so DCs doens't interfere with spawned function

_sleepInterval = [min, max];
_lengthInterval = [min, max];
_frequencyInterval = [min, max];
_range = val;

*///////////////////////////////////////////////
params ["_unit", "_range", "_sleepInterval", "_lengthInterval", "_frequencyInterval", "_voicePack"];

// only runs on server - CBA ServerEvent 
if (!isServer) exitWith {};
if (isNull _unit) exitWith {};

// if loop exists, then remove it and spawn new one, might have updated the settings
private _existingHandle = _unit getVariable[QGVAR(radioChatterHandle), scriptNull];
if (!isNull _existingHandle) then {
	terminate _existingHandle;
	// remove signal 
	[_unit] call FUNC(removeBeaconServer);

	// remove from zeus draw list - We wait with publish update until end of script where we publish anyway for the new draws
	private _rmIndex = GVAR(radioTrackingAiUnits) findIf { (_x select 0) == _unit};
	GVAR(radioTrackingAiUnits) deleteAt _rmIndex;
};

// get vars
private _slp_min = _sleepInterval select 0;
private _slp_max = _sleepInterval select 1;
private _slp_mid = round(((_slp_max - _slp_min)/2) + _slp_min);

private _len_min = _lengthInterval select 0;
private _len_max = _lengthInterval select 1;
private _len_mid = round(((_len_max - _len_min)/2) + _len_min);

private _freq_min = _frequencyInterval select 0;
private _freq_max = _frequencyInterval select 1;
private _freq_mid = round(((_freq_max - _freq_min)/2) + _freq_min);

// spawn loop - spawning to allow sleep and to have no impact on game performance. 
private _handler = [_unit, _range, _slp_min, _slp_mid, _slp_max, _len_min, _len_mid, _len_max, _freq_min, _freq_mid, _freq_max] spawn {
	params ["_unit", "_range", "_slp_min", "_slp_mid", "_slp_max", "_len_min", "_len_mid", "_len_max", "_freq_min", "_freq_mid", "_freq_max"];

	// loop it 
	while {alive _unit && !isNull _unit} do {
		// add signal, sleep for duration, remove signal, sleep for delay... etc.
		private _freq = floor(random[_freq_min, _freq_mid, _freq_max]);
		private _length = floor(random[_len_min, _len_mid, _len_max]);
		private _sleep = floor(random[_slp_min, _slp_mid, _slp_max]);

		// add signal 
		[_unit, _freq, _range, "chatter"] call FUNC(addBeaconServer);

		// sleep for length 
		sleep _length;

		// remove signal 
		[_unit] call FUNC(removeBeaconServer);

		// sleep before next transmission
		sleep _sleep;
	};
	// not alive anymore so we terminate script, and remove unit from drawing array
	[QGVAR(removeRandomRadioTrackingChatter), [_unit]] call CBA_fnc_serverEvent;
};

// save handler to loop or a way to stop it, on var on unit, as we are on server, we only save locally
_unit setVariable[QGVAR(radioChatterHandle), _handler];
// save voicepack on unit
_unit setVariable[QGVAR(radioChatterVoicePack), _voicePack, true];

// add to array for drawing indication of what AI units has it enabled
GVAR(radioTrackingAiUnits) pushBack [_unit, _voicePack];
publicVariable QGVAR(radioTrackingAiUnits);
