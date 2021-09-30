#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_initDroneSignals.sqf
Parameters: _unit
Return: none

Called upon event, adds the jammer to local gvar array and starts while loop, if it isn't running

*///////////////////////////////////////////////
params [["_unit", objNull]];

// add event for disabling AI, as this needs to happen where the unit is local, so we add to all
private _aiDisable = [QGVAR(toggleAI), FUNC(toggleAI)] call CBA_fnc_addEventHandler;

// only add if server - To make sure its only added once
if (!isServer || isNull _unit) exitWith {};

// add eventhandler for all clients, as the function ensures only to apply it where its local, which targetEvent should anyway 
private _jamToggle = [QGVAR(toggleJammingOnUnit), FUNC(toggleJammingOnUnit)] call CBA_fnc_addEventHandler;

// randomize frequency 
private _freq = 433.00 + (random 7);

[QGVAR(addBeacon), [_unit, _freq, 300, "drone"]] call CBA_fnc_globalEventJIP;

// set empty array on unit var where the players currently jamming is listed 
_unit setVariable [QGVAR(activeJammingPlayers), []];
