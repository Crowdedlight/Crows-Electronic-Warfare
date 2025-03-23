#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_ctrackHandleKilled.sqf
Parameters: _unit
Return: none

*///////////////////////////////////////////////

// params ["_vehicle", "", "_unit"];
params ["_unit", "_role", "_vehicle", "_turret"];

// only do this on local units/players
if (!local _unit) exitWith {};

// if unit has ctrack attached 
private _items = attachedObjects _unit;
{
	if (_x isKindOf "crowsew_ctrack_effect") then {
		// remove beacon 
		[QGVAR(removeBeacon), [_x, "ctrack"]] call CBA_fnc_serverEvent;
	}
} forEach _items;
