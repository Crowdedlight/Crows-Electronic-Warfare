#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_addSound.sqf
Parameters: pos, _unit
Return: none

Called upon event, adds the sound to the list of active sounds

*///////////////////////////////////////////////
params ["_unit", "_delayBetween", "_range", "_repeat", "_aliveCondition", "_sound", "_delayInitial", "_volume"];

// if object is null, exitwith. Can happen if we get event as JIP but object has been removed
if (isNull _unit) exitWith {};

// get loop-sleep time for the sound, this is the length of the sound so it repeats itself. 
private _soundAttri = GVAR(soundAttributes) get _sound;

// checking is sound exists or something has gone wrong
if (isNil "_soundAttri") exitWith {diag_log format ["crowsEW-sounds: Sound not found: %1", _sound]; hint "Sound Not Found"};

private _soundLength = (_soundAttri select 0);
private _soundPath = (_soundAttri select 1);

private _loopTime = _delayBetween + _soundLength;
private _startDelay = time + _delayInitial;

// add to array [unit, loopTime, range, repeat, aliveCondition, sound, enabled, lastPlayed, _startDelay, _volume]
GVAR(soundList) pushBack [_unit, _loopTime, _range, _repeat, _aliveCondition, _soundPath, true, 0, _startDelay, _volume];
