#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_listenToRadioStart.sqf
Parameters: 
Return: none

// ONLY TESTED WITH TFAR Beta

*///////////////////////////////////////////////
params ["_unit"];

if (isNull _unit) exitWith {};

// get settings from signal unit - [_radio, _radioType, _freq, _radioCode]
private _settings = _unit getVariable [QGVAR(broadcastingRadio), []];

if (count _settings == 0) exitWith {};

// check if custom SDR radio is in uniform, vest or backpack. Use TFARs "radioItems" and then go through list and check if our icom radio?  idea: https://github.com/michail-nikolaev/task-force-arma-3-radio/blob/1.0/addons/core/functions/fnc_getRadioItems.sqf 
private _radioItems = [player] call TFAR_fnc_getRadioItems;
private _icom = "";
{
	// try and get config
	private _config = getNumber(configfile >> "CfgWeapons" >> _x >> "crowsEW_icom");
	if (_config == 1) exitWith {_icom = _x;};

} forEach _radioItems;

// if no Icom we exit
if (_icom == "") exitWith {
	playSound "radioError";
};

// if radio is present, set settings on it identical to signal. (frequency and radioCode). Save default, as we reset when we are not listening. (To stop people from using that radio to broadcast now)
_settings params["_targetRadio", "_targetRadioType", "_targetFreq", "_targetCode"];
[_icom, format["%1", _targetFreq]] call TFAR_fnc_setSwFrequency;
[_icom, _targetCode] call TFAR_fnc_setSwRadioCode;

private _debugCode = _icom call TFAR_fnc_getSwRadioCode;
private _debugfreq = _icom call TFAR_fnc_getSwFrequency;

// TODO remove debugging
systemChat str(_debugCode);
systemChat str(_debugfreq);

// set that we are listening
GVAR(listeningToIcom) = true;
