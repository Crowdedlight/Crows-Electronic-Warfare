#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_setSpectrumFreq.sqf
Parameters: min, max
Return: 

Sets the min and max of frequency and the span that should be "selectable". 

*///////////////////////////////////////////////

params ["_minFreq", "_maxFreq"];

missionNamespace setVariable ["#EM_FMin", _minFreq];
missionNamespace setVariable ["#EM_FMax", _maxFreq];

// calculate the span for selected band graphics 
// 0.5/10 of span 
private _span = 0.1 max ((_maxFreq - _minFreq) * 0.05);

missionNamespace setVariable ["#EM_SelMin", _minFreq];
missionNamespace setVariable ["#EM_SelMax", (_minFreq + _span)];
