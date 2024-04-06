#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_addRandomRadioTrackingChatterZeus.sqf
Parameters: pos, _unit
Return: none

Zeus dialog to make set unit randomly add signal sources for spectrum tracking. Simulates the AI doing radio chatter that is able to get picked up by the spectrum analyzer

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//ZEN dialog
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_voicePack",
		"_freqMin",
		"_freqMax",
		"_range",
		"_durationMin",
		"_durationMax",
		"_pauseMin",
		"_pauseMax"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
	
	// if object is null, we can't start the jamming
	if (_unit == objNull) exitWith {hint "You have to select a unit";};

	// broadcast event to all clients and JIP
	[QEGVAR(spectrum,addRandomRadioTrackingChatter), [_unit, _range, [_pauseMin, _pauseMax], [_durationMin, _durationMax], [_freqMin, _freqMax], _voicePack]] call CBA_fnc_serverEvent;
};

// get keys from hashmap to support custom/template added soundpacks
private _keyNameArr = [];
private _displayNameArr = [];
{
	// _x is key 
	_keyNameArr pushBack _x;
	// _y is values
	_displayNameArr pushBack _y#2;
} forEach EGVAR(spectrum,voiceLinePacks);

private _signalRange = EGVAR(spectrum,spectrumDeviceFrequencyRange)#0;
private _half = _signalRange#0 + _signalRange#2/2;

[
	"Set Spectrum Signal Source", 
	[
		["COMBO",["VoicePack", "Select what voicepack to use when people listen to the transmitted signal"],[_keyNameArr, _displayNameArr, 0]],
		["SLIDER",["Frequency min.", "The minimum frequency used. Recommend small interval"],[_signalRange#0,_signalRange#1,_half-10,1]], //60 to 250, default 220 and showing 1 decimal
		["SLIDER",["Frequency max.", "The maximum frequency used. Recommend small interval"],[_signalRange#0,_signalRange#1,_half+10,1]], //60 to 250, default 221 and showing 1 decimal
		["SLIDER","Range",[1,10000,2000,0]], //1 to 10000, default 2000 and showing 0 decimal
		["SLIDER",["Duration min.", "The minimum duration of each chatter broadcast"],[4,40,5,0]], //1 to 40, default 5 and showing 0 decimal
		["SLIDER",["Duration max.", "The maximum duration of each chatter broadcast"],[4,100,30,0]], //1 to 100, default 30 and showing 0 decimal
		["SLIDER",["Pause min.", "The minimum time between chatter broadcasts"],[1,40,5,0]], //1 to 40, default 5 and showing 0 decimal
		["SLIDER",["Pause max.", "The minimum time between chatter broadcasts"],[1,100,10,0]] //1 to 100, default 30 and showing 0 decimal
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;