#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_initTriggerEMP.sqf
Parameters: _unit
Return: none

set the actions if ace is loaded for setting trigger

*///////////////////////////////////////////////
params ["_unit"];

// diag_log "DEBUG - INIT ACE INTERACTION";

// only if we got ace loaded
if (!EGVAR(zeus,hasAce)) exitWith {};

// _unit setVariable ["ace_explosives_class", "emp_device_mag", true]; 
// _unit setVariable ["ace_explosives_Direction", getDir _unit, true];

// private _action = ["ACE_SetTrigger","Select a Trigger","\z\ace\addons\explosives\UI\Explosives_Menu_ca.paa",{},{true},{[_target getVariable "ace_explosives_class", _target, _player] call ace_explosives_fnc_addTriggerActions;},[], [0,0,0], 2] call ace_interact_menu_fnc_createAction; 
// [_unit, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;



// _this setVariable ["ace_explosives_class", "Crows_Emp_Device", true]; 
// _this setVariable ["ace_explosives_Direction", getDir _this, true];

// private _action = ["ACE_SetTrigger","Select a Trigger","",{nil},{true},{[_target getVariable "ace_explosives_class", _target, _player] call ace_explosives_fnc_addTriggerActions;},[], [0,0,0], 100] call ace_interact_menu_fnc_createAction; 
// [_this, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;



 // use init function to register ACE actions. (base-game when ace is not loaded)
 // show option to select trigger only when either one of the two ACE clackers are in inventory
 // Selecting a trigger => changing action on object to "remove trigger", Add action to player under explosives as "detonate EMP". Set var on object as trigger is linked, remove option for other players to select trigger
 // triggering "detonate EMP", fire EMP, remove actions on device and player to avoid multiple detonations. Set damage on object
 // "remove trigger" function: set var to allow people to set trigger on it again. Remove detonate action from player
