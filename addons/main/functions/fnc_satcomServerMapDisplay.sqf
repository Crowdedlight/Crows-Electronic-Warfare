#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_satcomServerMapDisplay.sqf
Parameters: 
Return: none

Runs the server-side loop handling satcom boosting

*///////////////////////////////////////////////

// called every 0.1s, 
private _list = missionNamespace getVariable[QGVAR(satcomActiveList), []];

if (count _list == 0) exitWith {};

// loop through all current active objects to update map-markers
{
	_y params["_emitter", "_radius"];
	// jamObj, netId, radius
	[_emitter, _x, _radius, true] call FUNC(updateSatcomMarker);
} forEach _list;
