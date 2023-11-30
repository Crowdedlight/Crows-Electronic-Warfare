#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Landric
			   
File: fnc_cmotionAudioKill.sqf
Parameters: unit: Object - of type unit
Return: none

Remove the audio component of all c-motion devices
placed by the unit

*///////////////////////////////////////////////

params ["_unit"];

{
	_x setVariable [QGVAR(cmotionAudio), nil];
	// TODO: Also keep a record of currently playing sounds, and stop those instantly with stopSound
} forEach (_unit getVariable [QGVAR(cmotionList), []]);
