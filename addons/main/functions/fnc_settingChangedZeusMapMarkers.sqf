#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_settingChangedZeusMapMarkers.sqf
Parameters: value
Return: none

removes all local markers for jammers. Used to clear map if zeus setting is changed mid mission

*///////////////////////////////////////////////
params ["_value"];

// if we enable, we get the markers on next update loop anyway
if (_value) exitWith {};

// otherwise if disabled, we got to clear all existing map markers
private _netIDs = keys GVAR(jamMap);

[_netIDs] call FUNC(removeJamMarkers); 