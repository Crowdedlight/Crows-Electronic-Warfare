#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_spectrumDeviceMouseUp.sqf
Parameters: 
Return: 

Called on event for mouseUp

*///////////////////////////////////////////////
params ["_displayorcontrol", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];

// check if left mouse-down 
if (_button != 0) exitWith {};

// check if current weapon is hgun_esd
if (!("hgun_esd_" in (currentWeapon player))) exitWith {}; 

// use gvar to save the current selected frequency. So we can do different behaviour depending on type. (for future ugv jamming)
deleteVehicle GVAR(radioChatterVoiceSound);
terminate GVAR(radioChatterProgressHandle);

// mouse down, set firing as active
missionNamespace setVariable ["#EM_Transmit",false];
missionNamespace setVariable ["#EM_Progress",0];
