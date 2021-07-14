#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_spectrumDeviceMouseDown.sqf
Parameters: 
Return: 

Called on event for mouseDown

*///////////////////////////////////////////////
params ["_displayorcontrol", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];

// check if left mouse-down 
// if (_button == )
systemChat str(_button);
diag_log _button;
diag_log _displayorcontrol;

// check if current weapon is hgun_esd
if (!("hgun_esd_" in (handgunWeapon player))) exitWith {}; 

// mouse down, set firing as active
missionNamespace setVariable ["#EM_Transmit",true];

// get selected frequency 
private _selectedFreqMin = 	missionNamespace getVariable["#EM_SelMin",-1];
private _selectedFreqMax = 	missionNamespace getVariable["#EM_SelMax",-1];

diag_log _selectedFreqMin;
diag_log _selectedFreqMax;

// find all current frequencies within the range

// if type radiochatter, get random selection of voice clip, and play it. 

// spawn function that increments progress over same time interval as dureation of voice clip
// save handle for premature stop 




// TODO mouseUp - Just cancel any spawned script, reset progress and fire variable and stop sound playing, if possible