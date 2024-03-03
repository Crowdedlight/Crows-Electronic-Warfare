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

// split string into array based on ","
private _classnames = [_value, ","] call CBA_fnc_split;

// register eventhandler for drones. Require Mission restart if classes are removed from the list, as I can not remove past applied class EHs. 
{
	[_x, "initPost", {[_this#0] call EFUNC(spectrum,initDroneSignals);}] call CBA_fnc_addClassEventHandler;
} forEach _classnames;
