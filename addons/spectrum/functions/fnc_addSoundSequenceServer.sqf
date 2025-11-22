#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: b-mayr-1984 - Bernhard Mayr
		(leaning heavily on Crowdedlight's work in fnc_addRandomRadioTrackingChatterServer.sqf)
			   
File: fnc_addSoundSequenceServer.sqf

Parameters:  
	_unit		unit/object to attach the signal to
	_freq		frequency to broadcast on
	_range		range of the broadcasted signal
	_sounds		array of sounds to be played/transmitted in sequence
					alternatively, instead of a sound a number can be given (then no sound is played, just silence for that duration in seconds)
	_loop		boolean that tells if the sequence shall loop indefinately (default: false); useful for permanently active radio broadcasting stations

Return:  script handle of spawned loop (can be used to terminate the sound sequence by using "terminate _handle;")

Use this function 
to add a list of sounds (CfgSounds or a sound file; see BIKI on playSoundUI for details)
to be broadcast in the spectrum.

Server only

Examples:
	_audioSequenceLoop = [_myRadioTower, 98.5, 5000, ["News_Jingle", "News_idap"], true] call crowsew_spectrum_fnc_addsoundsequenceserver;

	_audioSequenceLoop = [_myRadioTower, 98.5, 5000, ["News_Jingle", 1.5, "News_idap", 1.1], true] call addsoundsequenceserver;

	// to stop the sequence later make these 2x calls:
	terminate _audioSequenceLoop;
	[_myRadioTower, "sound"] call crowsew_spectrum_fnc_removebeaconserver;

*///////////////////////////////////////////////

if (!isServer) exitWith {};

params [["_unit", objNull, [objNull]], ["_freq", 123, [1337]], ["_range", 300, [1337]], ["_sounds", [], [[]]], ["_loop", false, [false]]];

if (isNull _unit || _sounds isEqualTo []) exitWith {
	diag_log format ["CrowsEW:fnc_addSoundSequenceServer.sqf: Can not add sequence with _unit=%1 or _sounds=%2.", _unit, _sounds]; 
};

// if the unit already plays a sound sequence stop it first
private _existingHandle = _unit getVariable[QGVAR(radioSoundHandle), scriptNull];
if (!isNull _existingHandle) then {
	terminate _existingHandle;
	// remove signal 
	[_unit, "sound"] call FUNC(removeBeaconServer);

	// remove from zeus draw list - We wait with publish update until end of script where we publish anyway for the new draws
	// private _rmIndex = GVAR(radioTrackingAiUnits) findIf { (_x select 0) == _unit};
	// GVAR(radioTrackingAiUnits) deleteAt _rmIndex;
};

private _handle = [_unit, _freq, _range, _sounds, _loop] spawn {
	params ["_unit", "_freq", "_range", "_sounds", "_loop"];

	private _firstSequence = true;	// Is this our first run through the sequence?

	// add signal to spectrum
	[_unit, _freq, _range, "sound"] call FUNC(addBeaconServer);

	while {_firstSequence || _loop} do {
		// loop through sounds and play them in sequence
		{
			if (!alive _unit) exitWith { _loop = false; };	// if unit is dead, exit

			// if no sound is given but a delay number, sleep for that number in seconds
			if (_x isEqualType 1337) then {				
				sleep _x;
				continue;	// just sleep and continue to next entry in the sequence
			};

			private _sound = _x;

			// save currently played sound and when it started
			_unit setVariable[QGVAR(currentRadioSound), _sound, true];
			_unit setVariable[QGVAR(currentRadioSoundStartTime), serverTime, true];

			// notify all listeners that sound started
			private _clientIDs = _unit getVariable[QGVAR(currentRadioSoundListeners), []];;
			{				
				[QGVAR(newRadioSoundStarted), [_unit], _x] call CBA_fnc_ownerEvent;				
			} forEach _clientIDs;

			// get sound length
			private _soundId = playSoundUI [_sound, 0.0];	// zero volume, just to get the soundId
			private _soundLength = (soundParams _soundId)#2;
			stopSound _soundId;	// stop sound right away; we only wanted to get the length

			// sleep for length
			sleep _soundLength;

			// reset sound variables
			_unit setVariable[QGVAR(currentRadioSound), objNull, true];
			_unit setVariable[QGVAR(currentRadioSound), "", true];
			_unit setVariable[QGVAR(currentRadioSoundStartTime), 0, true];

		} forEach _sounds;
		_firstSequence = false;
	};

	// remove signal
	[_unit, "sound"] call FUNC(removeBeaconServer);
};


// save handler to loop or a way to stop it, on var on unit, as we are on server, we only save locally
_unit setVariable[QGVAR(radioSoundHandle), _handle];


// add to array for drawing indication of what AI units has it enabled
// GVAR(radioTrackingAiUnits) pushBack [_unit, _voicePack];
// publicVariable QGVAR(radioTrackingAiUnits);

_handle;	// return handler so that caller can terminate if needed
