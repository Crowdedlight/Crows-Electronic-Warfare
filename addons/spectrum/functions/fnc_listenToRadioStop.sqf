#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_listenToRadioStop.sqf
Parameters: none
Return: none

// ONLY TESTED WITH TFAR Beta

*///////////////////////////////////////////////

// get icom 
private _radioItems = [player] call TFAR_fnc_getRadioItems;
private _icom = "";
{
	// try and get config
	private _config = getNumber(configfile >> "CfgWeapons" >> _x >> "crowsEW_icom");
	if (_config == 1) exitWith {_icom = _x;};

} forEach _radioItems;

// if no Icom we exit
if (_icom == "") exitWith {};

// stop listen to radio
[_icom, format["%1", "100"]] call TFAR_fnc_setSwFrequency;
[_icom, "crowsEW_icom_code"] call TFAR_fnc_setSwRadioCode;

GVAR(listeningToIcom) = false;
