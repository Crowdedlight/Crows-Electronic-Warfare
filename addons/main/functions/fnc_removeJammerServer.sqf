#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_removeJammerServer.sqf
Parameters: _unit, _broadcast
Return: none

SERVER ONLY
remove jammer from object given, with option to broadcast it to sync across clients. Is true by default. 

*///////////////////////////////////////////////
params ["_object", ["_broadcast", true]];

if (isNull _object || !isServer) exitWith {};

private _netId = netId _object;

// delete key in hashmap with this netid 
GVAR(jamMap) deleteAt _netId;

// delete marker on this machine. Other clients will catch up as local_jammer loop sees they are not there anymore
//  I need netid or housekeeping of local jamming markers to delete local markers, if they are deleted on other clients and sync'ed with publicVar. 
// Handling it for now with Global event. Doesn't require jip, as it just tells all current clients to remove markers. JIP that joins won't create those local markers, as they get current state of jam objects, not past. 
// [QGVAR(removeJamMarker), [_netId]] call CBA_fnc_globalEvent;

// delete sound effect 
[_object] call EFUNC(sounds,removeSound);

// broadcast to sync if needed
if (_broadcast) then {
	[QGVAR(updateJammers), [GVAR(jamMap)]] call CBA_fnc_globalEvent;
};
