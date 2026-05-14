#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: b-mayr-1984 - Bernhard Mayr 

File: fnc_spectrumDeviceKeyUp.sqf
Parameters: as per https://community.bistudio.com/wiki/User_Interface_Event_Handlers#onKeyUp
Return: false 	to not consume the key press event

Called on event for key released

*///////////////////////////////////////////////
params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];

if (_shift) then {
	GVAR(spectrumShiftKeyDown) = false;	// set variable that shift key is down, used for zooming functions
};

if (_ctrl) then {
	GVAR(spectrumCtrlKeyDown) = false;	// set variable that ctrl key is down, used for zooming functions
};

false // don't consume the key press event
