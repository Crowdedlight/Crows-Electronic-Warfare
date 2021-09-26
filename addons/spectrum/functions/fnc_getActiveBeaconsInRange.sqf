#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_getActiveBeaconsInRange.sqf
Parameters: min freq, max freq
Return: none

returns array of signals within the interval given

*///////////////////////////////////////////////
params ["_minFreq", "_maxFreq"];

private _arr = [];

// _x == [_unit, _frequency, _scanRange, _type]
{
	private _freq = _x select 1; 
	// check if within range
	if (_freq <= _maxFreq && _freq >= _minFreq) then {

		// if we have jammer antenna on, only make "fire" events work with drone signals, even if we got other in same frequency band
		if (GVAR(spectrumRangeAntenna) == 3 && (_x select 3) != "drone") then { continue; };

		_arr pushBack _x;
	}
} forEach GVAR(beacons);
_arr
