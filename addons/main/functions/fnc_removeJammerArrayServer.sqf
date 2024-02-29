#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_removeJammerArrayServer.sqf
Parameters: _netids
Return: none

SERVER ONLY
remove jammer from all objects in array 

*///////////////////////////////////////////////
params [["_netids", []]];

if (count _netids == 0 || !isServer) exitWith {};

{
	// remove jammers, do not update it, as we do a combined update after removing entire array
	[_x, false] call FUNC(removeJammerServer);	
} forEach _netids;

// broadcast update
[QGVAR(updateJammers), [GVAR(jamMap)]] call CBA_fnc_globalEvent;