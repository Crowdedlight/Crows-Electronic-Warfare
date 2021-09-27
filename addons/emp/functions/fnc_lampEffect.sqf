#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_lampEffect.sqf
Parameters: _unit
Return: none

makes the effect for sparks on lamps and turrets 

*///////////////////////////////////////////////
params ["_arr"];

// only for players
if (!hasInterface || isNil "_arr") exitWith {};

private _sparkCount = 1 + floor (random 3);

{
	// check if within 500m of player and only then spawn the effect
	private _dist = player distance _x;
	if (_dist > 500) then { continue; };  

	private _unit = _x;

	// do the effect
	for "_i" from 0 to _sparkCount do {
		private _randomDelay = 0.5 + (random 1);
		[_unit,_randomDelay] execvm QPATHTOF(functions\fnc_lampSparkEffect.sqf);
		sleep _randomDelay;
	};

	// minor sleep for processing
	sleep 0.01;

} forEach _arr;

