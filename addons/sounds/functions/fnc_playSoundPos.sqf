#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_playSoundPos.sqf
Parameters: position array, range, sound, volume, targets
Return: none

Plays sound for everyone once

*///////////////////////////////////////////////
params ["_position", "_range", "_sound", "_volume", ["_local", false]];

// get loop-sleep time for the sound, this is the length of the sound so it repeats itself. 
private _soundAttri = GVAR(soundAttributes) get _sound;

// checking is sound exists or something has gone wrong
if (isNil "_soundAttri") exitWith {diag_log format ["crowsEW-sounds: Sound not found: %1", _sound]; hint "Sound Not Found"};

private _soundPath = (_soundAttri select 1);

playSound3D [_soundPath, objNull, false, _position, _volume, 1, _range, 0, _local];

