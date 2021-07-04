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
	// 78 - 89 MHz - consider changing to 60 - 250 mhz, for TFAR frequencie ranges
	case (_freq >= 60 && _freq <= 250): {
		_antenna = 1;
	};

	// 390 - 500 MHz
	case (_freq >= 390 && _freq <= 500): {
		_antenna = 2;
	};

	// 433 MHz - UVG jamming antenna 
	case (_freq >= 433 && _freq <= 434): {
		_antenna = 3;
	};
};
_antenna
