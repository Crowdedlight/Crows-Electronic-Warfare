#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_addSignalSource.sqf

module to set object as Spectrum signal source

*///////////////////////////////////////////////

// Argument 0 is module logic.
_logic = param [0,objNull,[objNull]];

// Argument 1 is list of affected units (affected by value selected in the 'class Units' argument))
_units = param [1,[],[[]]];

// True when the module was activated, false when it is deactivated (i.e., synced triggers are no longer active)
_activated = param [2,true,[true]];

if (count _units < 1) exitWith {
	[QEGVAR(zeus,showHintZeus), ["AddSignalSource editor module requires one unit/object synced to it as signal source"]] call CBA_fnc_globalEvent;
};

// Module specific behavior. Function can extract arguments from logic and use them.
if (_activated) then {
	// Attribute values are saved in module's object space under their class names
	private _freq = _logic getVariable ["Frequency",0];
	private _range = _logic getVariable ["Range",0];
	[QEGVAR(spectrum,addBeacon), [_units#0, _freq, _range, "zeus"]] call CBA_fnc_serverEvent;
};
// Module function is executed by spawn command, so returned value is not necessary, but it is good practice.

true;
