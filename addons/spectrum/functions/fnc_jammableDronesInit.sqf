#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_jammableDronesInit.sqf
Parameters: setting value. String
Return: none

Called from CBA option of what drones or class names should have signals and be jammable by default

*///////////////////////////////////////////////

// get classnames from CBA option
params [["_value", "", [""]]];

// only apply on server, to avoid having it run once per client in game. 
if (!isServer) exitWith {};

// split string into array based on ","
private _classnames = [_value, ","] call CBA_fnc_split;

// register eventhandler for drones. Require Mission restart if classes are removed from the list, as I can not remove past applied class EHs. 
{
	// apply to inheritance and retroactively
	[_x, "initPost", FUNC(initDroneSignals), true, [], true] call CBA_fnc_addClassEventHandler;
} forEach _classnames;
