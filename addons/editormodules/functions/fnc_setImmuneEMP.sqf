#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_setImmuneEMP.sqf

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
	private _immunity = _logic getVariable ["Immune",true];
	{
		_x setVariable [QEGVAR(emp,immuneEMP), _immunity, true];
	} forEach _units;
};
// Module function is executed by spawn command, so returned value is not necessary, but it is good practice.

true;
