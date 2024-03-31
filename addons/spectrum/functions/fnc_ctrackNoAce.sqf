#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_ctrackNoAce.sqf
Parameters: _unit
Return: none

*///////////////////////////////////////////////
// GUI selection 
GVAR(ctrackAskFreqOnConfirmNoAce) =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_freq"
	];
	//Get in params again
	_in params [["_unit",objNull,[objNull]]];

	// non-ace is hardcoded to 5km for now
	// broadcast event to all clients and JIP	
	[QGVAR(addBeacon), [_unit, _freq, 5000, "ctrack"]] call CBA_fnc_serverEvent;

	// save variable on unit 
	_unit setVariable[QGVAR(ctrack_attached_frequency), _freq, true];
};

GVAR(AskFreqCtrack) = {
	// get range from GVAR
	private _signalRange = GVAR(spectrumDeviceFrequencyRange)#1;
	private _half = abs(_signalRange#1 - _signalRange#0)/2;
	[
		"Frequency for Tracker", 
		[
			["SLIDER","Frequency (Unique)",[_signalRange#0,_signalRange#1,_half,1]] //390 to 500, default 460 and showing 1 decimal
		],
		GVAR(ctrackAskFreqOnConfirmNoAce),
		{},
		_this
	] call zen_dialog_fnc_create;
};

// function to check if ctrack is in inventory
GVAR(hasCtrackCondition) = {
	// check for item in inventory
	params ["_caller"];

	private _unitUniqueItems = uniqueUnitItems [_caller, 0, 2, 2, 0, false];
	private _ctrackNum = _unitUniqueItems getOrDefault ["crowsew_ctrack", 0];
	(_ctrackNum > 0)
};

GVAR(hasVehicleInFrontCondition) = {
	params ["_caller"];
	// return true if player is looking at vehicle in front of them
	((!isNull cursorTarget) && { (cursorTarget distance _caller < 5) && {!(cursorTarget isKindOf "CAManBase")}})
};

GVAR(hasBeaconAlreadyCondition) = {
	params ["_caller"];
	((_caller getVariable[QGVAR(ctrack_attached_frequency), 0]) != 0)
};

GVAR(targetHasBeaconAlreadyCondition) = {
	params ["_caller"];
	private _target = cursorTarget;
	((_target getVariable[QGVAR(ctrack_attached_frequency), 0]) != 0)
};

// function for attaching 
GVAR(ctrackAttachToSelf) = {
	params ["_target", "_caller", "_actionId", "_arguments"];

	// add beacon to self
	[_caller] call GVAR(AskFreqCtrack);

	// remove item from _caller
	_caller removeItem "crowsew_ctrack";
};
GVAR(ctrackAttachToTarget) = {
	params ["_target", "_caller", "_actionId", "_arguments"];

	// get vehicle player is pointing at
	private _target = cursorTarget;

	// add beacon
	[_target] call GVAR(AskFreqCtrack);

	// remove item from _caller
	_caller removeItem "crowsew_ctrack";
};

GVAR(ctrackDetachFromSelf) = {
	params ["_target", "_caller", "_actionId", "_arguments"];

	//detach from self by removing the beacon
	[QGVAR(removeBeacon), [_caller]] call CBA_fnc_serverEvent;

	// add item back into inventory 
	_caller addItem "crowsew_ctrack";

	// remove local var 
	_caller setVariable[QGVAR(ctrack_attached_frequency), 0, true];
};
GVAR(ctrackDetachFromTarget) = {
	params ["_target", "_caller", "_actionId", "_arguments"];

	// get vehicle player is pointing at
	_target = cursorTarget;

	//detach from target by removing the beacon
	[QGVAR(removeBeacon), [_target]] call CBA_fnc_serverEvent;

	// add item back into inventory 
	_caller addItem "crowsew_ctrack";

	// remove local var 
	_target setVariable[QGVAR(ctrack_attached_frequency), 0, true];
};

// add scroll wheel for "attaching ctrack to target" and "attaching ctrack to self". 
player addAction ["<t color=""#7fd7f5"">Attach Ctrack to self", {_this call GVAR(ctrackAttachToSelf);}, nil, 1, false, true, "", QUOTE(([_this] call GVAR(hasCtrackCondition)) && {!([_this] call GVAR(hasBeaconAlreadyCondition))})];
// add scroll wheel for "detaching ctrack from self"
player addAction ["<t color=""#7fd7f5"">Detach Ctrack from self", {_this call GVAR(ctrackDetachFromSelf);}, nil, 1, false, true, "", QUOTE([_this] call GVAR(hasBeaconAlreadyCondition))];

// add scroll wheel for adding ctrack to vehicles/objects
player addAction ["<t color=""#30f0a9"">Attach Ctrack to Vehicle", {_this call GVAR(ctrackAttachToTarget);}, nil, 1, false, true, "", QUOTE(([_this] call GVAR(hasCtrackCondition)) && { ([_this] call GVAR(hasVehicleInFrontCondition)) && {!([_this] call GVAR(targetHasBeaconAlreadyCondition))}})];
// add scroll wheel for detaching ctrack to vehicles/objects
player addAction ["<t color=""#30f0a9"">Detach Ctrack from Vehicle", {_this call GVAR(ctrackDetachFromTarget);}, nil, 1, false, true, "", QUOTE(([_this] call GVAR(hasVehicleInFrontCondition)) && {([_this] call GVAR(targetHasBeaconAlreadyCondition))})];

