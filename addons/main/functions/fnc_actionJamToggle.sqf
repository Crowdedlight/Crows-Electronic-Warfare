#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_actionJamToggle.sqf
Parameters: jammer
Return: none

toggle enable/disable jam on the radio tower. Action option

*///////////////////////////////////////////////
params ["_target", "_caller", "_actionId", "_arguments"];
_arguments params ["_netId"];

// get current value
private _jammer = GVAR(jamMap) get _netId;
private _enabled = _jammer select 3;

// broadcast event to set the jammer with this key as disabled
[QGVAR(actionToggleJam), [_netId, !_enabled]] call CBA_fnc_globalEventJIP;