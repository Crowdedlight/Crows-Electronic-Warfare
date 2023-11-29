#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_soundLoopServer.sqf
Parameters: 
Return: 

Script being called by PFH to handle sound playing

*///////////////////////////////////////////////

// only calculate if there is any sounds
if (count GVAR(soundList) == 0) exitWith {};

// Current time, as we only run on server we don't need to bother with the sync across clients for simultanious playing
private _now = time;

private _deleteArr = [];

// loop through all sounds on list
{
	_x params ["_unit", "_loopTime", "_range", "_repeat", "_aliveCondition", "_sound", "_enabled", "_lastPlayed", "_delayInitial", "_volume", "_displayName"]; 

	// remove sound if obj is null or if not alive, and alive var is true
	if (isNull _unit || (_aliveCondition && !alive _unit)) then {
		_deleteArr pushBack _x;
		continue;
	};

	// if enabled is false, skip
	if (!_enabled) then { continue; };

	// calculate if its time to play it
	private _timeDiff = _now - _lastPlayed;

	if (_timeDiff > _loopTime && _now > _delayInitial) then {
		// play sound, we use remoteExec from server to play, to sync so all clients hears the sound at the same time.
		// [_unit, [_sound, _range, 1] ] remoteExec ["say3D", [0,-2] select isDedicated, false]; // all but server and no JIP as this is continously execution

		// plays the same file on global scale
		private _soundID = playSound3D [_sound, _unit, false, getPosASL _unit, _volume, 1, _range, 0];

		// Update the soundID mapping, so sounds can be stopped on destruction/deletion
		// (technically this doesn't account for the same sound being added twice, but that
		// seems an unlikely use-case)
		private _soundMap = _unit getVariable [QGVAR(soundIDMap), createHashMap];
		_soundMap set [_sound, _soundID]; 
		_unit setVariable [QGVAR(soundIDMap), _soundMap, true];

		// if no repeat
		if (!_repeat) then { 
			_deleteArr pushBack _x;
			continue; // skip setting lastplayed
		};

		// set new lastPlayed 
		_x set [7, _now];
	};
} forEach GVAR(soundList);

// update array if deletions
if (count _deleteArr > 0) then {
	GVAR(soundList) = GVAR(soundList) - _deleteArr;
	// update for zeus' to see change
	SETMVAR(GVAR(activeSounds),GVAR(soundList));
};
