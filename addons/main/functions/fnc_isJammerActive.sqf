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
(_jammer select 3)
