#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_updateJamMarker.sqf
Parameters: _jammer, _updating
Return: none

updates local marker for the jammer to show on map. Only called for zeus, so only zeus can see the jammer radius

*///////////////////////////////////////////////
params ["_jammer", "_updating"];

// get marker name to delete and recreate 
private _markArea = _jammer getVariable [QGVAR(mark_area), netId _jammer];
// private _markPos = _jammer getVariable [QGVAR(mark_pos), netId _jammer];
private _markDist = _jammer getVariable [QGVAR(jamming_radius), 0];

// delete existing marker, unless we are creating them first time
if (_updating) then {
	deletemarkerLocal _markArea;
	// deletemarkerLocal _markPos;
};

_markArea = createMarkerLocal [_markArea, position _jammer];
_markArea setMarkerShapeLocal "ELLIPSE";
_markArea setMarkerSizeLocal [_markDist, _markDist];
_markArea setMarkerAlphaLocal 0.5;

// //Position Marker
// _markPos = createMarkerLocal [_markPos, position _jammer];
// _markPos setMarkerShapeLocal "ICON";
// _markPos setMarkerTypeLocal "mil_dot";

// save in jam vars
_jammer setVariable [QGVAR(mark_area), _markArea];
// _jammer setVariable [QGVAR(mark_pos), _markPos];
