#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_isJammerEnabled.sqf
Parameters: _jammer
Return: if jamming is enabled

Checks if jammer is enabled

*///////////////////////////////////////////////
params ["_target", "_this"];

_target getVariable QGVAR(jamming_enabled);