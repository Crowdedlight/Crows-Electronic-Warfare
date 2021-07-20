#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_toggleJammingOnUnit.sqf
Parameters: _unit, _enableJam
Return: none

Called upon event to jam or unjam unit

*///////////////////////////////////////////////
params [["_unit", objNull], ["_enableJam", false]];

systemChat "received jamtoggle event";
diag_log "received jamtoggle event";

diag_log _unit;

// only if we are local to unit 
if (!(local _unit)) exitWith {};

if (_enableJam) then {
	// disable all AI in vic (Has both driver and turret) and we get given only one of them
	{
		_x disableAI "all";
	} forEach (crew _unit);
	systemChat "disabled all AI";
} else {
	// enable all AI 
	{
		_x enableAI "all";
	} forEach (crew _unit);
	systemChat "enabled all AI";
};
