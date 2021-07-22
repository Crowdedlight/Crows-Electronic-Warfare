#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_spectrumDeviceMouseDown.sqf
Parameters: 
Return: 

Called on event for mouseDown

*///////////////////////////////////////////////
params ["_displayorcontrol", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];

// check if left mouse-down (0), right-mouse == 1
if (_button != 0 || !alive player) exitWith {};

// check if current weapon is hgun_esd
if (!("hgun_esd_" in (currentWeapon player))) exitWith {}; 

// mouse down, set firing as active
missionNamespace setVariable ["#EM_Transmit",true];

// get selected frequency 
private _selectedFreqMin = 	missionNamespace getVariable["#EM_SelMin",-1];
private _selectedFreqMax = 	missionNamespace getVariable["#EM_SelMax",-1];

// find all current frequencies within the range
private _frequencies = [_selectedFreqMin, _selectedFreqMax] call FUNC(getActiveBeaconsInRange);

private _unit = objNull;
private _range = 0;
private _jam = false;
private _failed = false;

// if type radiochatter, get random selection of voice clip, and play it. 
private _timeActive = 5;
{
	scopeName "loopFreq";
	// if type is "radioChatter", play sound and save beacon in gvar
	_type = _x select 3;

	// switch case based on type
	switch (_type) do {
		case "chatter": {			
			private _sound = "";
			private _sigStrength = [(_x select 0), player, (_x select 2)] call FUNC(calcSignalStrength);

			// only real radio line if signal strength is better than -60
			if (_sigStrength < -60) then {
				// not strong enough signal, so we play garabled radio
				_sound = "garbled"; 
				_timeActive = 4.3;
			} else {
				// select random sound - Weighted so eastereggs can be more rare than rest others
				private _soundInfo = GVAR(voiceLinesList) selectRandomWeighted GVAR(voiceLinesWeights);

				_timeActive = _soundInfo select 1;
				_sound = _soundInfo select 0;
			};

			// play sound
			GVAR(radioChatterVoiceSound) = playSound _sound;
			breakOut "loopFreq"; //breakout as even if multiple signals, we only count the first we react on. 
		};
		case "drone": {
			if (GVAR(spectrumRangeAntenna) == 3) then {
				// set vars 
				_unit = _x select 0;
				_range = (_x select 2);

				// check if strong enough
				private _sigStrength = [_unit, player, _range] call FUNC(calcSignalStrength);
				if (_sigStrength < -50) then {
					//  do fail if not strong enough
					systemChat "too low signal, set failed = true";
					_failed = true;
				};
				
				// play charge up jamming sound
				GVAR(radioChatterVoiceSound) = playSound "jamcharging";

				// set jamming var
				GVAR(isJammingDrone) = _unit;
				_jam = true;

				_timeActive = 1;
			} else {
				// just play electronic sounds, as we don't have jammer on
				// TODO

			};
			breakOut "loopFreq"; //breakout as even if multiple signals, we only count the first we react on. 
		};
	};
} forEach _frequencies; // [_unit, _frequency, _scanRange, _type]

// spawn function that increments progress over same time interval as duration of voice clip
GVAR(radioChatterProgressHandle) = [_timeActive, _jam, _unit, _range, _failed] spawn {
	params["_timeActive", "_jam", "_unit", "_range", "_failAction"];

	private _progress = 0;
	private _step = 0.1/_timeActive;

	// steps of 10th of seconds as we sleep 0.1 per execution
	for "_i" from 0 to _timeActive+0.1 step 0.1 do {
		hintSilent str(_progress);
		missionNamespace setVariable ["#EM_Progress",_progress];
		_progress = _progress + _step;
		sleep 0.1;
	};

	// if type == drone, we now apply jamming 
	if (_jam) then {

		// if we failed, we exit with the resetting of jam unit, progress and error sound
		if (_failAction) exitWith {
			systemChat "Exit due to low signal strength";
			playSound "spectrumjamerror";
			missionNamespace setVariable ["#EM_Transmit",false];
			missionNamespace setVariable ["#EM_Progress",0];
			GVAR(isJammingDrone) = objNull;
		};

		systemChat "Jamming active";
		[QGVAR(toggleJammingOnUnit), [_unit, true, player], _unit] call CBA_fnc_targetEvent;
		
		// spawn looping effect that works until GVAR from mouse-down, or if weapon are no longer in hand
		sleep 0.2; // for sound effect 		

		while {!isNull GVAR(isJammingDrone) && alive player} do {
			// play sound
			GVAR(radioChatterVoiceSound) = playSound "spectrumjamloop";

			// check if signal strength goes below ??, then we stop the jamming
			private _sigStrength = [_unit, player, _range] call FUNC(calcSignalStrength);
			if (_sigStrength < -50) exitWith {
				// stop jamming
				[QGVAR(toggleJammingOnUnit), [GVAR(isJammingDrone), false, player], GVAR(isJammingDrone)] call CBA_fnc_targetEvent;
				GVAR(isJammingDrone) = objNull;
				// show error 
				playSound "spectrumjamerror";
				missionNamespace setVariable ["#EM_Transmit",false];
				missionNamespace setVariable ["#EM_Progress",0];
			};

			// consider an effect? Like the ripple effect outwards from jammer towards drone? 
			sleep 2;
		};
	};
};
