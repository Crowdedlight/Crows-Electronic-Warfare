#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_toggleJammerServer.sqf
Parameters: netid, enabled
Return: none

Handles when server is asked to enable or disable a jammer
SERVER ONLY

*///////////////////////////////////////////////
params ["_netId", "_enabled"];

// making sure object hasn't been removed during event transit time.
if (!(_netId in GVAR(jamMap)) || !isServer) exitWith {};

// get value and update the enabled value
private _jammer = GVAR(jamMap) get _netId;
_jammer set [3, _enabled];

// save changes to map
GVAR(jamMap) set [_netId, _jammer];

// broadcast update
[QGVAR(updateJammers), [GVAR(jamMap)]] call CBA_fnc_GlobalEvent;

// show jammers in the spectrum
if (_enabled) then {
	[_jamObj, 433, 300, "sweep"] call EFUNC(spectrum,addBeaconServer);
} else {
	[_jamObj] call EFUNC(spectrum,removeBeaconServer);
};

