#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_getAntennaFromFrequency.sqf
Parameters: frequency
Return: none

Returns what antenna should be used to see the frequency

*///////////////////////////////////////////////
params ["_freq"];

private _antenna = [];
// using ifs instead of case as multiple cases can be true, which switch does not support

// 78 - 89 MHz - changing to 30 - 389 mhz, for TFAR frequencie ranges
if (_freq >= 30 && _freq <= 389) then {
	_antenna pushBack 1;
};

// 390 - 500 MHz - Zeus signal range, or high TFAR channels 
if (_freq >= 390 && _freq <= 500) then {
	_antenna pushBack 2;
};

// 433-440 MHz - UVG jamming antenna 
if (_freq >= 433 && _freq <= 440) then {
	_antenna pushBack 3;
};
_antenna
