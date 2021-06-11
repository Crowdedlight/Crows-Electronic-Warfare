#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_updateJamMarker.sqf
Parameters: _jammer, _updating
Return: none

updates local marker for the jammer to show on map. Only called for zeus, so only zeus can see the jammer radius

*///////////////////////////////////////////////
params ["_jammer", "_netId", "_radius", "_updating"];

// delete existing marker, unless we are creating them first time
if (_updating) then {
	deletemarkerLocal _netID;
	// deletemarkerLocal _markPos;
};

_netID = createMarkerLocal [_netID, position _jammer];
_netID setMarkerShapeLocal "ELLIPSE";
_netID setMarkerSizeLocal [_radius, _radius];
_netID setMarkerAlphaLocal 0.5;

// //Position Marker
// _markPos = createMarkerLocal [_markPos, position _jammer];
// _markPos setMarkerShapeLocal "ICON";
// _markPos setMarkerTypeLocal "mil_dot";

// save in jam vars
// _jammer setVariable [QGVAR(mark_area), _markArea];
// _jammer setVariable [QGVAR(mark_pos), _markPos];
