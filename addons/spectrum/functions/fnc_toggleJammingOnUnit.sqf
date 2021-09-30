#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_toggleJammingOnUnit.sqf
Parameters: _unit, _enableJam
Return: none

Called upon event to jam or unjam unit

*///////////////////////////////////////////////
params [["_unit", objNull], ["_enableJam", false], ["_jamPlayer", objNull]];

// sanity check for null objs
if (isNull _unit || isNull _jamPlayer) exitWith {};

// get unit variable, as this is on a per unit basis and each client could have multiple units it is local to. 
private _activeJammers = _unit getVariable [QGVAR(activeJammingPlayers), []];
private _jamCount = count _activeJammers;

if (_enableJam) then {

	// add player to jam loop 
	_activeJammers pushBack _jamPlayer;
	_unit setVariable [QGVAR(activeJammingPlayers), _activeJammers];

	// if no jammers active spawn jam loop 
	if (_jamCount != 0) exitWith {};

	// disable AI as we got no other active jammers already
	[QGVAR(toggleAI), [_unit, false], _unit] call CBA_fnc_targetEvent;

	// save units current behaviour
	_unit setVariable [QGVAR(behaviourJam), combatBehaviour (group _unit)];

	// add unit to jammed list 
	private _activelyJammedUnits = missionNamespace getVariable [QGVAR(activeJammedUnits), []];
	_activelyJammedUnits pushBack _unit;
	missionNamespace setVariable [QGVAR(activeJammedUnits), _activelyJammedUnits, true];
	
	// systemChat "disabled all AI";

	private _spawnedJamLoop = [_unit] spawn {
		params ["_unit"];

		while {alive _unit && !isNull _unit} do {
			// get latest jam list 
			private _activeJammers = _unit getVariable[QGVAR(activeJammingPlayers), []];

			// check for cleanup
			private _rmArr = [];
			{
				// safety catch that even if we go unconsious or change weapon without a mouse-up event jamming will be disabled
				if (!("hgun_esd_" in (currentWeapon _x)) || !alive _x) then {
					// add to rm array 
					// systemChat format["Removing %1 from jam-array", _x];
					_rmArr pushBack _x;
				};
			} forEach _activeJammers;

			// cleanup 
			_activeJammers = _activeJammers - _rmArr;
			_activeJammers = _activeJammers - [objNull];

			// systemChat str(_activeJammers);

			// set new variable, as new jammers won't be obtained otherwise
			_unit setVariable[QGVAR(activeJammingPlayers), _activeJammers];

			// if 0 jammers, we enable AI, and exit the loop
			if (count _activeJammers == 0) exitWith {
				// enable all AI 
				[QGVAR(toggleAI), [_unit, true], _unit] call CBA_fnc_targetEvent;
				// systemChat "Enabled AI";

				// set behaviour back to initial 
				private _initialBehav = _unit getVariable [QGVAR(behaviourJam), "AWARE"];
				if (_initialBehav != "ERROR" && !isNull _unit) then {
					(group _unit) setCombatBehaviour _initialBehav;
				};

				// remove from active jam list
				private _activelyJammedUnits = missionNamespace getVariable [QGVAR(activeJammedUnits), []];
				_activelyJammedUnits = _activelyJammedUnits - [_unit];
				_activelyJammedUnits = _activelyJammedUnits - [objNull];
				missionNamespace setVariable [QGVAR(activeJammedUnits), _activelyJammedUnits, true];
			};

			sleep 0.5; // repeat only every 0.5s as should be enough as response for enable or disable jamming
		};
		// catch all, always enable AI if we leave the loop, should already have been done, but for good measure we repeat in case we left loop by error
		[QGVAR(toggleAI), [_unit, true], _unit] call CBA_fnc_targetEvent;

		// remove from active jam list
		private _activelyJammedUnits = missionNamespace getVariable [QGVAR(activeJammedUnits), []];
		_activelyJammedUnits = _activelyJammedUnits - [_unit];
		_activelyJammedUnits = _activelyJammedUnits - [objNull];
		missionNamespace setVariable [QGVAR(activeJammedUnits), _activelyJammedUnits, true];
	};
} else {
	// remove player from jamming list - spawned script should handle it from here to enable AI, if no other jammers are active. 
	// systemChat "removing player from jam list";
	_activeJammers = _activeJammers - [_jamPlayer];
	_unit setVariable [QGVAR(activeJammingPlayers), _activeJammers];
};




