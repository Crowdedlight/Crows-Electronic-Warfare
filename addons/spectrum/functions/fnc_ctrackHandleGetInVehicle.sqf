#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_ctrackHandleGetInVehicle.sqf
Parameters: _unit
Return: none

*///////////////////////////////////////////////

// params ["_vehicle", "", "_unit"];
params ["_unit", "_role", "_vehicle", "_turret"];

// only do this on local units/players
if (!local _unit) exitWith {};

// if unit has ctrack attached 
private _savedFreq = _unit getVariable[QGVAR(ctrack_attached_frequency), 0];
private _savedRange = _unit getVariable[QGVAR(ctrack_attached_range), 0];

// if variable is empty we exit as we got nothing to do
if (_savedFreq == 0 || _savedRange == 0) exitWith{};

// not empty, we have a ctrack attached. So while we are in the vehicle, we are going to push the source onto the vehicle! 
private _ctrackJip = [QGVAR(addBeacon), [_vehicle, _savedFreq, _savedRange, "ctrack"]] call CBA_fnc_globalEventJIP;

// save jip id on vehicle 
_vehicle setVariable[QGVAR(ctrack_attached_jipID), _ctrackJip];
