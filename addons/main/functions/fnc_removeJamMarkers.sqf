#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_removeJamMarkers.sqf
Parameters: _netId
Return: none

removes local marker for the jammer to show on map. Only called for zeus, so only zeus can see the jammer radius

*///////////////////////////////////////////////
params ["_netIDs"];

{
	deleteMarkerLocal _x;
	deleteMarkerLocal (_x + "_effective");
} forEach _netIDs;
