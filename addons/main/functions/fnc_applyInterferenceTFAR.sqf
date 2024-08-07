#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_applyInterferenceTFAR.sqf
Parameters: _distJammer, _radFalloff, _radEffective
Return: 

Apply interference to TFAR radios

*///////////////////////////////////////////////

params ["_distJammer", "_radFalloff", "_radEffective"];

// if their signal is boosted, we don't decrease it, as then they are under satcom boosting
private _currentEffect = player getVariable ["tf_sendingDistanceMultiplicator", 1];
if (_currentEffect > 1) exitWith {};

private _rxInterference = 1;
private _txInterference = 1;
private _distPercent = 1;

// TODO have to test what value jamming applies fully to TFAR. So I know what to apply linear to. Test with strongest TFAR SR and LR
// at ~50m apart: total jam: 10 for SR, LR still works, at 25 LR doesn't work. If only one side is jammed, LR get 400-500m range, which is fine. 

// if we are within effective radius, we are fully jammed, so set interference to value that fully jamms us
if (_distJammer < _radEffective) then {
	_rxInterference = 100;
	_txInterference = 1 / 20;
} else {
	// within FALLOFF, so find interference, linear between 1 and 41

	// dist - effective_radius = dist_to_jam_edge
	// dist_to_jam_edge / falloff_radius = percentage_into_falloff
	private _dist_to_effective_border = abs(_distJammer - _radEffective);
	_distPercent = _dist_to_effective_border / _radFalloff;

	// the _distPercent gives value of percent from current pos to "not-jammed". 
	//	100% == on edge of falloff radius => no jamming. 
	//	0% == on edge of effective radius => maks jamming
	//  So this is why the interpolation goes from 15 (jammed), to 1, (normal), instead of the other way around 
	_rxInterference = [20, 1, _distPercent] call BIS_fnc_lerp;		// recieving interference. above 1 to have any effect.
	_txInterference = 1 / _rxInterference;							// transmitting interference, below 1 to have any effect.
};

// Set the TF receiving and sending distance multipliers
player setVariable ["tf_receivingDistanceMultiplicator", _rxInterference];
player setVariable ["tf_sendingDistanceMultiplicator", _txInterference];

//Debugging
#ifdef DEBUG
	systemChat format ["Distance: %1, Percent: %2", _distJammer,  100 * _distPercent];
	systemChat format ["tfar_rx: %1, tfar_tx: %2", _rxInterference, _txInterference];
#endif
