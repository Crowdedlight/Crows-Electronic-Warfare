#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_updateBeacons.sqf
Parameters: array of beacons
Return: none

Update pushed from server, handle additions and removals

*///////////////////////////////////////////////
params ["_beacons"];

// save current beacon state
GVAR(beacons) = _beacons;
