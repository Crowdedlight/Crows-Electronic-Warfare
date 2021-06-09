#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_actionJamToggle.sqf
Parameters: jammer
Return: none

toggle enable/disable jam on the radio tower. Action option

*///////////////////////////////////////////////
params ["_target", "_caller", "_actionId", "_arguments"];

// get current value 
private _jamValue = _target getVariable [QGVAR(jamming_enabled), true];
_target setVariable [QGVAR(jamming_enabled), !_jamValue];
