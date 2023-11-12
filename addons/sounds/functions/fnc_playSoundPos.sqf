#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_playSoundPos.sqf
Parameters: position array, range, sound, volume, targets
Return: none

Plays sound for everyone once

*///////////////////////////////////////////////
params ["_position", "_range", "_sound", "_volume", ["_local", false]];

playSound3D [[_sound] call FUNC(getSoundPath), objNull, false, _position, _volume, 1, _range, 0, _local];
