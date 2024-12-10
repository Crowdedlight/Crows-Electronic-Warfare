#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight

File: fnc_fireEMP.sqf
Parameters: pos, _unit, _range, _scopeMode, _binoMode
Return: none

Called upon event, fires EMP. This is server-side.

*///////////////////////////////////////////////
params ["_pos", "_object", "_range", "_spawnDevice", "_scopeMode", "_binoMode"];

if (!isServer) exitWith {};

private _pos = ASLToAGL _pos;

// if unit is null, we spawn something and use as EMP on the given position
if (isNull _object && _spawnDevice) then
{
	_object = createVehicle ["Crows_Emp_Device", _pos, [], 0, "CAN_COLLIDE"];

	_pos = ASLToAGL getPosASL _object;

	// set zeus editable
	["zen_common_addObjects", [[_object], objNull]] call CBA_fnc_serverEvent;
};

[QGVAR(playerEffect), [_pos, _range]] call CBA_fnc_globalEvent;

// get close units, cars, static launchers, lights
private _nearestArray = [_pos, _range] call FUNC(getNearestElements);
private _vehicles = _nearestArray select 0;
private _lightList = _nearestArray select 1;
private _statics = _nearestArray select 2;
private _men = _nearestArray select 3;

// start EMP effect
private _delay = 0.01; // for processing purposes

// spawn in scheduled enviroment so sleep is allowed.
private _vehicleSpawn = [_delay, _vehicles] spawn {
	params ["_delay", "_vehicles"];

	private _vicTargetEffectArr = [];

	// disable and set dmg on each vehicle - remoteExec visual effect for all vehicles
	{
		private _v = _x;

		// skip if not alive
		if (!alive _x) then { continue; };

		// if immune to emp, skip it, but still do emp effect around the car
		if (_x getVariable [QGVAR(immuneEMP), false]) then {
			_vicTargetEffectArr pushBack _x;
			continue;
		};

		// dmg vehicle modules
		{
			// get all electronic modules in vehicles
			if ("engine" in _x || {"avionics" in _x} ||{"turret" in _x} ||
				{"missiles" in _x} || {"light" in _x} || {"svetlo" in _x} ||
				{"battery" in _x} || {"cam" in _x}) then {
				// set as destroyed, Global effect, but local argument, so we execute where the unit is local
				[_v, [_forEachIndex, 1]] remoteExec ["setHitIndex", _v];
			};
		} forEach (getAllHitPointsDamage _v select 0);

		// disable TI and NV
		_v disableTIEquipment true;
		_v disableNVGEquipment true;

		// disable TFAR radios if present
		_v setVariable ["tf_hasRadio", false, true];

		// add to array for dmg effect
		_vicTargetEffectArr pushBack _x;
		//

		sleep _delay;
	} forEach _vehicles;

	[QGVAR(sparkEffect), [_vicTargetEffectArr]] call CBA_fnc_globalEvent;
};

// combine targets for light effect into one list
private _lightEffectArr = _lightList;

// disable and set dmg on each light - remoteExec visual effect
{
	_x setDamage 0.96;
} forEach _lightList;

// disable and set dmg on each turrent - remoteExec visual effect
{
	// check if immune and skip if immune
	if (_x getVariable [QGVAR(immuneEMP), false] || !alive _x) then {continue;};

	// add to effect list, if not immune
	_lightEffectArr pushBack _x;

	_x setDamage 1;

	sleep _delay;
} forEach _statics;

// Each player only spawn effect if within visual range aka. 500m
[QGVAR(lightEffect), [_lightEffectArr]] call CBA_fnc_globalEvent;

// play radio static sound
["crowsew_electro_static"] remoteExec ["playSound", [0,-2] select isDedicated];

private _unitSpawn = [_delay, _men, _scopeMode, _binoMode] spawn {
	params ["_delay", "_units", "_scopeMode", "_binoMode"];
	// remove equipment etc.
	{
		// if zeus, skip execution of effects and disabling of gear
		if (!isNull (getAssignedCuratorLogic _x)) then {continue;};

		// if immune to EMP, or in vic that is immune skip removal and particles of sparks
		if (_x getVariable [QGVAR(immuneEMP), false] || ((vehicle _x) getVariable [QGVAR(immuneEMP), false])) then {continue;};

		// remove equipment
		// remoteExec this, no server specific code, and more effective if each client handles their own removal instead of server having to go through all
		[_x, _scopeMode, _binoMode] remoteExec [QFUNC(unitRemoveItems), _x];

		sleep _delay;
	} forEach _units;
};