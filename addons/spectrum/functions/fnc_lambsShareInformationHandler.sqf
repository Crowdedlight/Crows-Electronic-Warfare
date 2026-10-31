#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: b-mayr-1984 - Bernhard Mayr
			   
File: fnc_lambsShareInformationHandler.sqf
Parameters: 
 * 0: unit sharing information <OBJECT>
 * 1: enemy target <OBJECT>
 * 2: range to share information, default 350 <NUMBER>
 * 3: override radio ranges, default false <BOOLEAN>
 * 4: group member doing the actual radio call <OBJECT>
 * 5: sharing range after adjusting for radio ranges <NUMBER> 	
 * 6: unit has a long range radio <BOOLEAN>

Return: false     in order to not suppress information sharing in LAMBS

This script implements an event handler for events send by LAMBS_Danger.fsm.
see https://github.com/nk3nny/LambsDanger/blob/master/addons/main/functions/fnc_addShareInformationHandler.sqf

It is used to let AI units send radio signals whenever they share information via radio.

*///////////////////////////////////////////////

params [["_unit",     objNull, [objNull]], 
		["_target",   objNull, [objNull]], 
		["_range",    350,     [1337]], 
		["_override", false,   [true]], 
		["_newUnit",  objNull, [objNull]], 
		["_newRange", 350,     [1337]],
		["_radio",    false,   [true]]];


diag_log format ["%1, %2, %3", _unit, _newRange, _radio]; 	// debug output

// private _inventoryRadio = "ItemRadio" in (assignedItems _unit);		// check if AI has has a SR radio equipped
// private _hasRadio = _radio || _inventoryRadio;

private _transmitEM = (_newRange > 150);	// radio is assumed if communication range is larger than 150m
if (_transmitEM) then {
	private _minFreq = GVAR(spectrumDeviceFrequencyRange)#0#0;
	private _maxFreq = GVAR(spectrumDeviceFrequencyRange)#0#1;
	if (_radio) then { _maxFreq = 87; };	// if unit has LR radio, limit max frequency to 87MHz (TFAR LR radio range)

	private _sideId = (side _unit) call BIS_fnc_sideID;
	private _frequency = _minFreq + ((_sideId + missionStart#5) random (_maxFreq-_minFreq));	// use side as seed to have transmit frequency be unique per side

	// spawn function to start signal, wait and then stop signal
	[_unit, _frequency, _newRange, [ 0.7, "\A3\Dubbing_Radio_F\Sfx\in2c.ogg", selectRandom GVAR(garbledRadioCommsSounds), "\A3\Dubbing_Radio_F\Sfx\out2c.ogg"], false] remoteExec [QFUNC(addsoundsequenceserver), 2];
};

false; // return false to not suppress information sharing in LAMBS
