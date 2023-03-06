#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_ctrack_init.sqf
Parameters: _unit
Return: none

*///////////////////////////////////////////////
params [["_unit", objNull]];

// get config value for range 
private _range = getNumber (configFile >> "CfgVehicles" >> typeOf _unit >> "range");

[QGVAR(addBeacon), [_unit, 450, _range, "ctrack"]] call CBA_fnc_globalEventJIP;

// TODO consider moving the spectrum signal to the unit instead of the tracker for units? As otherwise when you get into vehicles the signal disappears as the item is detatched?
// if attached to man, we hide the model as it sits stupidly on the shoulder
[
	{
		diag_log (attachedTo (_this#0));
		if ((attachedTo (_this#0)) isKindOf "CAManBase") then {
			_this#0 hideObjectGlobal true;
		}
	},
	[_unit],
	1
] call CBA_fnc_waitAndExecute;
