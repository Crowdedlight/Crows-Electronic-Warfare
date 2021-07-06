#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_removeRandomRadioTrackingChatter.sqf
Parameters: _unit/group, _sleepInterval
Return: none

Called from event broadcast by zeus to everyone, and JIP
removes loop that randomly within the chosen intervals adds spectrum signals as long as unit is alive.

*///////////////////////////////////////////////
params ["_unit"];

if (isNull _unit) exitWith {hint "You have to select an unit"};

// if loop exists, then remove it and spawn new one
private _existingHandle = _unit getVariable[QGVAR(radioChatterHandle), scriptNull];
if (!isNull _existingHandle) then {
	// if not null, we terminate it
	terminate _existingHandle;
};
// set unit handle var to null
_unit setVariable[QGVAR(radioChatterHandle), scriptNull, true];

// remove from array for drawing indication of what AI units has it enabled
GVAR(radioTrackingAiUnits) = GVAR(radioTrackingAiUnits) - [_unit];
