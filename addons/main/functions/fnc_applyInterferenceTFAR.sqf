#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_applyInterferenceTFAR.sqf
Parameters: _distJammer, _distRad, _jamStrength
Return: 

Apply interference to TFAR radios

*///////////////////////////////////////////////

params[_distJammer, _distRad, _jamStrength];

// If TFAR loaded, we return calculation for TFAR
private _distPercent = _distJammer / _distRad;

private _rxInterference = 1;
private _txInterference = 1;

// for now staying with linear degradation of signal. Might make it a tad better for players than the sudden commms -> no comms exponential could induce
private _rxInterference = _jamStrength - (_distPercent * _jamStrength) + 1;     // recieving interference. above 1 to have any effect.
private _txInterference = 1 / _rxInterference;                                  // transmitting interference, below 1 to have any effect.

// Set the TF receiving and sending distance multipliers
player setVariable ["tf_receivingDistanceMultiplicator", _rxInterference];
player setVariable ["tf_sendingDistanceMultiplicator", _txInterference];

//Debugging
#if 0
	systemChat format ["Distance: %1, Percent: %2", _distJammer,  100 * _distPercent];
	systemChat format ["tfar_rx: %1, tfar_tx: %2", _rxInterference, _txInterference];
#endif