#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_addSound.sqf
Parameters: pos, _unit
Return: none

Called upon event, adds the sound to the list of active sounds

*///////////////////////////////////////////////
params ["_unit", "_delay", "_range", "_repeat", "_aliveCondition", "_sound"];

// if object is null, exitwith. Can happen if we get event as JIP but object has been removed
if (isNull _unit) exitWith {};

// check if sound is valid
if (!(_sound in GVAR(soundAttributes))) exitWith {diag_log format ["crowsEW-sounds: Sound not found: %1", _sound]};

// get loop-sleep time for the sound, this is the length of the sound so it repeats itself. 
private _soundLength = GVAR(soundAttributes) getOrDefault [_sound, 1];
private _loopTime = _delay + soundLength;

// add to array [unit, loopTime, range, repeat, aliveCondition, sound, enabled, lastPlayed]
GVAR(soundList) pushBack [_unit, _loopTime, _range, _repeat, _aliveCondition, _sound, true, 0];

diag_log "adding sound";