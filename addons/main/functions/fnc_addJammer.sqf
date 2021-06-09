#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_addJammer.sqf
Parameters: pos, _unit
Return: none

Called upon event, adds the jammer to local gvar array and starts while loop, if it isn't running

*///////////////////////////////////////////////
params ["_unit", "_rad", "_strength"];

// if object is null, exitwith. Can happen if we get event as JIP but object has been removed
if (_unit == objNull) exitWith {};

// else set jammer vars and add to local array