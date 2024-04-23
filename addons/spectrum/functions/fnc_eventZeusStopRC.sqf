#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_eventZeusStopRC.sqf
Parameters: unit
Return: 

fires when zeus stops RC an unit. Used for TFAR tracking

*///////////////////////////////////////////////
params ["_unit"];

// set original player as tracker, for zeus RC spectrum tracking support
GVAR(trackerUnit) = player;

// if tfar tracking is disabled, exit
if (!GVAR(radioTrackingEnabled)) exitWith {};

[QGVAR(radioTrackingBroadcastLocal), "OnTangent", _unit] call TFAR_fnc_removeEventHandler;
[QGVAR(removeBeacon), [_unit]] call CBA_fnc_serverEvent;

// reset eventhandler for player, as it gets removed when you RC 
[QGVAR(radioTrackingBroadcastLocal), "OnTangent", FUNC(radioTrackingBroadcastLocal), player] call TFAR_fnc_addEventHandler;
