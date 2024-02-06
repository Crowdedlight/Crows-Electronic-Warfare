#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Landric
			   
File: fnc_drawSpectrumLine.sqf
Parameters: colour - int index of a colour in GVAR(spectrumAutolineColours). Must be in CfgMarkerColors.
Return: none

Script to automatically draw a line on the map in the direction they are facing, labelled with the current freq. of the Spectrum Device
Player must have the Spectrum Device equipped, be in "GUNNER" (i.e. zoomed-in) view, and have a GPS (or UAV terminal) assigned

*///////////////////////////////////////////////

params [["_colour", 0, [1]]];

if(!(
		GVAR(spectrumAutoline) &&
		{call FUNC(playerInSpectrumView) &&
		{call FUNC(playerHasGPSCapability)}}
	)
) exitWith { };

_colour = GVAR(spectrumAutolineColours) # _colour;

private _freq = ((missionnamespace getVariable ["#EM_SelMin", 141.6]) + (missionnamespace getVariable ["#EM_SelMax", 141.9]))/2;
_freq = _freq toFixed 1;

private _startPos = [[[position player, GVAR(spectrumAutolineNoise)]]] call BIS_fnc_randomPos;
private _endPos = _startPos getPos [GVAR(spectrumAutolineLength), getDir player];

private _marker_prefix = "_USER_DEFINED"+(getPlayerUID player)+str(getPos player)+str(getDir player)+_freq;
private _marker = createMarkerLocal [_marker_prefix, player, currentChannel, player];
_marker setMarkerShapeLocal "polyline";
_marker setMarkerColorLocal _colour;
_marker setMarkerPolyline [_startPos # 0, _startPos # 1, _endPos # 0, _endPos # 1];

private _labelPos = _startPos getPos [50, (getDir player)+20];
_marker = createMarkerLocal [_marker_prefix+"label", _labelPos, currentChannel, player];
_marker setMarkerColorLocal _colour;
_marker setMarkerTextLocal _freq + " MHz";
_marker setMarkerType "hd_dot";
