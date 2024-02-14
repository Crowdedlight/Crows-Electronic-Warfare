#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_addSoundZeus.sqf
Parameters: pos, unit
Return: none

Zeus dialog to remove the last-added sound to object

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

// if object is null, exit 
if (isNull _unit) exitWith {hint "You have to select a unit to remove sound from"};

// broadcast
[QEGVAR(sounds,removeSound), [_unit]] call CBA_fnc_serverEvent;

// TODO: should this remove ALL added sounds?