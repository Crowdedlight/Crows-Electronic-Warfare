#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_removeSoundZeus.sqf
Parameters: pos, unit
Return: none

Zeus dialog to remove the last-added sound to object

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

// if object is null, exit 
if (isNull _unit) exitWith {hint localize "STR_CROWSEW_Zeus_remove_sound_error"};

// broadcast
[QEGVAR(sounds,removeSound), [_unit]] call CBA_fnc_serverEvent;
