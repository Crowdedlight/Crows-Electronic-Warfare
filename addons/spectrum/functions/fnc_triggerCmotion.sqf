#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Landric
			   
File: fnc_triggerCmotion.sqf
Parameters: cMotion - the sensor object (to which the user-defined variables are attached)
Return: none

Trigger the associated C-MOTION

*///////////////////////////////////////////////

params [["_cMotion", objNull]];

if(isNull _cMotion) exitWith { diag_log "crowsEW-spectrum: C-MOTION triggered with no associated sensor"; };

// TODO: check locality - is this detectable by all players?

if(GVAR(cmotionSpectrum)) then {

	private _frequency = _cMotion getVariable [QGVAR(cmotionFreq), nil];
	if(isNil "_frequency") exitWith {};

	[_cMotion, _frequency, GVAR(cmotionSpectrumRange), "cmotion"] call FUNC(addBeacon);
	[_cMotion] spawn {
		params ["_cMotion"];
		private _stopTime = time + GVAR(cmotionSpectrumTime);
		sleep _stopTime;
		[_cMotion] call FUNC(removeBeacon);
	};
};


if(GVAR(cmotionMarker)) then {

	private _markerText = _cMotion getVariable [QGVAR(cmotionMarkerText), nil];
	if(isNil "_markerText") exitWith {};

	private _markerPos = getPos _cMotion;
	private _markerName = format ["_USER_DEFINED_cMotion_%1", _markerPos apply {round _x}];
	private "_marker";
	if(markerType _markerName isEqualTo "") then {
		_marker = createMarkerLocal [_markerName, _markerPos, (_cMotion getVariable QGVAR(cmotionMarkerChannel)), player];
		_marker setMarkerColorLocal (_cMotion getVariable QGVAR(cmotionMarkerColour));
		_marker setMarkerTypeLocal "hd_dot";
	} else {
		_marker = _markerName;
	};
	if((_cMotion getVariable QGVAR(cmotionMarkerTimestamp))) then { _markerText = format ["%1 (%2)", _markerText, ([dayTime] call BIS_fnc_timeToString)]; };
	_marker setMarkerText _markerText;
};


// TODO: prevent overlapping audio?
// TODO: how to prevent repeating audio sounds from becoming annoying? E.g. what if
// an AI patrols on top of the sensor and doesn't move away? A way of remote disabling? Or remove the "flipflop"?

if(GVAR(cmotionAudio)) then {
	private _sound = _cMotion getVariable [QGVAR(cmotionAudio), nil];
	if(isNil "_sound") exitWith {};
	[getPos player, 0, _sound, 1, true] call EFUNC(sounds,playSoundPos)
};
