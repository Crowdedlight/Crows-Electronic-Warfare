#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_removeJammerServer.sqf
Parameters: _netid, _broadcast
Return: none

SERVER ONLY
remove jammer from object given, with option to broadcast it to sync across clients. Is true by default. 

*///////////////////////////////////////////////
params [["_netid", ""], ["_broadcast", true]];

if (_netid == "" || !isServer) exitWith {};

// get reference to object before deleting jamMap entry
private _jammerObj = (GVAR(jamMap) get _netid) #0;

// delete key in hashmap with this netid 
GVAR(jamMap) deleteAt _netId;

// delete marker on this machine. Other clients will catch up as local_jammer loop sees they are not there anymore
//  I need netid or housekeeping of local jamming markers to delete local markers, if they are deleted on other clients and sync'ed with publicVar. 
// Handling it for now with Global event. Doesn't require jip, as it just tells all current clients to remove markers. JIP that joins won't create those local markers, as they get current state of jam objects, not past. 
// [QGVAR(removeJamMarker), [_netId]] call CBA_fnc_globalEvent;

// delete sound effect if object is not null. If its null, our sound cleaner would already have cleaned it up
if (!isNull _jammerObj) then {
	[_jammerObj] call EFUNC(sounds,removeSound);
};

// broadcast to sync if needed
if (_broadcast) then {
	[QGVAR(updateJammers), [GVAR(jamMap)]] call CBA_fnc_globalEvent;
};

// if hosted multiplayer, then server and host will have same hashmap, and thus client update function will not detect the changes in state and correctly remove jam markers. So we remove them here
if (isServer && hasInterface) then {
	[[_netid]] call FUNC(removeJamMarkers); 
};