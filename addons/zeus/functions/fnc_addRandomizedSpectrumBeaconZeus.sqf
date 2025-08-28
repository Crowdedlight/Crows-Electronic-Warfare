#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_addRandomizedSpectrumBeaconZeus.sqf
Parameters: pos, _unit
Return: none

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//ZEN dialog
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_freqMin",
		"_freqMax",
		"_rangeMin",
		"_rangeMax"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
	
	// if object is null, we can't start the jamming
	if (_unit == objNull) exitWith {hint localize "STR_CROWSEW_Zeus_error_signal";};

	private _freqMid = round(((_freqMax - _freqMin)/2) + _freqMin);
	private _rangeMid = round(((_rangeMax - _rangeMin)/2) + _rangeMin);

	// get random freq and range within range 
	private _freq = floor(random[_freqMin, _freqMid, _freqMax]);
	private _range = floor(random[_rangeMin, _rangeMid, _rangeMax]);

	// broadcast event to server
	[QEGVAR(spectrum,addBeacon), [_unit, _freq, _range, "zeus"]] call CBA_fnc_serverEvent;
};

// get signal options directly from array to make changes easier in future
private _signalRange = EGVAR(spectrum,spectrumDeviceFrequencyRange)#1;

[
	"Set Spectrum Signal Source", 
	[
		["SLIDER",localize "STR_CROWSEW_Zeus_addradiochatter_freq_min",[_signalRange#0,_signalRange#1,_signalRange#0,1]], //520 to 1090, default half and showing 1 decimal
		["SLIDER",localize "STR_CROWSEW_Zeus_addradiochatter_freq_max",[_signalRange#0,_signalRange#1,_signalRange#1,1]], //520 to 1090, default half and showing 1 decimal
		["SLIDER",localize "STR_CROWSEW_Zeus_range_min",[1,5000,300,0]], //1 to 5000, default 300 and showing 0 decimal
		["SLIDER",localize "STR_CROWSEW_Zeus_range_max",[1,5000,5000,0]] //1 to 5000, default 300 and showing 0 decimal
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;
