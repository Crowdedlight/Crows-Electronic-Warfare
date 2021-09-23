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

{
	_x params ["_minFreq", "_maxFreq"];
	// if within the limits we add to array
	if (_freq >= _minFreq && _freq <= _maxFreq) then {
		_antenna pushBack (_forEachIndex +1); // 0 indexed
	};

} forEach GVAR(spectrumDeviceFrequencyRange);

_antenna
