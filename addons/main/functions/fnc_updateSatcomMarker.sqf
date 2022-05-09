#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_updateSatcomMarker.sqf
Parameters: _obj, _updating
Return: none

updates local markers

*///////////////////////////////////////////////
params ["_obj", "_netId", "_radius", "_updating"];

// delete existing marker, unless we are creating them first time
if (_updating) then {
	deletemarkerLocal _netID;
};

_netID = createMarkerLocal [_netID, position _obj];
_netID setMarkerShapeLocal "ELLIPSE";
_netID setMarkerSizeLocal [_radius, _radius];
_netID setMarkerAlphaLocal 0.2;
_netID setMarkerColorLocal "ColorBlue";
