#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_removeRandomRadioTrackingChatterServer.sqf
Parameters: _unit/group, _sleepInterval
Return: none

Called from event broadcast by zeus to everyone, and JIP
removes loop that randomly within the chosen intervals adds spectrum signals as long as unit is alive.

SERVER ONLY

*///////////////////////////////////////////////
params ["_unit"];

// server only 
if (!isServer) exitWith {};

// if null, we just need to remove nulls from drawing array, as tracking array is updated automatically
if (isNull _unit) exitWith {
	GVAR(radioTrackingAiUnits) = GVAR(radioTrackingAiUnits) - [objNull];
	publicVariable QGVAR(radioTrackingAiUnits);
};

// if loop exists, then remove it and spawn new one
private _existingHandle = _unit getVariable[QGVAR(radioChatterHandle), scriptNull];

if (!isNull _existingHandle) then {
	// if not null, we terminate it
	terminate _existingHandle;

	// if we terminate it stops straight away and thus the signal source might not have been removed. So we manually remove it 
	[_unit] call FUNC(removeBeaconServer);
};
// set unit handle var to null
_unit setVariable[QGVAR(radioChatterHandle), scriptNull];

// remove unit from array for drawing indication of what AI units has it enabled
private _rmIndex = GVAR(radioTrackingAiUnits) findIf { (_x select 0) == _unit};
GVAR(radioTrackingAiUnits) deleteAt _rmIndex;
// publish change
publicVariable QGVAR(radioTrackingAiUnits);
