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

// if the new value is equal to the already existing value we shouldn't update. Can happen if zeus hits "enabled" multiple times with module
if (_enabled == GVAR(radioTrackingEnabled)) exitWith {}; 

// if enabled, add eventlistener
if (_enabled) then {
	// add eventhandler to radio transmission
	[QGVAR(radioTrackingBroadcastLocal), "OnTangent", FUNC(radioTrackingBroadcastLocal), player] call TFAR_fnc_addEventHandler;
} else {
	// if disabled, remove eventhandler 
	[QGVAR(radioTrackingBroadcastLocal), "OnTangent", player] call TFAR_fnc_removeEventHandler;
	// remove existing signals from unit 
	[QGVAR(removeBeacon), [player]] call CBA_fnc_serverEvent;
};

// save state for zeus module
GVAR(radioTrackingEnabled) = _enabled;
