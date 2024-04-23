#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_requestJammers.sqf
Parameters: 
Return: none

SERVER ONLY
Called upon request event from a client to get current state of truth for jammers

*///////////////////////////////////////////////
params ["_source"];

// if object is null, exitwith. Can happen if we get event as JIP but object has been removed
if (isNull _source || !isServer) exitWith {};

[QGVAR(updateJammers), [GVAR(jamMap)], _source] call CBA_fnc_targetEvent;
