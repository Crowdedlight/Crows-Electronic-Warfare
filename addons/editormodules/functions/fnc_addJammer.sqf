#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_addJammer.sqf

module to set object as jammer

*///////////////////////////////////////////////

// Argument 0 is module logic.
_logic = param [0,objNull,[objNull]];

// Argument 1 is list of affected units (affected by value selected in the 'class Units' argument))
_units = param [1,[],[[]]];

// True when the module was activated, false when it is deactivated (i.e., synced triggers are no longer active)
_activated = param [2,true,[true]];

sleep 1;

// Module specific behavior. Function can extract arguments from logic and use them.
if (_activated) then {

	private _unit = objNull;
	// if object is null, we spawn a dataterminal on the selected position instead
	if (count _units < 1) then {
		// no obj selected 
		private _posAGL = ASLToAGL getPosASL _logic;
		private _dataTerminal = createVehicle ["Land_DataTerminal_01_F", _posAGL, [], 0, "NONE"];

		// set zeus editable 
		["zen_common_addObjects", [[_dataTerminal], objNull]] call CBA_fnc_serverEvent;

		// set as jam object
		_unit = _dataTerminal;
	} else
	{
		_unit = _units#0;
	};
	
	// Attribute values are saved in module's object space under their class names
	private _rad = _logic getVariable ["Radius",0];
	private _strength = _logic getVariable ["Strength",0];

	// broadcast event to all clients and JIP
	[QEGVAR(main,addJammer), [_unit, _rad, _strength]] call CBA_fnc_globalEventJIP;

	// broadcast sound to server for sound handling - Means we don't get duplicate broadcasts due to JIP.
	// params ["_unit", "_delay", "_range", "_repeat", "_aliveCondition", "_sound", "_startDelay", "_volume"];
	[getPosATL _unit, 50, "jam_start", 3] call EFUNC(sounds,playSoundPos);
	[QEGVAR(sounds,addSound), [_unit, 0.5, 50, true, true, "jam_loop", 3, 3]] call CBA_fnc_serverEvent;
};
// Module function is executed by spawn command, so returned value is not necessary, but it is good practice.

true;
