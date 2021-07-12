#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_addRandomRadioTrackingChatterServer.sqf
Parameters: _unit/group, _sleepInterval
Return: none

Called from event broadcast by zeus to everyone, and JIP
spawns loop that randomly within the chosen intervals adds spectrum signals as long as unit is alive.

Server only, so DCs doens't interfere with spawned function

_sleepInterval = [min, max];
_lengthInterval = [min, max];
_frequencyInterval = [min, max];
_range = val;

*///////////////////////////////////////////////
params ["_unit", "_range", "_sleepInterval", "_lengthInterval", "_frequencyInterval"];

// only runs on server - CBA ServerEvent 
if (!isServer) exitWith {};
if (isNull _unit) exitWith {};

// if loop exists, then remove it and spawn new one, might have updated the settings
private _existingHandle = _unit getVariable[QGVAR(radioChatterHandle), scriptNull];
if (!isNull _existingHandle) then {
	terminate _existingHandle;
};

// get vars
private _slp_min = _sleepInterval select 0;
private _slp_mid = round((_sleepInterval select 1)/2);
private _slp_max = _sleepInterval select 1;

private _len_min = _lengthInterval select 0;
private _len_mid = round((_lengthInterval select 1)/2);
private _len_max = _lengthInterval select 1;

private _freq_min = _frequencyInterval select 0;
private _freq_mid = round((_frequencyInterval select 1)/2);
private _freq_max = _frequencyInterval select 1;

// spawn loop - spawning to allow sleep and to have no impact on game performance. 
private _handler = [_unit, _range, _slp_min, _slp_mid, _slp_max, _len_min, _len_mid, _len_max, _freq_min, _freq_mid, _freq_max] spawn {
	params ["_unit", "_range", "_slp_min", "_slp_mid", "_slp_max", "_len_min", "_len_mid", "_len_max", "_freq_min", "_freq_mid", "_freq_max"];

	// loop it 
	while {alive _unit && !isNull _unit} do {
		// add signal, sleep for duration, remove signal, sleep for delay... etc.
		private _freq = floor(random[_freq_min, _freq_mid, _freq_max]);
		private _length = floor(random[_freq_min, _freq_mid, _freq_max]);
		private _sleep = floor(random[_freq_min, _freq_mid, _freq_max]);

		// add signal 
		[QGVAR(addBeacon), [_unit, _freq, _range, "chatter"]] call CBA_fnc_globalEvent;

		// sleep for length 
		sleep _length;

		// remove signal 
		[QGVAR(removeBeacon), [_unit]] call CBA_fnc_globalEvent;

		// sleep before next transmission
		sleep _sleep;
	};
	// not alive anymore so we terminate script, and remove unit from drawing array
	[QGVAR(removeRandomRadioTrackingChatter), [_unit]] call CBA_fnc_serverEvent;

	// final removal to ensure its signal source is removed 
	[QGVAR(removeBeacon), [_unit]] call CBA_fnc_globalEvent;
};

// save handler to loop or a way to stop it, on var on unit
_unit setVariable[QGVAR(radioChatterHandle), _handler, true];

// add to array for drawing indication of what AI units has it enabled
GVAR(radioTrackingAiUnits) pushBack _unit;
publicVariable GVAR(radioTrackingAiUnits);