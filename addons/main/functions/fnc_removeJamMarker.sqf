#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_removeJamMarker.sqf
Parameters: _jammer, _updating
Return: none

removes local marker for the jammer to show on map. Only called for zeus, so only zeus can see the jammer radius

*///////////////////////////////////////////////
params ["_jammer"];

private _markArea = _jammer getVariable [QGVAR(mark_area), netId _jammer];
// private _markPos = _jammer getVariable [QGVAR(mark_pos), netId _jammer];
deletemarkerLocal _markArea;
// deletemarkerLocal _markPos;