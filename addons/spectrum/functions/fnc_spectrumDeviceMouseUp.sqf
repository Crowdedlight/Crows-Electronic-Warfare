#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_spectrumDeviceMouseUp.sqf
Parameters: 
Return: 

Called on event for mouseUp

*///////////////////////////////////////////////
params ["_displayorcontrol", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];

// check if left mouse-down, also check if unit is dead, as we need it to reset mouseDown if we die while mouseDown
if (_button != 0) exitWith {};

// if jamming unit is not null, then we have been jamming, so reset AI and var. This should also fire on mouse-down if we have been jamming and changed weapon. 
//  jamming script should catch it anyway, but better to be sure AI gets re-enabled
if (!isNull GVAR(isJammingDrone)) then {
	// systemChat "Jamming deactivated";
	[QGVAR(toggleJammingOnUnit), [GVAR(isJammingDrone), false, player]] call CBA_fnc_serverEvent;
	GVAR(isJammingDrone) = objNull;
};

// check if current weapon is hgun_esd
if (!("hgun_esd_" in (currentWeapon player))) exitWith {}; 

// use gvar to save the current selected frequency. So we can do different behaviour depending on type. (for future ugv jamming)
deleteVehicle GVAR(radioChatterVoiceSound);
terminate GVAR(radioChatterProgressHandle);

// mouse up, set firing as inactive
missionNamespace setVariable ["#EM_Transmit",false];
missionNamespace setVariable ["#EM_Progress",0];

