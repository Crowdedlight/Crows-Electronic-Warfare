#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_removeSatcomZeus.sqf
Parameters: pos, _unit
Return: none

remove jammer from object

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

// if object is null, exit 
if (isNull _unit) exitWith {hint localize "STR_CROWSEW_Zeus_remove_satcom_error"};

// broadcast event to remove jammer, so each player remove from hashmap
[QEGVAR(main,removeSatcom), [[netId _unit]]] call CBA_fnc_serverEvent;
