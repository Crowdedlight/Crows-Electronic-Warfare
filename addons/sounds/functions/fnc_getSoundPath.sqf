#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_getSoundPath.sqf
Parameters: sound: String - ID of sound
Return: String - path of soundfile or Nothing

Plays sound for everyone once

*///////////////////////////////////////////////
params ["_sound"];

private _soundAttri = GVAR(soundAttributes) get _sound;

// checking is sound exists or something has gone wrong
if (isNil "_soundAttri") exitWith {diag_log format ["crowsEW-sounds: Sound not found: %1", _sound]; hint "Sound Not Found"};

(_soundAttri select 1)
