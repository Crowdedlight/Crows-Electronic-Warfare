#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_fireEMP.sqf

*///////////////////////////////////////////////

// Argument 0 is module logic.
_logic = param [0,objNull,[objNull]];

// Argument 1 is list of affected units (affected by value selected in the 'class Units' argument))
_units = param [1,[],[[]]];

// True when the module was activated, false when it is deactivated (i.e., synced triggers are no longer active)
_activated = param [2,true,[true]];

// Module specific behavior. Function can extract arguments from logic and use them.
if (_activated) then {
	// Attribute values are saved in module's object space under their class names
	private _pos = getPosASL _logic;
	private _unit = objNull;
	if (count _units > 0) then {_unit = _units#0;};
	private _range = _logic getVariable ["Range",0];
	private _spawnDevice = _logic getVariable ["SpawnDevice",false];
	private _scopeMode = _logic getVariable ["ScopesOptions",0];
	private _binoMode = _logic getVariable ["BinoOptions",0];

	// broadcast event to server - params ["_unit", "_loopTime", "_range", "_repeat", "_aliveCondition", "_sound"];
	[QEGVAR(emp,eventFireEMP), [_pos, _unit, _range, _spawnDevice, _scopeMode, _binoMode]] call CBA_fnc_serverEvent;
};
// Module function is executed by spawn command, so returned value is not necessary, but it is good practice.

true;
