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
private _dirTargetFromTracker =  (getPos _tracker) vectorFromTo (getPos _target);
private _trackerFacingDir = _tracker weaponDirection (currentWeapon _tracker);

// get positive value of direction difference
private _dirDiff = vectorMagnitude (_trackerFacingDir vectorDiff _dirTargetFromTracker);    // returns values between 0 and 2 (when input vectors are normalized, such as here)

// calculate strength based on distance
private _distance = _tracker distance _target;

// distance strength. 0 is outside range, 1 is right next to the signal
private _distStrength = linearConversion [0, _scanRange, _distance, 1, 0, true];

// direction strength, 1 is max value when looking straight at it. Keeping backlope effect by capping at 0.1, with 0.9 max. 
private _dirStrength = [1, 0.15, _dirDiff/2] call BIS_fnc_easeOut; // BIS_fnc_easeOut is an interpolation that changes quickly at first and then flattens
// for a selection of other interpolation functions (e.g. progressive or degressive curves) visit:
// https://community.bistudio.com/wiki/Category:Function_Group:_Interpolation

// Max signal is 0, lowest signal is -100, as given in dBm. Strength and Direction is given as contributing factors between 0 and 1 each
private _sigStrength = -100 + (100 * _distStrength * _dirStrength);

// systemChat format ["Sig strength: %1, dist_factor: %2, dir_factor: %3, _distance: %4, _dirdiff: %5", _sigStrength, _distStrength, _dirStrength, _distance, _dirDiff];

_sigStrength