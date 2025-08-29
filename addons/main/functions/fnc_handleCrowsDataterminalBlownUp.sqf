#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight and b-mayr-1984 - Bernhard Mayr

File: fnc_handleCrowsDataterminalBlownUp.sqf
Parameters: _target   that was blown up
Return: none

This function is called as an event handler when a `Crows_dataterminal` is blown up.
It is necessary to handle locality issues.

*///////////////////////////////////////////////
params [["_target", objNull]];


if !(_terminal isKindOf "Crows_dataterminal") exitWith {
	diag_log format ["CrowsEW:fnc_handleCrowsDataterminalBlownUp.sqf: '%1' is not of type 'Crows_dataterminal'.", _target]; 
};

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
