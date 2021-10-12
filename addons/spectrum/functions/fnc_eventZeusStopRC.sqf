#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_eventZeusStopRC.sqf
Parameters: unit
Return: 

fires when zeus stops RC an unit. Used for TFAR tracking

*///////////////////////////////////////////////
params ["_unit"];

// if tfar tracking is disabled, exit
if (!GVAR(radioTrackingEnabled)) exitWith {};

[QGVAR(radioTrackingBroadcastLocal), "OnTangent", _unit] call TFAR_fnc_removeEventHandler;
[QGVAR(removeBeacon), [_unit]] call CBA_fnc_globalEvent;
