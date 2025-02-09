#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_initDroneSignals.sqf
Parameters: _unit
Return: none

Called upon event, adds the jammer to local gvar array and starts while loop, if it isn't running

SERVER ONLY

*///////////////////////////////////////////////
params [["_unit", objNull]];

// only add if server - To make sure its only added once
if (!isServer || isNull _unit) exitWith {};

// check if it already has a signal source, we won't add on top of other signals for now
if (GVAR(beacons) findIf { _x#0 == _unit } > -1) exitWith {};

// randomize frequency 
// TODO randomize within a window that gives minimum seperation to existing signals. 
private _range = abs((GVAR(spectrumDeviceFrequencyRange)#2)#0 - (GVAR(spectrumDeviceFrequencyRange)#2)#1);
private _freq = 433.00 + (random _range);

// get signal range from CBA settings
private _signalRange = 300;
private _defaultRanges = [GVAR(defaultRangesForJammingSignal) trim [" ,", 0], ","] call CBA_fnc_split;
{
	if (_unit isKindOf _x) then {
		if (count _defaultRanges < _forEachIndex+1) then {
				diag_log format ["CrowsEW:fnc_initDroneSignals.sqf: '%1' is %2 elements long. You tried to access index %3. Range will use fallback value.", QGVAR(defaultRangesForJammingSignal), count _defaultRanges, _forEachIndex]; 
		};
		_signalRange = parseNumber (trim (_defaultRanges#_forEachIndex));
	};
} forEach ([GVAR(defaultClassForJammingSignal), ","] call CBA_fnc_split);

// add beacon
[_unit, _freq, _signalRange, "drone"] call FUNC(addBeaconServer);

// set empty array on unit var where the players currently jamming is listed 
_unit setVariable [QGVAR(activeJammingObjects), []];
