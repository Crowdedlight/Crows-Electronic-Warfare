#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: b-mayr-1984 - Bernhard Mayr 
		using code from Crowdedlight
			   
File: fnc_spectrumDeviceMouseZChanged.sqf
Parameters: scroll increment of mouse wheel
Return: 

Called on event for mouse wheel

*///////////////////////////////////////////////
params ["_displayOrControl", "_scroll"];

// systemChat format ["scroll: %1", _scroll];	// debug output

// only if spectrum display is open with right-click... figure out how to detect if that gui is active
if (cameraView != "Gunner" || !GVAR(spectrumCtrlKeyDown)) exitWith {};

private _zoomIncrement = 0.2;	// how much to zoom in or out with each scroll, as a percentage of the current span

// get current selected freq
private _fmin = missionNamespace getVariable ["#EM_FMin", 0];
private _fmax = missionNamespace getVariable ["#EM_FMax", 0];
private _selMin = missionNamespace getVariable ["#EM_SelMin", 0];
private _selMax = missionNamespace getVariable ["#EM_SelMax", 0];
private _selCenter = (_selMin + _selMax) / 2;	// center of selected frequencies
private _leftOfSelection = (_selMin - _fmin) max 0;
private _rightOfSelection = (_fmax - _selMax) max 0;

// adjust x-axis min+max values
private _newMinFreq = _fmin + _leftOfSelection * _zoomIncrement * _scroll ;
private _newMaxFreq = _fmax - _rightOfSelection * _zoomIncrement * _scroll ;
private _newSpan = _newMaxFreq - _newMinFreq;
private _newSelSpan = _newSpan/20;	// make selection span 1/20 of total span

// adjust selection min+max values
private _newSelMin = (_selCenter - _newSelSpan/2) max _fmin;
private _newSelMax = (_selCenter + _newSelSpan/2) min _fmax;

// don't zoom out beyond maximum range of antenna
if (_scroll < 0) then {
	private _muzzleAttachment = (handgunItems GVAR(trackerUnit)) select 0;	// get antenna

	// restrict values to antenna range
	private _resultArr = [_muzzleAttachment] call FUNC(getSpectrumDefaultFreq);
	_resultArr params ["_minFreq", "_maxFreq", "_selectedAntenna"];
	_newMinFreq = _newMinFreq max _minFreq;
	_newMaxFreq = _newMaxFreq min _maxFreq;
};


// set new freqs
missionNamespace setVariable ["#EM_FMin", _newMinFreq];
missionNamespace setVariable ["#EM_FMax", _newMaxFreq];
missionNamespace setVariable ["#EM_SelMin", _newSelMin];
missionNamespace setVariable ["#EM_SelMax", _newSelMax];
