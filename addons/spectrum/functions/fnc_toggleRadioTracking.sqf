#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_toggleRadioTracking.sqf
Parameters: boolean _enable
Return: 

Called by event listener to activate or deactivate the event handler for TFAR event tracking
This is run for all players

*///////////////////////////////////////////////
params ["_enabled"];

// if enabled, add eventlistener
if (_enabled) then {
	// add eventhandler to radio transmission
	[QGVAR(radioTrackingBroadcastLocal), "OnTangent", FUNC(radioTrackingBroadcastLocal), player] call TFAR_fnc_addEventHandler;
} else {
	// if disabled, remove eventhandler 
	[QGVAR(radioTrackingBroadcastLocal), "OnTangent", player] call TFAR_fnc_removeEventHandler;
	// remove existing signals from unit 
	[QGVAR(removeBeacon), [player]] call CBA_fnc_globalEvent;
};

// save state for zeus module
GVAR(radioTrackingEnabled) = _enabled;

// TODO, if disabled, it should remove all current TFAR signals only. Although due to spawned function that cleans up, this should happen automatically.... requires testing


