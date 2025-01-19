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
if (!("hgun_esd_" in (currentWeapon _tracker))) exitWith {}; 

// only work if we got an antenna on 
if (GVAR(spectrumRangeAntenna) == -1) exitWith {
    missionNamespace setVariable ["#EM_Values", []];
};

// for each beacon calculate direction, and strength based on distance.
private _sigsArray = [];
{
	_x params [["_target",objNull,[objNull]], ["_frequency", 0, [0]], ["_scanRange",300, [0]], ["_type", "zeus", [""]]];

    // if for safety and so we don't track ourself
    if (isNull _target || _frequency == 0 || (_target == _tracker && !GVAR(selfTracking))) then {continue};

    // if frequency outside range of antenna skip it
    private _requiredAntennas = [_frequency] call FUNC(getAntennaFromFrequency);
    // if (!(GVAR(spectrumRangeAntenna) in _requiredAntennas)) then {systemChat format["antenna: %1 is not in %2", GVAR(spectrumRangeAntenna), _requiredAntennas]; continue; };
    if (!(GVAR(spectrumRangeAntenna) in _requiredAntennas)) then { continue; };

    // if jammer is equipped, only show signals that is type drone or sweep
    if (GVAR(spectrumRangeAntenna) == 3 && { !(_type in ["drone", "sweep_drone"]) } ) then { continue; };

    // if tfar radio, and same side as you, skip if setting is enabled
    if (!GVAR(tfarSideTrack) && _type == "radio" && (side _target == side player)) then {continue; };

    // Get signal strength 
    private _sigStrength = [_target, _tracker, _scanRange] call FUNC(calcSignalStrength);

    // get next frequency for a frequency sweeper
    if (_type == "sweep_drone") then {
        _frequency = [(GVAR(spectrumDeviceFrequencyRange)#2)#0, (GVAR(spectrumDeviceFrequencyRange)#2)#2, 4, _forEachIndex] call FUNC(getNextSweepFreq);    // overides the original _frequency value
    };
    if (_type == "sweep_radio") then {
        _frequency = [(GVAR(spectrumDeviceFrequencyRange)#0)#0, (GVAR(spectrumDeviceFrequencyRange)#0)#2, 120, _forEachIndex] call FUNC(getNextSweepFreq);    // overides the original _frequency value
    }; 

    // push to sig array
    _sigsArray append [_frequency, _sigStrength];
} forEach GVAR(beacons);

// apply changes - only local
missionNamespace setVariable ["#EM_Values", _sigsArray];

// TODO call hud icons as they might as well update with same frequency as signals? 


// //Debugging
// if (true) then {	
// 	systemChat format ["Sigs: %1", _sigsArray];
// };
