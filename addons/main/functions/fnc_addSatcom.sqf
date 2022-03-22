#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_addSatcom.sqf
Parameters: pos, _unit
Return: none

Called upon event, adds the satcom to local gvar array

*///////////////////////////////////////////////
params ["_unit", "_radius"];

// if object is null, exitwith
if (isNull _unit) exitWith {};

private _netId = netId _unit;
GVAR(satcom_active_list) set [_netId, [_unit, _radius]];

// add marker
[_unit, _netId, _radius, false] call FUNC(updateSatcomMarker);

// push so other zeus can draw markers too
missionNamespace setVariable[QGVAR(satcomActiveList), GVAR(satcom_active_list), true];
