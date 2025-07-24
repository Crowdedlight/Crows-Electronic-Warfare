#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_requestBeaconServer.sqf
Parameters: 
Return: none

Called upon event, responds with current state of beacons
SERVER ONLY

*///////////////////////////////////////////////
params ["_source"];

// if object is null or frequency is -1, exitwith. Can happen if we get event as JIP but object has been removed
if (isNull _source || !isServer) exitWith {};

// send current state
[QGVAR(updateBeacons), [GVAR(beacons)], _source] call CBA_fnc_targetEvent;
