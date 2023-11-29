#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_getSoundName.sqf
Parameters: sound: String - short ID of sound file
Return: String - display name of sound or Nothing

Returns the filepath of the sound with the given short ID

Example:
	["air_raid_siren"] call crowsew_sounds_fn_getSoundName; // returns "Air Raid Siren (2.5min)"

*///////////////////////////////////////////////
params ["_sound"];

private _soundAttri = GVAR(soundAttributes) get _sound;

// checking is sound exists or something has gone wrong
if (isNil "_soundAttri") exitWith {diag_log format ["crowsEW-sounds: Sound not found: %1", _sound]; hint "Sound Not Found"};

(_soundAttri select 2)
