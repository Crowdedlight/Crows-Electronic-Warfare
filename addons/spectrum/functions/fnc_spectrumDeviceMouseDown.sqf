#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_spectrumDeviceMouseDown.sqf
Parameters: 
Return: 

Called on event for mouseDown

*///////////////////////////////////////////////
params ["_displayorcontrol", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];

// check if left mouse-down (0), right-mouse == 1, middle-mouse == 2
if (_button in [1,3,4] || !alive player) exitWith {};

// check if current weapon is hgun_esd
if (!("hgun_esd_" in (currentWeapon player))) exitWith {}; 

// check if we got dialog or another display open? 
// 602 == inventory open, 12 == map, 24 == chatbox, 160 == uavTerminal
if (!isNull (findDisplay 602) || !isNull (findDisplay 24) || !isNull (findDisplay 160) || visibleMap) exitWith {};

// if we are middle mouse down, handle that
if (_button == 2) exitWith {
	// call function to solve middle mouse behaviour
	[_shift] call FUNC(spectrumDeviceMouseMiddleDown);
};

// mouse down, set firing as active
missionNamespace setVariable ["#EM_Transmit",true];

// get selected frequency 
private _selectedFreqMin = 	missionNamespace getVariable["#EM_SelMin",-1];
private _selectedFreqMax = 	missionNamespace getVariable["#EM_SelMax",-1];

