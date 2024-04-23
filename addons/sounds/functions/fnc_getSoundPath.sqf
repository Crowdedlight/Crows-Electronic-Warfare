#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_getSoundPath.sqf
Parameters: sound: String - short ID of sound file
Return: String - path of soundfile or Nothing

Returns the filepath of the sound with the given short ID

Example:
	["air_raid_siren"] call crowsew_sounds_fn_getSoundPath; // returns "z\crowsEW\addons\sounds\data\air_raid_siren.ogg"

*///////////////////////////////////////////////
params ["_sound"];

private _soundAttri = GVAR(soundAttributes) get _sound;

// checking is sound exists or something has gone wrong
if (isNil "_soundAttri") exitWith {diag_log format ["crowsEW-sounds: Sound not found: %1", _sound]; hint "Sound Not Found"};

(_soundAttri select 1)
