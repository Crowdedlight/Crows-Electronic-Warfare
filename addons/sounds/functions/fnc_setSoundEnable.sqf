#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_setSoundEnable.sqf
Parameters: _unit, _enabled
Return: none

set enabled on the sound placed on the unit. Mainly used for on/off sounds with add-actions

*///////////////////////////////////////////////
params ["_unit", "_enabled"];

// if object is null, exitwith. Can happen if we get event as JIP but object has been removed
if (isNull _unit) exitWith {};

// find object in array
private _index = GVAR(soundList) findIf { (_x select 0) == _unit};

private _soundEle = (GVAR(soundList) select _index);
_soundEle set [6, _enabled];
