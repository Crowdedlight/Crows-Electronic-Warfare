#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_playSoundPos.sqf
Parameters: position: Array in format PositionASL
			range: Number - distance in m from which the sound can be heard
			sound: String - short ID of the soundfile to be played,
			volume: Number - volume level of the sound
			local: Boolean - whether the sound is local to the client
Return: Number - id of the sound (0..65535) 

Plays sound at position once

*///////////////////////////////////////////////
params ["_position", "_range", "_sound", "_volume", ["_local", false]];

(playSound3D [[_sound] call FUNC(getSoundPath), objNull, false, _position, _volume, 1, _range, 0, _local])
