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
		_arr pushBack _x;
	}
} forEach GVAR(beacons);
_arr
