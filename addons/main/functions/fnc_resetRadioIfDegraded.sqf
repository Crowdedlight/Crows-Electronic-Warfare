#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_resetRadioIfDegraded.sqf
Parameters: unit
Return: none

Resets any radio jamming applied to unit if its degraded 

*///////////////////////////////////////////////
params ["_unit"];

// TFAR handling, here we can have others boosting or influencing the TFAR vars, so we only reset if degraded 
if (EGVAR(zeus,hasTFAR)) then {
	// get current state of multipliers
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
} else {
	// if not TFAR loaded, then it must be ACRE
	_unit setVariable ["acre_receive_power", 1, true];
	_unit setVariable ["acre_transmit_power", 1, true];
};
