#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_spectrumTrackingLocal.sqf
Parameters: 
Return: 

Script being called by PFH to handle updates to the direction and signal of the tracking device 

*///////////////////////////////////////////////

// only calculate if there is any signals
if (count GVAR(beacons) == 0) exitWith {};

// only calculate if we got analyzer as player
if (!("hgun_esd_" in (handgunWeapon player))) exitWith {}; 

// update local array for deleted or dead elements
private _removeArr = [];
{
    // get target obj
    private _target = _x select 0;

    // if removed or dead, remove it from tracking array
    if (_target == objNull || !alive _target) then {
        _removeArr pushBack _x;
    };
} forEach GVAR(beacons);

// update list
GVAR(beacons) = GVAR(beacons) - _removeArr;


// for each beacon calculate direction, and strength based on distance. Range is hardcoded to 300m
// TODO SET SCANRANGE BASED ON VARIABLE, SO ZEUS CAN SET TRACKABLE RANGE FROM OBJECT
private _scanRange = 300;
private _sigsArray = [];
private _tracker = player;

{
	_x params ["_target", "_frequency"];

	// calculate direction
	private _dirTargetFromTracker = _tracker getDir _target;
    private _trackerFacingDir = direction _tracker;
    // get positive value of direction difference
    private _dirDiff = abs (_dirTargetFromTracker - _trackerFacingDir);    

	// calculate strength based on distance
    private _distance = _tracker distance _target;

    // distance strength is procentage divided into our scanRange and then multiplied by how far we are to the scanrange.
    private _distStrength = round((100 / _scanRange) * (_scanRange - _distance));

    // direction strength, get abs value
    private _dirStrength = abs round((100 / 180) * (180 - _dirDiff));

    // sig strength is 100 - average of dir and dist strength and then negated from positive. 
    private _sigStrength = (100 - ((_distStrength + _dirStrength) / 2)) * (-1);

    // push to sig array
    _sigsArray append [_frequency, _sigStrength];
} forEach GVAR(beacons);

// apply changes - only local
missionNamespace setVariable ["#EM_Values", _sigsArray];

//Debugging loaned for now from "Jam Radios script for TFAR created by Asherion and Rebel"
if (true) then {	
	systemChat format ["Sigs: %1", _sigsArray];
};




// private _tracker = player;
// private _scanRange = 300;
// private _sigsArray = [];
// {
// 	_x params ["_target", "_frequency"];

//     diag_log _target;
//     diag_log _frequency;

// 	private _dirTargetFromTracker = _tracker getDir _target;
//     diag_log _dirTargetFromTracker;

//     private _trackerFacingDir = direction _tracker;
//     diag_log _trackerFacingDir;

//     private _dirDiff = abs (_dirTargetFromTracker - _trackerFacingDir);    
//     diag_log _dirDiff;

//     private _distance = _tracker distance _target;
//     diag_log _distance;

//     private _distStrength = round((100 / _scanRange) * (_scanRange - _distance));
//     diag_log _distStrength;

//     private _dirStrength = abs round((100 / 180) * (180 - _dirDiff));
//     diag_log _dirStrength;

//     private _sigStrength = (100 - ((_distStrength + _dirStrength) / 2)) * (-1);
//     diag_log _sigStrength;

//     _sigsArray pushBack [_frequency, _sigStrength];
//     diag_log _sigsArray;
//     systemChat str(_sigsArray);
// } forEach crowsEW_spectrum_beacons;

// 20:22:08 21b0a3b9600# 1813963: satelliteantenna_01_f.p3d REMOTE
// 20:22:08 213.985
// 20:22:08 234.325
// 20:22:08 20.3402
// 20:22:08 177.081
// 20:22:08 41
// 20:22:08 89
// 20:22:08 -35
// 20:22:08 [[any,-35]]