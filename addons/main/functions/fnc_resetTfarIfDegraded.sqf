#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_actionJamToggle.sqf
Parameters: jammer
Return: none

toggle enable/disable jam on the radio tower. Action option

*///////////////////////////////////////////////
params ["_unit"];

// reset values of TFAR, if they are degraded
private _playerRX = _unit getVariable ["tf_receivingDistanceMultiplicator", 1];
private _playerTX = _unit getVariable ["tf_sendingDistanceMultiplicator", 1];

// rx degraded if above 1
if (_playerRX > 1) then {
	_unit setVariable ["tf_receivingDistanceMultiplicator", 1];
};
// tx degraded if below 1
if (_playerTX < 1) then {
	_unit setVariable ["tf_sendingDistanceMultiplicator", 1];
};
