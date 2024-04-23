#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_addBeaconServer.sqf
Parameters: 
Return: none

Called upon event, adds the jammer to gvar array
SERVER ONLY

*///////////////////////////////////////////////
params ["_unit", ["_frequency", -1, [0]], ["_scanRange", 500, [0]], "_type"];

// if object is null or frequency is -1, exitwith. Can happen if we get event as JIP but object has been removed
if (isNull _unit || _frequency < 0 || !isServer) exitWith {};

// add to array
GVAR(beacons) pushBack [_unit, _frequency, _scanRange, _type];

// push broadcast update
[QGVAR(updateBeacons), [GVAR(beacons)]] call CBA_fnc_globalEvent;