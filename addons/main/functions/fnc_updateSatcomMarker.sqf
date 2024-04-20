#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_updateSatcomMarker.sqf
Parameters: _obj, _updating
Return: none

updates local markers

*///////////////////////////////////////////////
params ["_obj", "_netId", "_radius", "_updating"];

private _marker = _netId;

// delete existing marker, unless we are creating them first time
if (_updating) then {
	_marker setMarkerPosLocal _obj;
} else {
	_marker = createMarkerLocal [_marker, position _obj];
	_marker setMarkerDrawPriority 2; // Setting as higher priority to be drawn on top of my other jammer markers. This help remove the "blinking" behaviour when two markers of same priority draw on top of eachother every second draw. 
	_marker setMarkerTypeLocal "";
	_marker setMarkerShapeLocal "ELLIPSE";
	_marker setMarkerSizeLocal [_radius, _radius];
	_marker setMarkerAlphaLocal 0.2;
	_marker setMarkerColorLocal "ColorBlue";	
};