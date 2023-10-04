#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_setUnitJammable.sqf.sqf

*///////////////////////////////////////////////

// Argument 0 is module logic.
_logic = param [0,objNull,[objNull]];

// Argument 1 is list of affected units (affected by value selected in the 'class Units' argument))
_units = param [1,[],[[]]];

// True when the module was activated, false when it is deactivated (i.e., synced triggers are no longer active)
_activated = param [2,true,[true]];

if (count _units < 1) exitWith {
	[QEGVAR(zeus,showHintZeus), ["SetUnitJammable editor module requires at least one unit/object synced to it"]] call CBA_fnc_globalEvent;
};

// Module specific behavior. Function can extract arguments from logic and use them.
if (_activated) then {
	// Attribute values are saved in module's object space under their class names
	private _applyToClass = _logic getVariable ["Classname",false];
	{
		[_x, true] call EFUNC(spectrum,initDroneSignals);
	} forEach _units;

	// if apply to classname, make list of unique classnames of synced units, and set eventhandlers. 
	if (_applyToClass) then 
	{
		private _classnames = [];
		{
			_classnames pushBack (typeOf _x);
		} forEach _units;
		// remove duplicates
		_classnames = _classnames arrayIntersect _classnames;

		// set eventhandler for each classname
		{
			[_x, "initPost", {[_this#0] call EFUNC(spectrum,initDroneSignals);}] call CBA_fnc_addClassEventHandler;
		} forEach _classnames;
	};

};
// Module function is executed by spawn command, so returned value is not necessary, but it is good practice.

true;
