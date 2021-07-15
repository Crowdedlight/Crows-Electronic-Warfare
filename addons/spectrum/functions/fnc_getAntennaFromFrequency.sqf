#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_getAntennaFromFrequency.sqf
Parameters: frequency
Return: none

Returns what antenna should be used to see the frequency

*///////////////////////////////////////////////
params ["_freq"];

private _antenna = -1;
switch (true) do {
	// 78 - 89 MHz - changing to 30 - 389 mhz, for TFAR frequencie ranges
	case (_freq >= 30 && _freq <= 389): {
		_antenna = 1;
	};

	// 390 - 500 MHz - Zeus signal range, or high TFAR channels 
	case (_freq >= 390 && _freq <= 500): {
		_antenna = 2;
	};

	// 433 MHz - UVG jamming antenna 
	case (_freq >= 433 && _freq <= 434): {
		_antenna = 3;
	};
};
_antenna
