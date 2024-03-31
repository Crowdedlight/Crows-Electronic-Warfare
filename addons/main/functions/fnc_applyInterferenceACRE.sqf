#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_applyInterferenceACRE.sqf
Parameters: _distJammer, _distRad, _jamStrength
Return: 

Apply interference to TFAR radios

*///////////////////////////////////////////////

params[_distJammer, _distRad, _jamStrength];

// If ACRE loaded, we return calculation for TFAR
private _distPercent = _distJammer / _distRad;

private _rxInterference = 1;
private _txInterference = 1;

// for now staying with linear degradation of signal. Might make it a tad better for players than the sudden commms -> no comms exponential could induce
private _rxInterference = _jamStrength - (_distPercent * _jamStrength) + 1; // recieving interference. below 1 to have any interference effect.
private _txInterference = _rxInterference;                                  // transmitting interference, below 1 to have any interference effect.

// Set the ACRE receiving and sending distance multipliers
player setVariable ["acre_receive_power", _rxInterference, true];
player setVariable ["acre_transmit_power", _txInterference, true];

//Debugging
#if 0
	systemChat format ["Distance: %1, Percent: %2", _distJammer,  100 * _distPercent];
	systemChat format ["tfar_rx: %1, tfar_tx: %2", _rxInterference, _txInterference];
#endif