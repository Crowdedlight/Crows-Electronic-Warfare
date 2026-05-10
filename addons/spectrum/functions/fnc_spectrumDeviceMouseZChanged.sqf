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

systemChat format ["scroll: %1", _scroll];

// only if spectrum display is open with right-click... figure out how to detect if that gui is active
if (cameraView != "Gunner" || !GVAR(spectrumCtrlKeyDown)) exitWith {};

// if reset we should reset values. 
private _newMinFreq = 0;
private _newMaxFreq = 0;


// get current selected freq
private _fmin = missionNamespace getVariable ["#EM_FMin", 0];
private _fmax = missionNamespace getVariable ["#EM_FMax", 0];
private _span = _fmax - _fmin;
private _selMin = missionNamespace getVariable ["#EM_SelMin", 0];
private _selMax = missionNamespace getVariable ["#EM_SelMax", 0];

// adjust min+max values
_newMinFreq = _fmin + _span/20 * _scroll ;
_newMaxFreq = _fmax - _span/20 * _scroll ;


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
