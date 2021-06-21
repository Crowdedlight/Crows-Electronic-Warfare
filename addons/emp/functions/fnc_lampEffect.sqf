#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_lampEffect.sqf
Parameters: _unit
Return: none

makes the effect for sparks on lamps and turrets 

*///////////////////////////////////////////////
params ["_unit"];

// only for players
if (!hasInterface) exitWith {};

// do random amount of sparks for each lamp, with slight random delays
sleep 0.1;
private _sparkCount = 1 + floor (random 4);

// do all sparks 
for "_i" from 0 to _sparkCount do {
	// random delay
	private _randomDelay = 0.1 + (random 3);

	// do the effect
	[[_unit,_randomDelay],QPATHTOF(functions\fnc_lampSparkEffect.sqf)] remoteExec ["execvm", [0,-2] select isDedicated];
	sleep _randomDelay;
};
