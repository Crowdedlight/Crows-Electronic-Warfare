#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_updateBeacons.sqf
Parameters: array of beacons
Return: none

Update pushed from server, handle additions and removals

*///////////////////////////////////////////////
params ["_beacons"];

// save current beacon state
GVAR(beacons) = _beacons;

// for zeus viewing we push it all into a hashmap. In future might want to change the entire storage chain to hashmaps

// zero current hashmap so we can rebuild it
EGVAR(zeus,zeusTextBeaconMap) = createHashMap;

{
	_x params ["_unit", "_frequency", "_scanRange", "_type"];

	private _netId = netId _unit;
	// get key if exists
	private _curr = EGVAR(zeus,zeusTextBeaconMap) getOrDefault [_netId, []];
	// push back current beacon
	_curr pushBack [_unit, _frequency, _scanRange, _type];
	// set data
	EGVAR(zeus,zeusTextBeaconMap) set [_netId, _curr];
} forEach GVAR(beacons);
