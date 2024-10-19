#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_enableTrackingTfar.sqf

*///////////////////////////////////////////////

// Argument 0 is module logic.
_logic = param [0,objNull,[objNull]];

// Argument 1 is list of affected units (affected by value selected in the 'class Units' argument))
_units = param [1,[],[[]]];

// True when the module was activated, false when it is deactivated (i.e., synced triggers are no longer active)
_activated = param [2,true,[true]];

// we seem to run before postInit is done, so got to sleep otherwise eventhandlers and functions in other modules aren't setup
sleep 1;

if (!EGVAR(zeus,hasTFAR)) exitWith {
	[QEGVAR(zeus,showHintZeus), ["STR_CROWSEW_Editormodules_trackingtfar_error"]] call CBA_fnc_globalEvent;
};

// Module specific behavior. Function can extract arguments from logic and use them.
if (_activated) then {
	// Attribute values are saved in module's object space under their class names
	// jipId is set here, so we don't make a stack of events, but just overwrite the same event, as we only want JIP to get latest state. Should probably be changed to server-auth model too...
	[QEGVAR(spectrum,toggleRadioTracking), [true], QEGVAR(spectrum,radioTracking)] call CBA_fnc_globalEventJIP;
};
// Module function is executed by spawn command, so returned value is not necessary, but it is good practice.

true;
