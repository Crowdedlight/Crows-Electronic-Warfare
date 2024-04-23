#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_applyInterferenceACRE.sqf
Parameters: _distJammer, _radFalloff, _radEffective
Return: 

Apply interference to ACRE radios

*///////////////////////////////////////////////

params["_distJammer", "_radFalloff", "_radEffective"];

// if their signal is boosted, we don't decrease it, as then they are under satcom boosting
private _currentEffect = player getVariable ["acre_receive_interference", 0];
if (_currentEffect < -1) exitWith {};

// If ACRE loaded, we return calculation for signal jamming
private _distPercent = _distJammer / _distRad;

private _rxInterference = 0;

// if we are within effective radius, we are fully jammed, so set interference to value that fully jamms us
if (_distJammer < _radEffective) then {
	_rxInterference = 200;
} else {
	// within FALLOFF, so find interference, linear between 0 and 140

	// dist - effective_radius = dist_to_jam_edge
	// dist_to_jam_edge / falloff_radius = percentage_into_falloff
	private _dist_to_effective_border = abs(_distJammer - _radEffective);
	_distPercent = _dist_to_effective_border / _radFalloff;

	// the _distPercent gives value of percent from current pos to "not-jammed". 
	//	100% == on edge of falloff radius => no jamming. 
	//	0% == on edge of effective radius => maks jamming
	//  So this is why the interpolation goes from high (jammed), to low, (normal), instead of the other way around 
	_rxInterference = [110, 0, _distPercent] call BIS_fnc_lerp;		
};

// not multiplier, but interference 0 == no interference, 140 == total jamming
player setVariable ["acre_receive_interference", _rxInterference];

//Debugging
#ifdef DEBUG
	systemChat format ["Distance: %1, Percent: %2", _distJammer,  100 * _distPercent];
	systemChat format ["acre_rx_interference: %1", _rxInterference];
#endif