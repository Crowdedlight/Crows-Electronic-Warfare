#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_addJammer.sqf
Parameters: pos, _unit
Return: none

Called upon event, adds the jammer to local gvar array and starts while loop, if it isn't running

*///////////////////////////////////////////////
params ["_unit", "_rad", "_strength"];

// if object is null, exitwith. Can happen if we get event as JIP but object has been removed
if (_unit == objNull) exitWith {};

// set jammer vars
_unit setVariable [QGVAR(jamming_enabled), true];
_unit setVariable [QGVAR(jamming_radius), _rad];
_unit setVariable [QGVAR(jamming_strength), _strength];

// add action 
_unit addAction ["<t color=""#FFFF00"">Pull Out Wires", FUNC(actionJamToggle), [], 7, true, true, "", "!(_target getVariable [QGVAR(jamming_enabled), false])", 6];
_unit addAction ["<t color=""#FFFF00"">Gaffa Wires Back In", FUNC(actionJamToggle), [], 7, true, true, "", "(_target getVariable [QGVAR(jamming_enabled), false])", 6];

// add to array
GVAR(jamlist) pushBack _unit;


// _this addAction ["<t color=""#FFFF00"">Enable Jammer", crowsEW_main_fnc_actionJamToggle, [], 7, true, true, "", '(_target getVariable ["crowsEW_main_fnc_jamming_enabled", false])', 6];
// _this addAction ["<t color=""#FFFF00"">Disable Jammer", crowsEW_main_fnc_actionJamToggle, [], 7, true, true, "", '!(_target getVariable ["crowsEW_main_fnc_jamming_enabled", false])', 6];