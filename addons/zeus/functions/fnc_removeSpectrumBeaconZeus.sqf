#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_removeSpectrumBeaconZeus.sqf
Parameters: pos, _unit
Return: none

Delete signal source from object

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

// if object is null, exit 
if (isNull _unit) exitWith {hint localize "STR_CROWSEW_Zeus_remove_signal_error"};

// broadcast event to remove all signals, so each player remove from hashmap
[QEGVAR(spectrum,removeBeacon), [_unit]] call CBA_fnc_serverEvent;