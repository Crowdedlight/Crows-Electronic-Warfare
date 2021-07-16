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

// if type radiochatter, get random selection of voice clip, and play it. 
private _timeActive = 5;
{
	scopeName "loopFreq";
	// if type is "radioChatter", play sound and save beacon in gvar
	private _type = _x select 3;
	private _strength = _x select 3;

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
				
				diag_log _soundInfo;

				_timeActive = _soundInfo select 1;
				_sound = _soundInfo select 0;
			};

			// play sound
			GVAR(radioChatterVoiceSound) = playSound _sound;
			breakOut "loopFreq"; //breakout as even if multiple signals, we only count the first we react on. 
		};
	};
} forEach _frequencies;

// spawn function that increments progress over same time interval as duration of voice clip
GVAR(radioChatterProgressHandle) = [_timeActive] spawn {
	params["_timeActive"];

	private _progress = 0;
	private _step = 0.1/_timeActive;

	// steps of 10th of seconds as we sleep 0.1 per execution
	for "_i" from 0 to _timeActive step 0.1 do {
		hintSilent str(_progress);
		missionNamespace setVariable ["#EM_Progress",_progress];
		_progress = _progress + _step;
		sleep 0.1;
	};
};
