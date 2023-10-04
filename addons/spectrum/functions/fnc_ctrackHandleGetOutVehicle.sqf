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

// if unit has ctrack attached, we remove it and delete jip of add event
private _jip = _vehicle getVariable[QGVAR(ctrack_attached_jipID), ""];

if (_jip != "") then {

	// remove beacon
	private _jipRemoveID = [QGVAR(removeBeacon), [_vehicle]] call CBA_fnc_globalEventJIP;

	[_jip] call CBA_fnc_removeGlobalEventJIP;
	[_jipRemoveID] call CBA_fnc_removeGlobalEventJIP;
	_vehicle setVariable[QGVAR(ctrack_attached_jipID), ""];
}
