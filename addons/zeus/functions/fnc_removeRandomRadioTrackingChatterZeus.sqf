#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_removeRandomRadioTrackingChatterZeus.sqf
Parameters: pos, _unit
Return: none

Delete signal source from object

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

// if object is null, exit 
if (isNull _unit) exitWith {hint "You have to select a unit to remove chatter from"};

// broadcast event to remove jammer, so each player remove from hashmap
[QEGVAR(spectrum,removeRandomRadioTrackingChatter), [_unit]] call CBA_fnc_serverEvent;