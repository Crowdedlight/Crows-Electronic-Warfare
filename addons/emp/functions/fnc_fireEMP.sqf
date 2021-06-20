#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_fireEMP.sqf
Parameters: pos, _unit, _range
Return: none

Called upon event, fires EMP. This is server-side. 

*///////////////////////////////////////////////
params ["_pos", "_object", "_range"];

if (!isServer) exitWith {};

// if unit is null, we spawn something and use as EMP on the given position
// TODO

// create visual effects for all
[[_object, _range],QPATHTOF(functions\fnc_playerEffect.sqf)] remoteExec ["execVM", [0,-2] select isDedicated];

// get close units, cars, static launchers, lights
private _nearestArray = [_object, _range] call FUNC(getNearestElements);
private _vehicles = _nearestArray select 0;
private _lights = _nearestArray select 1;
private _statics = _nearestArray select 2;
private _men = _nearestArray select 3;

// start EMP effect
private _delay = 0.01; // for processing purposes

// play rumble for all but server
["rumble"] remoteExec ["playsound", [0,-2] select isDedicated];

// spawn in scheduled enviroment so sleep is allowed.
private _vehicleSpawn = [_delay, _vehicles] spawn {
	params ["_delay, _vehicles"];
	// disable and set dmg on each vehicle - remoteExec visual effect for all vehicles
	{
		private _v = _x;

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

		// remote exec dmg effect 
		[[_x],QPATHTOF(functions\fnc_targetSparkSFX.sqf)] remoteExec ["execVM", [0,-2] select isDedicated];

		sleep _delay;
	} forEach _vehicles;
};

private _lightSpawn = [_delay, _lights] spawn {
	params ["_delay, _lights"];
	// disable and set dmg on each light - remoteExec visual effect
	{
		_x setDamage 0.9;

		// remote exec dmg effect 
		[[_x],QPATHTOF(functions\fnc_lampEffect.sqf)] remoteExec ["execVM", [0,-2] select isDedicated];

		sleep _delay;
	} forEach _lights;
};

private _staticSpawn = [_delay, _statics] spawn {
	params ["_delay, _turrets"];
	// disable and set dmg on each turrent - remoteExec visual effect
	{
		_x setDamage 1;
		
		// remote exec dmg effect 
		[[_x],QPATHTOF(functions\fnc_lampEffect.sqf)] remoteExec ["execVM", [0,-2] select isDedicated];

		sleep _delay;
	} forEach _turrets;
};

// play radio static sound
["electro_static"] remoteExec ["playsound", [0,-2] select isDedicated];
private _unitSpawn = [_delay, _men] spawn {
	params ["_delay, _units"];
	// remove equipment etc.
	{
		// remote exec visual effect - Spawn in scheduled for sleep
		[[_x],QPATHTOF(functions\fnc_targetSparkSFX.sqf)] remoteExec ["execVM", [0,-2] select isDedicated];
		
		// remove equipment
		[_x] call FUNC(unitRemoveItems);		

		sleep _delay;
	} forEach _units;
};

// private _handle = [_this, 1000] execVM "\z\crowsEW\emp\functions\fnc_playerEffect.sqf";