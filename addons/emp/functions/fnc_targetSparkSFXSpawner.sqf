#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_targetSparkSpawner.sqf
Parameters: array of units
Return: none

spawns the effect per unit it should be displayed on

*///////////////////////////////////////////////
params ["_arr"];

// only on players
if (!hasInterface || isNil "_arr") exitWith {};

{
	// check if within 500m of player and only then spawn the effect
	private _dist = player distance _x;
	if (_dist > 500) then { continue; };  

	// do the effect
	[_x] execVM QPATHTOF(functions\fnc_targetSparkSFX.sqf);

	// minor sleep for processing
	sleep 0.01;
} forEach _arr;
