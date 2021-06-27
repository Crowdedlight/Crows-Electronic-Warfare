#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_fireEMP.sqf
Parameters: pos, _unit, _range, _scopeMode, _binoMode
Return: none

Called upon event, fires EMP. This is server-side. 

*///////////////////////////////////////////////
params ["_pos", "_object", "_range", "_scopeMode", "_binoMode"];

if (!isServer) exitWith {};

// if unit is null, we spawn something and use as EMP on the given position
if (isNull _object) then 
{
	private _posAGL = ASLToAGL _pos;
	_object = createVehicle ["Land_Device_slingloadable_F", _posAGL, [], 0, "NONE"];

	// set zeus editable 
	["zen_common_addObjects", [[_object], objNull]] call CBA_fnc_serverEvent;
};

// create visual effects for all
[[_object, _range],QPATHTOF(functions\fnc_playerEffect.sqf)] remoteExec ["execVM", [0,-2] select isDedicated];

// get close units, cars, static launchers, lights
private _nearestArray = [_object, _range] call FUNC(getNearestElements);
private _vehicles = _nearestArray select 0;
private _lightList = _nearestArray select 1;
private _statics = _nearestArray select 2;
private _men = _nearestArray select 3;

// start EMP effect
private _delay = 0.01; // for processing purposes

// spawn in scheduled enviroment so sleep is allowed.
private _vehicleSpawn = [_delay, _vehicles] spawn {
	params ["_delay", "_vehicles"];
	// disable and set dmg on each vehicle - remoteExec visual effect for all vehicles
	{
		private _v = _x;

		// if immune to emp, skip it, but still do emp effect around the car
		if (_x getVariable [QGVAR(immuneEMP), false]) then {
			[[_x],QPATHTOF(functions\fnc_targetSparkSFX.sqf)] remoteExec ["execVM", [0,-2] select isDedicated];	
			continue;
		};

		// dmg vehicle modules
		{
			// get all eletronic modules in vehicles
			if ("engine" in _x || {"avionics" in _x} ||{"turret" in _x} || 
				{"missiles" in _x} || {"light" in _x} || {"svetlo" in _x} || 
				{"battery" in _x} || {"cam" in _x}) then {
				// set as destroyed
				_v setHitIndex [_forEachIndex, 1];
			};
		} foreach (getAllHitPointsDamage _v select 0);

		// disable TI and NV
		_v disableTIEquipment true; 
		_v disableNVGEquipment true;

		// disable TFAR radios if present 
		_v setVariable ["tf_hasRadio", false, true];

		// remote exec dmg effect 
		[[_x],QPATHTOF(functions\fnc_targetSparkSFX.sqf)] remoteExec ["execVM", [0,-2] select isDedicated];

		sleep _delay;
	} forEach _vehicles;
};

private _lightSpawn = [_delay, _lightList] spawn {
	params ["_delay", "_lights"];
	// disable and set dmg on each light - remoteExec visual effect
	{
		_x setDamage 0.9;

		// remote exec dmg effect 
		[[_x],QPATHTOF(functions\fnc_lampEffect.sqf)] remoteExec ["execVM", [0,-2] select isDedicated];

		sleep _delay;
	} forEach _lights;
};

private _staticSpawn = [_delay, _statics] spawn {
	params ["_delay", "_turrets"];
	// disable and set dmg on each turrent - remoteExec visual effect
	{
		// check if immune and skip if immune
		if (_x getVariable [QGVAR(immuneEMP), false]) then {continue;};

		_x setDamage 1;
		
		// remote exec dmg effect 
		[[_x],QPATHTOF(functions\fnc_lampEffect.sqf)] remoteExec ["execVM", [0,-2] select isDedicated];

		sleep _delay;
	} forEach _turrets;
};

// play radio static sound
["electro_static"] remoteExec ["playsound", [0,-2] select isDedicated];
private _unitSpawn = [_delay, _men, _scopeMode, _binoMode] spawn {
	params ["_delay", "_units", "_scopeMode", "_binoMode"];
	// remove equipment etc.
	{
		// if zeus, skip execution of effects and disabling of gear 
		if (!isNull (getAssignedCuratorLogic _x)) then {continue;};

		// if immune to EMP, or in vic that is immune skip removal and particles of sparks
		if (_x getVariable [QGVAR(immuneEMP), false] || ((vehicle _x) getVariable [QGVAR(immuneEMP), false])) then {continue;};

		// remote exec visual effect - Spawn in scheduled for sleep
		[[_x],QPATHTOF(functions\fnc_targetSparkSFX.sqf)] remoteExec ["execVM", [0,-2] select isDedicated];
		
		// remove equipment
		// remoteExec this, no server specific code, and more effective if each client handles their own removal instead of server having to go through all
		[_x, _scopeMode, _binoMode] remoteExec [QFUNC(unitRemoveItems), _x];

		sleep _delay;
	} forEach _units;
};

// private _handle = [_this, 1000] execVM "\z\crowsEW\emp\functions\fnc_playerEffect.sqf";