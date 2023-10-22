#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Landric
			   
File: fnc_drawSpectrumLine.sqf
Parameters: colour - string corresponding to a colour in CfgMarkerColors
Return: 

Script to automatically draw a line on the map in the direction they are facing, labelled with the current freq. of the Spectrum Device
Player must have the Spectrum Device equipped, be in "GUNNER" (i.e. zoomed-in) view, and have a GPS (or UAV terminal) assigned

*///////////////////////////////////////////////

params [["_colour", "ColorBlack", [""]]];

if(!(
		GVAR(spectrumAutoline) &&
		(currentWeapon player) isKindOf ["hgun_esd_01_F", configFile >> "CfgWeapons"] &&
		(
			(player getSlotItemName 612) isKindOf ["ItemGPS", configFile >> "CfgWeapons"] ||
			(player getSlotItemName 612) isKindOf ["UavTerminal_base", configFile >> "CfgWeapons"]
		) &&
		cameraOn == player && cameraView == "GUNNER"
	)
) exitWith { false };

if(!isClass (configFile >> "CfgMarkerColors" >> _colour)) then { _colour = "ColorBlack"; };

private _freq = ((missionnamespace getVariable ["#EM_SelMin", 141.6]) + (missionnamespace getVariable ["#EM_SelMax", 141.9]))/2;
_freq = (round (_freq*10))/10;

private _marker = createMarkerLocal ["_USER_DEFINED"+(getPlayerUID player)+str(getPos player)+str(getDir player)+str(_freq), player, currentChannel, player];
_marker setMarkerShapeLocal "polyline";
_marker setMarkerColorLocal _colour;


private _length = 10000; // TODO: base on size of map?

private _pos = [[[position player, GVAR(spectrumAutolineNoise)]]] call BIS_fnc_randomPos;

private _x1 = _pos # 0;
private _y1 = _pos # 1;
private _x2 = _x1+(_length*sin(getDir player));
private _y2 = _y1+(_length*cos(getDir player));

_marker setMarkerPolyline [_x1, _y1, _x2, _y2];

private _x3 = _x1+(50*sin((getDir player)+20));
private _y3 = _y1+(50*cos((getDir player)+20));

_marker = createMarkerLocal ["_USER_DEFINED"+(getPlayerUID player)+str(getPos player)+str(getDir player)+str(_freq)+"label", [_x3, _y3], currentChannel, player];
_marker setMarkerColorLocal _colour;
_marker setMarkerTextLocal ((str _freq) + "MHz");
_marker setMarkerType "hd_dot";

true