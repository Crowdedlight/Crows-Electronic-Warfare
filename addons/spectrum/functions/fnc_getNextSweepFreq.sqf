#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: b-mayr-1984 - Bernhard Mayr
			   
File: fnc_getNextSweepFreq.sqf
Parameters: _sweepStartFreq 		in MHz
			_sweepSpan				in MHz
			_sweepIncrementSpeed	dimensionless factor
			_seed					integer (used to show multiple sweepers)

Return: next frequency in a frequency sweep as a Number

Script is primarily used to have an omni-directional C-UAS jammer 
show up as a destinct shape in the Spectrum Device.

*///////////////////////////////////////////////

params [["_sweepStartFreq", 433 	/* in MHz */], 
		["_sweepSpan", 7 			/* in MHz */], 
		["_sweepIncrementSpeed", 5 	/* dimensionless factor */],
		["_seed", 1337				/* integer */]];

private _sweeperOffset = _seed random _sweepSpan;
private _sweepFreq = _sweepStartFreq + ((diag_tickTime + _sweeperOffset) * _sweepIncrementSpeed mod _sweepSpan);

_sweepFreq	// return value
