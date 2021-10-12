#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_eventZeusStartRC.sqf
Parameters: unit
Return: 

fires when zeus start to RC an unit. Used for TFAR tracking

*///////////////////////////////////////////////
params ["_unit"];

// if tfar tracking is disabled, exit
if (!GVAR(radioTrackingEnabled)) exitWith {};

// set EH
[QGVAR(radioTrackingBroadcastLocal), "OnTangent", FUNC(radioTrackingBroadcastLocal), _unit] call TFAR_fnc_addEventHandler;
