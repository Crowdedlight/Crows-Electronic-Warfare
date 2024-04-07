#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_updateJamMarker.sqf
Parameters: _jammer, _updating
Return: none

updates local marker for the jammer to show on map. Only called for zeus, so only zeus can see the jammer radius

*///////////////////////////////////////////////
params ["_jammer", "_netID", "_radFalloff", "_radEffective", "_updating", "_enabled"];

// delete existing marker, unless we are creating them first time
if (_updating) then {
	deletemarkerLocal _netID;
	deletemarkerLocal (_netID + "_effective");
};

// falloff + effective marker, shows the entire marker
private _falloff = createMarkerLocal [_netID, position _jammer];
_falloff setMarkerShapeLocal "ELLIPSE";
_falloff setMarkerSizeLocal [_radFalloff + _radEffective, _radFalloff + _radEffective];
_falloff setMarkerAlphaLocal 0.5;

// effective marker, shows where jamming will be 100%
private _effective = createMarkerLocal [_netID + "_effective", position _jammer];
_effective setMarkerShapeLocal "ELLIPSE";
_effective setMarkerSizeLocal [_radEffective, _radEffective];
_effective setMarkerAlphaLocal 0.3;
_effective setMarkerColorLocal "ColorBlack";

// handle difference between active and inactive jammers
if (_enabled) then {
	_falloff setMarkerColorLocal "ColorYellow";	// allow Zeus to distinguish which jammer is turned on or off
	_effective setMarkerColorLocal "ColorRed";
};