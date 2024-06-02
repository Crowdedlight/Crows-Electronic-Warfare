#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_setUnitJammableZeus.sqf

*///////////////////////////////////////////////

// Argument 0 is module logic.
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

if (isNull _unit) exitWith {
	[QGVAR(showHintZeus), ["STR_CROWSEW_Zeus_jammable_error"]] call CBA_fnc_globalEvent;
};

[QEGVAR(spectrum,setUnitJammable), [_unit]] call CBA_fnc_serverEvent;
