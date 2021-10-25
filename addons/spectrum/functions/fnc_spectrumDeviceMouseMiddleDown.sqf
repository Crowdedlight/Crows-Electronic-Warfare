#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_spectrumDeviceMouseMiddleDown.sqf
Parameters: shift
Return: 

Called on event for mouseDown

*///////////////////////////////////////////////
params ["_shift"];

// only if spectrum display is open with right-click... figure out how to detect if that gui is active
if (cameraView != "Gunner") exitWith {};

// if reset we should reset values. 
private _newMinFreq = 0;
private _newMaxFreq = 0;

if (_shift) then {
	// get antenna 
	private _muzzleAttachment = (handgunItems GVAR(trackerUnit)) select 0;
	// set values to default antenna
	private _resultArr = [_muzzleAttachment] call FUNC(getSpectrumDefaultFreq);
	_resultArr params ["_minFreq", "_maxFreq", "_selectedAntenna"];
	_newMinFreq = _minFreq;
	_newMaxFreq = _maxFreq;
} else {
	// get current selected freq
	private _selMin = missionNamespace getVariable ["#EM_SelMin", 0];
	private _selMax = missionNamespace getVariable ["#EM_SelMax", 0];

	// offset - 0.5/10 of new span
	private _offset = (_selMax - _selMin) *0.05;

	// set min+max to current selected freq +- offset
	_newMinFreq = _selMin - _offset;
	_newMaxFreq = _selMax + _offset;
};

// set new freqs
[_newMinFreq, _newMaxFreq] call FUNC(setSpectrumFreq);
