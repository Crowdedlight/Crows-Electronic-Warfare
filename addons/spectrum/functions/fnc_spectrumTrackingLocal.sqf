#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_spectrumTrackingLocal.sqf
Parameters: 
Return: 

Script being called by PFH to handle updates to the direction and signal of the tracking device 

*///////////////////////////////////////////////

// only calculate if there is any signals, otherwise reset the list
if (count GVAR(beacons) == 0) exitWith {
    missionNamespace setVariable ["#EM_Values", []];
};

// set tracker unit
private _tracker = GVAR(trackerUnit);
// add check for race condition of if zeus RC messed up and not got reset correctly on unit death. 
if (isNull _tracker || !alive _tracker) then {_tracker = player};

// only calculate if we got analyzer as tracker
if (!("hgun_esd_" in (handgunWeapon _tracker))) exitWith {}; 

// only work if we got an antenna on 
if (GVAR(spectrumRangeAntenna) == -1) exitWith {
    missionNamespace setVariable ["#EM_Values", []];
};

// update local array for deleted or dead elements
private _removeArr = [];
{
    // get target obj
    private _target = _x select 0;

    // if removed or dead, remove it from tracking array
    if (isNull _target || !alive _target) then {
        _removeArr pushBack _x;
    };
} forEach GVAR(beacons);

// update list
GVAR(beacons) = GVAR(beacons) - _removeArr;

// for each beacon calculate direction, and strength based on distance.
private _sigsArray = [];
{
	_x params [["_target",objNull,[objNull]], ["_frequency", 0, [0]], ["_scanRange",300, [0]], ["_type", "zeus", [""]]];

    // if for safety and so we don't track ourself
    if (isNull _target || _frequency == 0 || _target == _tracker) then {continue};

    // if frequency outside range of antenna skip it
    private _requiredAntennas = [_frequency] call FUNC(getAntennaFromFrequency);
    // if (!(GVAR(spectrumRangeAntenna) in _requiredAntennas)) then {systemChat format["antenna: %1 is not in %2", GVAR(spectrumRangeAntenna), _requiredAntennas]; continue; };
    if (!(GVAR(spectrumRangeAntenna) in _requiredAntennas)) then { continue; };

    // if jammer is equipped, only show signals that is type drone 
    if (GVAR(spectrumRangeAntenna) == 3 && _type != "drone") then { continue; };

    // Get signal strength 
    private _sigStrength = [_target, _tracker, _scanRange] call FUNC(calcSignalStrength);

    // push to sig array
    _sigsArray append [_frequency, _sigStrength];
} forEach GVAR(beacons);

// apply changes - only local
missionNamespace setVariable ["#EM_Values", _sigsArray];

// //Debugging
// if (true) then {	
// 	systemChat format ["Sigs: %1", _sigsArray];
// };
