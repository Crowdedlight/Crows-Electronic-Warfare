#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_updateJamMarker.sqf
Parameters: _jammer, _updating
Return: none

updates local marker for the jammer to show on map. Only called for zeus, so only zeus can see the jammer radius

*///////////////////////////////////////////////
params ["_jammer", "_netID", "_radFalloff", "_radEffective", "_updating", "_enabled"];

private _marker_falloff = _netID;
private _marker_effective = _netID + "_effective";

// handle difference between active and inactive jammers
if (_enabled) then {
	_marker_falloff setMarkerColorLocal "ColorYellow";	// allow Zeus to distinguish which jammer is turned on or off
	_marker_effective setMarkerColorLocal "ColorRed";
};

// if updating then we just move the position
if (_updating) then {
	_marker_falloff setMarkerPosLocal _jammer;
	_marker_effective setMarkerPosLocal _jammer;
} else {

	// falloff + effective marker, shows the entire marker
	_marker_falloff = createMarkerLocal [_marker_falloff, position _jammer];
	_marker_falloff setMarkerDrawPriority -1;
	_marker_falloff setMarkerTypeLocal "";
	_marker_falloff setMarkerShapeLocal "ELLIPSE";
	_marker_falloff setMarkerSizeLocal [_radFalloff + _radEffective, _radFalloff + _radEffective];
	_marker_falloff setMarkerAlphaLocal 0.5;
	
	// effective marker, shows where jamming will be 100%
	_marker_effective = createMarkerLocal [_marker_effective, position _jammer];
	_marker_effective setMarkerDrawPriority -1;
	_marker_effective setMarkerTypeLocal "";
	_marker_effective setMarkerShapeLocal "ELLIPSE";
	_marker_effective setMarkerSizeLocal [_radEffective, _radEffective];
	_marker_effective setMarkerAlphaLocal 0.3;
	_marker_effective setMarkerColorLocal "ColorBlack";
};
