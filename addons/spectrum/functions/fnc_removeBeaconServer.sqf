#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_removeBeaconServer.sqf
Parameters: pos, _unit
Return: none

remove signal source from object 
SERVER ONLY

*///////////////////////////////////////////////
params ["_unit"];

// if object is null, exitwith. Can happen if we get event as JIP but object has been removed
if (isNull _unit) exitWith {};

// find object in array
private _rmIndex = GVAR(beacons) findIf { (_x select 0) == _unit};

GVAR(beacons) deleteAt _rmIndex;

// push update
[QGVAR(updateBeacons), [GVAR(beacons)]] call CBA_fnc_globalEvent;