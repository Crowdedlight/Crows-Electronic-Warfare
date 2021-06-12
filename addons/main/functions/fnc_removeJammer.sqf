#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_removeJammerZeus.sqf
Parameters: pos, _unit
Return: none

remove jammer from object 

*///////////////////////////////////////////////
params ["_unit"];

if (isNull _unit) exitWith {};

private _netId = netId _unit;

// delete key in hashmap with this netid 
GVAR(jamMap) deleteAt _netId;