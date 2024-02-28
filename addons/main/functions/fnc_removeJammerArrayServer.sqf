#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_removeJammerArrayServer.sqf
Parameters: _objects
Return: none

SERVER ONLY
remove jammer from all objects in array 

*///////////////////////////////////////////////
params ["_objects"];

if (isNull _objects || count _objects == 0 || !isServer) exitWith {};

{
	// remove jammers, do not update it, as we do a combined update after removing entire array
	[_x, false] call FUNC(removeJammer);	
} forEach _objects;

// broadcast update
[QGVAR(updateJammers), [GVAR(jamMap)]] call CBA_fnc_globalEvent;