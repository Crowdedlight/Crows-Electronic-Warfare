#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: b-mayr-1984 - Bernhard Mayr 
		using code from Crowdedlight
			   
File: fnc_spectrumDeviceMouseZChanged.sqf
Parameters: as per https://community.bistudio.com/wiki/User_Interface_Event_Handlers#onMouseZChanged
Return: 	none

Called on event for mouse wheel

*///////////////////////////////////////////////
params ["_displayOrControl", "_scroll"];

// only if spectrum display is open with right-click... figure out how to detect if that gui is active
if (cameraView != "Gunner" || {!GVAR(spectrumCtrlKeyDown) && !GVAR(spectrumShiftKeyDown)}) exitWith {};

systemChat format ["scroll: %1", _scroll];	// debug output

private _spanIncrement = 0.2;	// how much to zoom/pan with each scroll, as a percentage of the current span (before _scroll is multiplied in)

// get current selected freq
private _fmin = missionNamespace getVariable ["#EM_FMin", 0];
private _fmax = missionNamespace getVariable ["#EM_FMax", 0];
private _selMin = missionNamespace getVariable ["#EM_SelMin", 0];
private _selMax = missionNamespace getVariable ["#EM_SelMax", 0];

// initialize new values with current values
private _newMinFreq = _fmin;
private _newMaxFreq = _fmax;
private _newSelMin = _selMin;
private _newSelMax = _selMax;


// zoom handling via Ctrl+mouse-wheel
if ( GVAR(spectrumCtrlKeyDown) ) then {
	private _selCenter = (_selMin + _selMax) / 2;	// center of selected frequencies
	private _leftOfSelection = (_selMin - _fmin) max 0;
	private _rightOfSelection = (_fmax - _selMax) max 0;

	// adjust x-axis min+max values
	_newMinFreq = _fmin + _leftOfSelection * _spanIncrement * _scroll;
	_newMaxFreq = _fmax - _rightOfSelection * _spanIncrement * _scroll;
	private _newSpan = _newMaxFreq - _newMinFreq;
	private _newSelSpan = _newSpan/20;	// make selection span 1/20 of total span

	// adjust selection min+max values
	_newSelMin = (_selCenter - _newSelSpan/2) max _fmin;
	_newSelMax = (_selCenter + _newSelSpan/2) min _fmax;
};

// pan handling via Shift+mouse-wheel
if ( GVAR(spectrumShiftKeyDown) ) then {
	private _span = _newMaxFreq - _newMinFreq;
	private _offset = (_span * _spanIncrement * _scroll)/2;
	_newMinFreq = _fmin + _offset;
	_newMaxFreq = _fmax + _offset;
};


// don't zoom/pan beyond maximum range of antenna
if ( GVAR(spectrumShiftKeyDown) || _scroll < 0) then {
	private _muzzleAttachment = (handgunItems GVAR(trackerUnit)) select 0;	// get antenna

	// restrict values to antenna range
	private _resultArr = [_muzzleAttachment] call FUNC(getSpectrumDefaultFreq);
	_resultArr params ["_minFreq", "_maxFreq", "_selectedAntenna"];
	_newMinFreq = _newMinFreq max _minFreq;
	_newMaxFreq = _newMaxFreq min _maxFreq;
};


// workaround for odd behaviour while paning; 
// vanilla Arma seems to shift the selection after our function call, so we need to compensate for that
[{
	params ["_newMinFreq", "_newMaxFreq", "_newSelMin", "_newSelMax"];
	missionNamespace setVariable ["#EM_FMin", _newMinFreq];
	missionNamespace setVariable ["#EM_FMax", _newMaxFreq];
	missionNamespace setVariable ["#EM_SelMin", _newSelMin];
	missionNamespace setVariable ["#EM_SelMax", _newSelMax];
	// systemChat format ["FMin: %1, FMax: %2, SelMin: %3, SelMax: %4", _newMinFreq, _newMaxFreq, _newSelMin, _newSelMax];		// debug output
}, [_newMinFreq, _newMaxFreq, _newSelMin, _newSelMax], 5] call cba_fnc_execAfterNFrames;
