#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_toggleAi.sqf
Parameters: _unit
Return: none

Called to enable or disable AI

*///////////////////////////////////////////////
params [["_unit", objNull], ["_enable", false]];

// only run on where the unit is local
if (!local _unit) exitWith {};

if (_enable) then {
	{
		_x enableAI "all";
	} forEach (crew _unit);
} else {
	{
		_x disableAI "all";
	} forEach (crew _unit);
}
