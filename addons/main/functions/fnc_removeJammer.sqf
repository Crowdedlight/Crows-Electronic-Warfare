#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_removeJammer.sqf
Parameters: pos, _unit
Return: none

remove jammer from object 

*///////////////////////////////////////////////
params ["_unit"];

if (isNull _unit) exitWith {};

private _netId = netId _unit;

// delete key in hashmap with this netid 
GVAR(jamMap) deleteAt _netId;

// if map is now 0, reset the jamming vars for the player, as the PFH does not reset or do logic when map is 0. 
if (count GVAR(jamMap) == 0) then {
	player setVariable ["tf_receivingDistanceMultiplicator", 1];
	player setVariable ["tf_sendingDistanceMultiplicator", 1];
};

// delete marker
[_netId] call FUNC(removeJamMarker);

// delete sound effect 
[QEGVAR(sounds,removeSound), [_unit]] call CBA_fnc_serverEvent;
