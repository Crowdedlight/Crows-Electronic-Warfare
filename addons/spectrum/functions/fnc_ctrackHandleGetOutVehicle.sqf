#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_ctrackHandleGetOutVehicle.sqf
Parameters: _unit
Return: none

*///////////////////////////////////////////////

// params ["_vehicle", "", "_unit"];
params ["_unit", "_role", "_vehicle", "_turret", "_isEject"];

// only do this on local units/players
if (!local _unit) exitWith {};

// if unit has ctrack attached
[QGVAR(removeBeacon), [_vehicle]] call CBA_fnc_serverEvent;
