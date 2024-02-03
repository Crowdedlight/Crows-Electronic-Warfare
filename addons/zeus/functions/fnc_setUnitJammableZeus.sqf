#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_setUnitJammableZeus.sqf

*///////////////////////////////////////////////

// Argument 0 is module logic.
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

if (isNull _unit) exitWith {
	[QGVAR(showHintZeus), ["SetUnitJammable must be placed on a unit"]] call CBA_fnc_globalEvent;
};

[_unit, true] call EFUNC(spectrum,initDroneSignals);
