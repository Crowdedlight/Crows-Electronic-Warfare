#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_getSpectrumDefaultFreq.sqf
Parameters: antenna
Return: minfreq, maxfreq, antennaNumber

returns the default min and max freq for the given antenna

*///////////////////////////////////////////////
params ["_antenna"];

private _minFreq = 0;
private _maxFreq = 0;
private _antennaSelected = 0;

switch (_antenna) do {
	// 78 - 89 MHz - consider changing to 30 - 389 mhz, for TFAR frequencie ranges
	case "muzzle_antenna_01_f": {
		_antennaSelected = 1;
		_minFreq = (GVAR(spectrumDeviceFrequencyRange) select 0) select 0;
		_maxFreq = (GVAR(spectrumDeviceFrequencyRange) select 0) select 1;
	};
	// 390 - 500 MHz
	case "muzzle_antenna_02_f": {
		_antennaSelected = 2;
		_minFreq = (GVAR(spectrumDeviceFrequencyRange) select 1) select 0;
		_maxFreq = (GVAR(spectrumDeviceFrequencyRange) select 1) select 1;
	};
	// 433 MHz - UVG jamming antenna 
	case "muzzle_antenna_03_f": {
		_antennaSelected = 3;
		_minFreq = (GVAR(spectrumDeviceFrequencyRange) select 2) select 0;
		_maxFreq = (GVAR(spectrumDeviceFrequencyRange) select 2) select 1;
	};
	default {
		_antennaSelected = -1;
	};
};

// return
[_minFreq, _maxFreq, _antennaSelected]
