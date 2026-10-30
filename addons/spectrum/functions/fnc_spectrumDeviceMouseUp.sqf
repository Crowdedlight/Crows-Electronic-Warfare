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

// check if listening to radio
if (GVAR(listeningToIcom)) then {
	call FUNC(listenToRadioStop);
};

// check if current weapon is hgun_esd
if (!("hgun_esd_" in (currentWeapon player))) exitWith {}; 

// use gvar to save the current selected frequency. So we can do different behaviour depending on type. (for future ugv jamming)
{ stopSound _x; } forEach GVAR(currentPlayerLocalRadioSoundIds);
deleteVehicle GVAR(radioChatterVoiceSound);
terminate GVAR(radioChatterProgressHandle);

// mouse up, set firing as inactive
missionNamespace setVariable ["#EM_Transmit",false];
missionNamespace setVariable ["#EM_Progress",0];

// Fire local event to notify we are no longer listening to a signal
[QGVAR(deactivatedSpectrumDevice)] call CBA_fnc_localEvent;


// unregister for new sounds starting
[QGVAR(newRadioSoundStarted), GVAR(newRadioSoundStartedEHid)] call CBA_fnc_removeEventHandler;
GVAR(newRadioSoundStartedEHid) = -1;	// reset to invalid id
_unit = GVAR(currentPlayerLocalRadioEmitter);
private _listeners = _unit getVariable[QGVAR(currentRadioSoundListeners), []];
// remove our client from list of listeners
_listeners = _listeners - [clientOwner];
_unit setVariable[QGVAR(currentRadioSoundListeners), _listeners, true];
GVAR(currentPlayerLocalRadioEmitter) = objNull;
