#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight and b-mayr-1984 - Bernhard Mayr

File: fnc_initCrowsDataterminal.sqf
Parameters: _entity   that was initialized
Return: none

This function is called as an event handler for the "init" event.
It only deals with "init" events of objects that are of type `Crows_dataterminal`.

It's job is to register a "HitPart" event handler to enable destruction of the terminal.

*///////////////////////////////////////////////
params [["_entity", objNull]];


if !(_entity isKindOf "Crows_dataterminal") exitWith {
	diag_log format ["CrowsEW:fnc_initCrowsDataterminal.sqf: '%1' is not of type 'Crows_dataterminal'.", _entity]; 
};

// Add eventhandler for data terminals on all clients as they run locally
_entity addEventHandler ["HitPart", {
	(_this select 0) params ["_target", "_shooter", "_projectile", "_position", "_velocity", "_selection", "_ammo", "_vector", "_radius", "_surfaceType", "_isDirect", "_instigator"];
	_ammo params ["_hitVal", "_inHitVal", "_inHitRange", "_explosiveDmg", "_ammoClassName"];

	// if over 0.5 in damage, so all explosives and even grenades if they are right next to it
	if (_explosiveDmg > 0.5) then {
		[QGVAR(dataTerminalBlownupEvent), [_target], _target] call CBA_fnc_targetEvent;
	};
}];
