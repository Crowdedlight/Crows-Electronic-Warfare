#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_setSpectrumFreq.sqf
Parameters: min, max
Return: 

Sets the min and max of frequency and the span that should be "selectable". 

*///////////////////////////////////////////////

params ["_minFreq", "_maxFreq"];

// check for flooring - If we are above current antennas max or min, clamp it
private _antenna = (handgunItems player) select 0;
private _resultArr = [_antenna] call FUNC(getSpectrumDefaultFreq);
_resultArr params ["_minFreqDefault", "_maxFreqDefault", "_selectedAntenna"];

// check and clamp
if (_minFreq < _minFreqDefault) then {_minFreq = _minFreqDefault};
if (_maxFreq > _maxFreqDefault) then {_maxFreq = _maxFreqDefault};

missionNamespace setVariable ["#EM_FMin", _minFreq];
missionNamespace setVariable ["#EM_FMax", _maxFreq];

// calculate the span for selected band graphics 
// 0.5/10 of span 
private _span = 0.1 max ((_maxFreq - _minFreq) * 0.05);

missionNamespace setVariable ["#EM_SelMin", _minFreq];
missionNamespace setVariable ["#EM_SelMax", (_minFreq + _span)];
