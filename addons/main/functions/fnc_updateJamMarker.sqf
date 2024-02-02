#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_updateJamMarker.sqf
Parameters: _jammer, _updating
Return: none

updates local marker for the jammer to show on map. Only called for zeus, so only zeus can see the jammer radius

*///////////////////////////////////////////////
params ["_jammer", "_netId", "_radius", "_updating", "_enabled"];

// delete existing marker, unless we are creating them first time
if (_updating) then {
	deletemarkerLocal _netID;
};

_netID = createMarkerLocal [_netID, position _jammer];
_netID setMarkerShapeLocal "ELLIPSE";
_netID setMarkerSizeLocal [_radius, _radius];
_netID setMarkerAlphaLocal 0.5;
if (_enabled) then {
	_netID setMarkerColorLocal "ColorYellow";	// allow Zeus to distinguish which jammer is turned on or off
};
