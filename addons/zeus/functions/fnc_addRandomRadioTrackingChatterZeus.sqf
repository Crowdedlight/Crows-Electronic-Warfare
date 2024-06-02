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
	if (_unit == objNull) exitWith {hint localize "STR_CROWSEW_Zeus_error_select_unit";};

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
	localize "STR_CROWSEW_Zeus_addradiochatter_name", 
	[
		["COMBO",[localize "STR_CROWSEW_Zeus_addradiochatter_voicepack", localize "STR_CROWSEW_Zeus_addradiochatter_voicepack_tooltip"],[_keyNameArr, _displayNameArr, 0]],
		["SLIDER",[localize "STR_CROWSEW_Zeus_addradiochatter_freq_min", localize "STR_CROWSEW_Zeus_addradiochatter_freq_min_tooltip"],[_signalRange#0,_signalRange#1,_half-10,1]], //60 to 250, default 220 and showing 1 decimal
		["SLIDER",[localize "STR_CROWSEW_Zeus_addradiochatter_freq_max", localize "STR_CROWSEW_Zeus_addradiochatter_freq_max_tooltip"],[_signalRange#0,_signalRange#1,_half+10,1]], //60 to 250, default 221 and showing 1 decimal
		["SLIDER",localize "STR_CROWSEW_Zeus_addradiochatter_range",[1,10000,2000,0]], //1 to 10000, default 2000 and showing 0 decimal
		["SLIDER",[localize "STR_CROWSEW_Zeus_addradiochatter_duration_min", localize "STR_CROWSEW_Zeus_addradiochatter_duration_min_tooltip"],[4,40,5,0]], //1 to 40, default 5 and showing 0 decimal
		["SLIDER",[localize "STR_CROWSEW_Zeus_addradiochatter_duration_max", localize "STR_CROWSEW_Zeus_addradiochatter_duration_max_tooltip"],[4,100,30,0]], //1 to 100, default 30 and showing 0 decimal
		["SLIDER",[localize "STR_CROWSEW_Zeus_addradiochatter_pause_min", localize "STR_CROWSEW_Zeus_addradiochatter_pause_min_tooltip"],[1,40,5,0]], //1 to 40, default 5 and showing 0 decimal
		["SLIDER",[localize "STR_CROWSEW_Zeus_addradiochatter_pause_max", localize "STR_CROWSEW_Zeus_addradiochatter_pause_max_tooltip"],[1,100,10,0]] //1 to 100, default 30 and showing 0 decimal
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;