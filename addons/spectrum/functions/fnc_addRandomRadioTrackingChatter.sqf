#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_addRandomRadioTrackingChatter.sqf
Parameters: _unit/group, _sleepInterval
Return: none

Called from event broadcast by zeus to everyone, and JIP
spawns loop that randomly within the chosen intervals adds spectrum signals as long as unit is alive.

_sleepInterval = [min, max];
_lengthInterval = [min, max];
_frequencyInterval = [min, max];
_range = ;

*///////////////////////////////////////////////
params ["_unit", "_frequency", "", ""];

if (isNull _unit) exitWith {hint "You have to select an unit"};

// if loop exists, then remove it and spawn new one
private _existingHandle = _unit getVariable[QGVAR(radioChatterHandle), scriptNull];
if (!isNull _existingHandle) then {
	terminate _existingHandle;
};

// spawn loop 
private _handler = [_unit] spawn {
	params ["_unit"];

	// loop it 
	while {alive _unit && !isNull _unit} do {
		// add signal, sleep for duration, remove signal, sleep for delay... etc.

		
	};
	// not alive anymore so we terminate script, and remove unit from drawing array
	[QGVAR(removeRandomRadioTrackingChatter), [_unit]] call CBA_fnc_globalEventJIP;
};

// save handler to loop or a way to stop it, on var on unit
_unit setVariable[QGVAR(radioChatterHandle), _handler, true];

// add to array for drawing indication of what AI units has it enabled
GVAR(radioTrackingAiUnits) pushBack _unit;