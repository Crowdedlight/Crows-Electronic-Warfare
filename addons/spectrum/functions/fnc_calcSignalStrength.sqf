#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_calcSignalStrength.sqf
Parameters: target, tracker, scanRange
Return: signalStrength

Calculates the total signal strength based on direction and distance between target and tracker

*///////////////////////////////////////////////

params [["_target",objNull,[objNull]], ["_tracker",objNull,[objNull]], ["_scanRange",300, [0]]];

if (isNull _tracker || isNull _target) exitWith {};

// calculate direction
private _dirTargetFromTracker = _tracker getDir _target;
private _trackerFacingDir = direction _tracker;
// get positive value of direction difference
private _dirDiff = abs (_dirTargetFromTracker - _trackerFacingDir);    

// check if dirDiff is above or below 180deg as it overflows from 0 to 360
if (_dirDiff > 180) then {
	_dirDiff = 360 - _dirDiff;
};

// calculate strength based on distance
private _distance = _tracker distance _target;

// distance strength. 50 is max value when at 0 distance
private _distStrength = round((50 / _scanRange) * (_scanRange - _distance));

// direction strength, 150 is max value when looking straight at it
// private _dirStrength = abs round((150 / 180) * (180 - _dirDiff));
private _dirStrength = round((0 max (150 - _dirDiff * 1.5)));

// sig strength is max signal, 100, subtracted half the combined strength of dist and dir strength
private _sigStrength = (100 - ((_distStrength + _dirStrength) / 2)) * (-1);
_sigStrength




// private _dirTargetFromTracker =  0
// private _trackerFacingDir = 30
// private _dirDiff = 30;    

// // 
// private _dirStrength = abs round((150 / 180) * (180 - 30));
// private _dirStrength = round((0 max (150 - _dirDiff * 1.5)));

// private _sigStrength = (100 - ((_distStrength + _dirStrength) / 2)) * (-1);