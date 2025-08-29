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
		// if blown up with explosive. Don't remove the object, just disable it by killing it and turn it red. (don't have a destroyed texture)
		_target setDamage [1, true, _instigator];
		[_target, 1] call BIS_fnc_dataTerminalAnimate;	// show lid open but antenna lowered and closed
		[_target, "red", "red", "red"] call BIS_fnc_dataTerminalColor;	// make edges of data terminal red
		_target setObjectTextureGlobal [0, QPATHTOF(data\data_terminal_screen_dead_CO.paa)];	// show screen with a malfunction
		_target setObjectMaterialGlobal [0, "\A3\Props_F_Exp_A\Military\Equipment\Data\DataTerminal_green.rvmat"];	

		// burry into the ground to some extent
		private _target_pos = getPosATL _target;
		if (_target_pos#2 < 0.1) then { // if terminal sits on the ground (or very near to it)
			_target setPosATL [_target_pos#0, _target_pos#1, _target_pos#2 - 0.2];	// sink terminal into the ground
			_target setVectorDirAndUp ([[vectorDirVisual _target, vectorUpVisual _target], getDir _target, -30, 10] call BIS_fnc_transformVectorDirAndUp);	// roll and pitch a bit	
		};
	};
}];
