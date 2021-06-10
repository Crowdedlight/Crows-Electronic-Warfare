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


// for each beacon calculate direction, and strength based on distance.
private _sigsArray = [];
private _tracker = player;
{
	_x params [["_target",objNull,[objNull]], ["_frequency", 0], ["_scanRange",300]];

    // if for safety 
    if (_target == objNull || _frequency == 0) then {continue};

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

    // sig strength is 100 - average of dir and dist strength and then negated from positive. Dir is made to count for 75% of the strength as directional is much more important than distance
    private _sigStrength = (100 - (_distStrength/0.25 + _dirStrength/0.75)) * (-1);

    // push to sig array
    _sigsArray append [_frequency, _sigStrength];
} forEach GVAR(beacons);

// apply changes - only local
missionNamespace setVariable ["#EM_Values", _sigsArray];

//Debugging loaned for now from "Jam Radios script for TFAR created by Asherion and Rebel"
if (true) then {	
	systemChat format ["Sigs: %1", _sigsArray];
};