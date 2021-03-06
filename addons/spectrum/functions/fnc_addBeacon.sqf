#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_addBeacon.sqf
Parameters: pos, _unit
Return: none

Called upon event, adds the jammer to local gvar array and starts while loop, if it isn't running

*///////////////////////////////////////////////
params ["_unit", ["_frequency", -1, [0]], ["_scanRange", 500, [0]], "_type"];

// if object is null or frequency is -1, exitwith. Can happen if we get event as JIP but object has been removed
if (isNull _unit || _frequency < 0) exitWith {};

// add to array
GVAR(beacons) pushBack [_unit, _frequency, _scanRange, _type];