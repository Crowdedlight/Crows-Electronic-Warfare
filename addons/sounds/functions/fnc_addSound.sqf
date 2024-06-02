#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_addSound.sqf
Parameters: unit: Object to add the sound to
		delayBetween: Number - delay in seconds between repeated plays
		range: Number - range in meters at which the sound can be heard
		repeat: Boolean - whether the sound should repeat
		aliveCondition: Boolean - whether the sound should be removed on unit death
		sound: String - the sound's shortID
		delayInitial: Number - delay in seconds before the initial play
		volume: Number - volume at which the sound should be played
Return: none

Called upon event, adds the sound to the list of active sounds

*///////////////////////////////////////////////
params ["_unit", "_delayBetween", "_range", "_repeat", "_aliveCondition", "_sound", "_delayInitial", "_volume"];

if (isNull _unit) exitWith {diag_log format ["crowsEW-sounds: Unit not found: %1", _sound];};

// get loop-sleep time for the sound, this is the length of the sound so it repeats itself. 
private _soundAttri = GVAR(soundAttributes) get _sound;

// checking is sound exists or something has gone wrong
if (isNil "_soundAttri") exitWith {diag_log format ["crowsEW-sounds: Sound not found: %1", _sound]; hint localize "STR_CROWSEW_Sounds_not_found"};

private _soundLength = (_soundAttri select 0);
private _soundPath = (_soundAttri select 1);
private _displayName = (_soundAttri select 2);

private _loopTime = _delayBetween + _soundLength;
private _startDelay = time + _delayInitial;

// add to array [unit, loopTime, range, repeat, aliveCondition, sound, enabled, lastPlayed, _startDelay, _volume, _displayName]
GVAR(soundList) pushBack [_unit, _loopTime, _range, _repeat, _aliveCondition, _soundPath, true, 0, _startDelay, _volume, _displayName];
// update for zeus' to see change
SETMVAR(GVAR(activeSounds),GVAR(soundList));

// Store a map of currently playing sounds, so sounds can be stopped on destruction/deletion
if(_aliveCondition) then {
	_unit addEventHandler ["Killed", {
		params ["_unit", "_killer", "_instigator", "_useEffects"];
		{ stopSound _x } forEach values (_unit getVariable [QGVAR(soundIDMap), createHashMap]); 
	}];
};

_unit addEventHandler ["Deleted", {
	params ["_entity"];
	{ stopSound _x } forEach values (_entity getVariable [QGVAR(soundIDMap), createHashMap]); 
}];