// find all current frequencies within the range
private _frequencies = [_selectedFreqMin, _selectedFreqMax] call FUNC(getActiveBeaconsInRange);
private _frequenciesSorted = [_frequencies, [], {[_x#0, player, _x#2] call FUNC(calcSignalStrength)}, "DESCEND"] call BIS_fnc_sortBy;	// _x == [_unit, _frequency, _scanRange, _type]

private _unit = objNull;
private _range = 0;
private _jam = false;
private _radio = false;
private _failed = false;

// if type radiochatter, get random selection of voice clip, and play it. 
private _timeActive = 5;

if (count _frequenciesSorted > 0) then {
	private _strongestSignal = _frequenciesSorted#0;
	
	// if type is "radioChatter", play sound and save beacon in gvar
	_unit = _strongestSignal#0;
	_range = _strongestSignal#2;
	private _type = _strongestSignal#3;
	private _frequency = _strongestSignal#1;
	private _sigStrength = [_unit, player, _range] call FUNC(calcSignalStrength);

	// broadcast local event that we are now "active" on this signal
	[QGVAR(activatedSpectrumDevice), [_type, _frequency, _unit, _sigStrength]] call CBA_fnc_localEvent;

	// switch case based on type
	switch (_type) do {
		case "sound": {			
			private _sound = "";
			private _offset = 0;
			
			// only real radio line if signal strength is better than -60
			if (_sigStrength < -60) then {
				// not strong enough signal, so we play garbled radio
				_sound = "crowsEW_garbled"; 
				_timeActive = 4.3;
			} else {
				_sound = _unit getVariable[QGVAR(currentRadioSound), ""];
				_offset = serverTime - (_unit getVariable[QGVAR(currentRadioSoundStartTime), 0]);
			};

			// play sound
			GVAR(currentPlayerLocalRadioSoundId) = playSoundUI [_sound, 1.0, 1.0, false, _offset];
		};
		case "chatter": {			
			private _sound = "";
			
			// only real radio line if signal strength is better than -60
			if (_sigStrength < -60) then {
				// not strong enough signal, so we play garbled radio
				_sound = "crowsEW_garbled"; 
				_timeActive = 4.3;
			} else {
				// get voicepack - default to british
				private _voicePackKey = _unit getVariable[QGVAR(radioChatterVoicePack), "british"];
				private _voicePack = GVAR(voiceLinePacks) get _voicePackKey;

				// select random sound - Weighted so eastereggs can be more rare than rest others
				private _soundInfo = _voicePack#0 selectRandomWeighted _voicePack#1;

				_timeActive = _soundInfo#1;
				_sound = _soundInfo#0;
			};

			// play sound
			GVAR(radioChatterVoiceSound) = playSound _sound;
		};
		case "drone": {
			// if Jam antenna do jam handling
			if (GVAR(spectrumRangeAntenna) == 3) then {
				// check if strong enough
				if (_sigStrength < GVAR(minJamSigStrength)) then {
					//  do fail if not strong enough
					// systemChat "too low signal, set failed = true";
					_failed = true;
				};
				
				// play charge up jamming sound
				GVAR(radioChatterVoiceSound) = playSound "crowsEW_jamcharging";

				// set jamming var
				GVAR(isJammingDrone) = _unit;
				_jam = true;

				_timeActive = 1;
			} else { // if non-jam antenna we can still listen to it
				// check strength
				if (_sigStrength < -60) then {
					// play garbled
					GVAR(radioChatterVoiceSound) = playSound "crowsEW_garbled";
					_timeActive = 4.3;
				} else {
					// just play electronic sounds, as we don't have jammer on
					if (_unit isKindOf "UAV_03_dynamicLoadout_base_F") then {
						GVAR(radioChatterVoiceSound) = playSound "crowsEW_dronehelimotor";
						_timeActive = 4;
					} else {
						GVAR(radioChatterVoiceSound) = playSound "crowsEW_ugvmotor";
						_timeActive = 3;
					};
				}
			};
		};
		case "radio": {
			// listen to signal instantly
			_radio = true;
			_timeActive = 0.1;
		};
		case "sweep_drone";	// Players can not interact with a drone jammer. So just ignore this signal.
		case "sweep_radio";	// Players can not interact with the radio jammer signal. So just ignore this signal.
		default { 
				diag_log format ["CrowsEW:fnc_spectrumDeviceMouseDown.sqf: '%1' is an unkown type of signal source/beacon!!!", _type]; 
			};
	};
};

// spawn function that increments progress over same time interval as duration of voice clip
GVAR(radioChatterProgressHandle) = [_timeActive, _jam, _unit, _range, _failed, _radio] spawn {
	params["_timeActive", "_jam", "_unit", "_range", "_failAction", "_radio"];

	private _progress = 0;
	private _step = 0.1/_timeActive;

	// steps of 10th of seconds as we sleep 0.1 per execution
	for "_i" from 0 to _timeActive+0.1 step 0.1 do {
		missionNamespace setVariable ["#EM_Progress",_progress];
		_progress = _progress + _step;
		sleep 0.1;
	};

	// if type == radio, we can now listen to the radio
	if (_radio) exitWith {
		// a TFAR signal, call to start listening to TFAR signal
		[_unit] call FUNC(listenToRadioStart);
	};

	// if type == drone, we now apply jamming 
	if (_jam) then {

		// if we failed, we exit with the resetting of jam unit, progress and error sound
		if (_failAction) exitWith {
			// systemChat "Exit due to low signal strength";
			playSound "crowsEW_spectrumjamerror";
			[parseText format["<t size='0.9'>&lt;-- %2 %1%3</t>",GVAR(minJamSigStrength), localize "STR_CROWSEW_Spectrum_error_jam_strength_min", localize "STR_CROWSEW_Spectrum_error_jam_strength"],-1,[0.85, 0.2],5,1,1,789] spawn BIS_fnc_dynamicText;
			missionNamespace setVariable ["#EM_Transmit",false];
			missionNamespace setVariable ["#EM_Progress",0];
			GVAR(isJammingDrone) = objNull;
		};

		// systemChat "Jamming active";
		[QGVAR(toggleJammingOnUnit), [_unit, true, player]] call CBA_fnc_serverEvent;
		
		// spawn looping effect that works until GVAR from mouse-down, or if weapon are no longer in hand
		sleep 0.2; // for sound effect 		

		while {!isNull GVAR(isJammingDrone) && alive player} do {
			// play sound
			GVAR(radioChatterVoiceSound) = playSound "crowsEW_spectrumjamloop";

			// check if signal strength goes below ??, then we stop the jamming
			private _sigStrength = [_unit, player, _range] call FUNC(calcSignalStrength);
			if (_sigStrength < GVAR(minJamSigStrength)) exitWith {
				// stop jamming
				[QGVAR(toggleJammingOnUnit), [GVAR(isJammingDrone), false, player]] call CBA_fnc_serverEvent;
				GVAR(isJammingDrone) = objNull;
				// show error 
				playSound "crowsEW_spectrumjamerror";
				[parseText format["<t size='0.9'>&lt;-- %2 %1%3</t>",GVAR(minJamSigStrength), localize "STR_CROWSEW_Spectrum_error_jam_strength_min", localize "STR_CROWSEW_Spectrum_error_jam_strength"],-1,[0.85, 0.2],5,1,1,789] spawn BIS_fnc_dynamicText;
				missionNamespace setVariable ["#EM_Transmit",false];
				missionNamespace setVariable ["#EM_Progress",0];
			};

			// consider an effect? Like the ripple effect outwards from jammer towards drone? 
			sleep 2;
		};
	};
};
