#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_isJammerActive.sqf
Parameters: netID
Return: none

Returns true if jammer is set active

*///////////////////////////////////////////////
params ["_netId"];

private _jammer = GVAR(jamMap) get _netId;
systemChat format ["IsJammerActive: %1, NetId: %2", (_jammer select 3), _netId];
systemChat format ["jammer object: %1", _jammer];
(_jammer select 3)
