#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: b-mayr-1984 - Bernhard Mayr
			   
File: fnc_handleNewRadioSoundStarted.sqf

Parameters:  
	_unit		unit/object to attach the signal to

Return:  none

This function is an event handler.

It is used to play different sounds in sequence, 
when the player decides to listen in on a "sound" type signal.

Client only

*///////////////////////////////////////////////

if (!hasInterface) exitWith {};

params [["_unit", objNull, [objNull]]];

if (isNull _unit ) exitWith {
	diag_log "CrowsEW:fnc_handleNewRadioSoundStarted.sqf: Can not listen to 'objNull'"; 
};

private _sound = _unit getVariable[QGVAR(currentRadioSound), ""];
private _offset = serverTime - (_unit getVariable[QGVAR(currentRadioSoundStartTime), 0]);

// play sound
private _soundId = playSoundUI [_sound, 1.0, 1.0, false, _offset];
// systemChat format ["playSoundUI handle %1", _sound];
GVAR(currentPlayerLocalRadioSoundIds) pushBack _soundId;

// TODO: 
// Implement mechanism that checks for proper signal strength.
// Right now a player could start to listen in and then point the antenna to somewhere else.
// Even if the signal strength falls below the threshold then, the player can still listen to the sound for as long as the mouse is pressed.
