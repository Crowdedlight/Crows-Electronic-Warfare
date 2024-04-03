#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_updateJamMarker.sqf
Parameters: _jammer, _updating
Return: none

updates local marker for the jammer to show on map. Only called for zeus, so only zeus can see the jammer radius

*///////////////////////////////////////////////
params ["_jammer", "_netId", "_radFalloff", "_radEffective", "_updating", "_enabled"];

// delete existing marker, unless we are creating them first time
if (_updating) then {
	deletemarkerLocal _netID;
	deletemarkerLocal (_netID + "_effective");
};

// falloff + effective marker, shows the entire marker
private _netID = createMarkerLocal [_netID, position _jammer];
_netID setMarkerShapeLocal "ELLIPSE";
_netID setMarkerSizeLocal [_radFalloff + _radEffective, _radFalloff + _radEffective];
_netID setMarkerAlphaLocal 0.5;
if (_enabled) then {
	_netID setMarkerColorLocal "ColorYellow";	// allow Zeus to distinguish which jammer is turned on or off
};

// effective marker, shows where jamming will be 100%
private _netID_effective = createMarkerLocal [_netID + "_effective", position _jammer];
_netID_effective setMarkerShapeLocal "ELLIPSE";
_netID_effective setMarkerSizeLocal [_radEffective, _radEffective];
_netID_effective setMarkerAlphaLocal 0.3;
_netID_effective setMarkerColorLocal "ColorRed";
