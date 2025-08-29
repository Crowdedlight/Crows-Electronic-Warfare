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
private _capabilities = (GVAR(jamMap) get _netid) #4;

// delete key in hashmap with this netid 
GVAR(jamMap) deleteAt _netId;

// delete this as an active jammer from any units its currently jamming. To make the spawned jam loop stop it.
// Even though we have to go through all current jammed units, and pull their variables, I believe this is better performance than having each unit run a check every second in their update loop, 
// as this is only done when a jammer is removed through zeus/script
if (JAM_CAPABILITY_DRONE in _capabilities) then {
	private _activelyJammedUnits = missionNamespace getVariable[QEGVAR(spectrum,activeJammedUnits), []];
	{
		// untoggle this jammer from all drones its jamming
		[_x, false, _jammerObj] call EFUNC(spectrum,toggleJammingOnUnit);
	} forEach _activelyJammedUnits;
};

if (!isNull _jammerObj) then {
	// delete sound effect if object is not null. If its null, our sound cleaner would already have cleaned it up
	[_jammerObj] call EFUNC(sounds,removeSound);

	// remove jammer as a signal source for the Spectrum Device
	[_jammerObj] call EFUNC(spectrum,removeBeaconServer);
};

// broadcast to sync if needed
if (_broadcast) then {
	[QGVAR(updateJammers), [GVAR(jamMap)]] call CBA_fnc_globalEvent;
};

// if hosted multiplayer, then server and host will have same hashmap, and thus client update function will not detect the changes in state and correctly remove jam markers. So we remove them here
if (isServer && hasInterface) then {
	[[_netid]] call FUNC(removeJamMarkers); 
};

// remove jammer variable from object. For zeus context action
_jammerObj setVariable[QGVAR(isJammer), false, true];
