#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_actionJamToggle.sqf
Parameters: jammer
Return: none

toggle enable/disable jam on the radio tower. Action option

*///////////////////////////////////////////////
params ["_target", "_caller", "_actionId", "_arguments"];
_arguments params ["_netId"];

// get current value
private _jammer = GVAR(jamMap) get _netId;
private _enabled = _jammer select 3;
private _jamObj = _jammer select 0;

// if dataterminal do animation. Is global so can just be done on player triggering as server doesn't need to sync or handle that
if (typeof _jamObj == "Land_DataTerminal_01_F") then {
	
	// if enabled == true, then we are closing the jammer, so do close animation, otherwise do open
	if (_enabled) then {
		[getPosASL _jamObj, 50, "crowsEW_mechanical_turn_off", 3] call EFUNC(sounds,playSoundPos);
		[_jamObj,0] call BIS_fnc_dataTerminalAnimate;
	} else {
		// play sound and start open animation
		[getPosASL _jamObj, 50, "crowsEW_jam_start", 3] call EFUNC(sounds,playSoundPos);
		[_jamObj,3] call BIS_fnc_dataTerminalAnimate;
	};
};

// set sound enabled - params ["_unit", "_enabled"];
[QEGVAR(sounds,setSoundEnable), [_jamObj, !_enabled]] call CBA_fnc_serverEvent;

// broadcast event to set the jammer with this key as disabled/enabled
[QGVAR(toggleJammer), [_netId, !_enabled]] call CBA_fnc_serverEvent;