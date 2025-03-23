#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_removeBeaconServer.sqf
Parameters: _unit            object that has the signal, which needs removing, currently attached
            _signalType      type of signal that shall be removed (e.g. "drone" or "sweep_radio" etc.); if this is not set, all types of signals will be removed
Return: none

remove signal source from object 
SERVER ONLY

*///////////////////////////////////////////////
params ["_unit",  ["_signalType", "", ["strings_only"]]];

// if object is null, exitwith. Can happen if we get event as JIP but object has been removed
if (isNull _unit) exitWith {};

// define search behaviour for deletion candidates
private _findCode = { _x#0 == _unit };
if (_signalType != "") then {
	_findCode = { _x#0 == _unit && { _x#3 == _signalType } };	// look for specific signal type
};

// find object in array
while { true } do
{
	private _rmIndex = GVAR(beacons) findIf _findCode;
	GVAR(beacons) deleteAt _rmIndex;	

	// breakout clause
	if (_rmIndex == -1) then {
		break;
	};
};

// push update
[QGVAR(updateBeacons), [GVAR(beacons)]] call CBA_fnc_globalEvent;