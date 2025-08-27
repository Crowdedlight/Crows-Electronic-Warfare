#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_settingChangedZeusJamImmunity.sqf
Parameters: value
Return: none

resets jamming effects if immunity is enabled

*///////////////////////////////////////////////
params ["_value"];

// if we disable, we get jam effect on next update loop anyway
if (!_value) exitWith {};

// otherwise if enabled, we reset radio degradation
[player] call FUNC(resetRadioIfDegraded);
