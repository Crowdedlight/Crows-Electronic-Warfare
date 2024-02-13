#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: b-mayr-1984 - Bernhard Mayr
			   
File: fnc_jammerServerLoop.sqf
Parameters:	none
Return: 	n.a.

Runs the server-side loop handling jamming effects that 
can't be dealt with locally on client-side.

It is mostly used to stop drones that are not controlled by a player.
Player controlled drones are handled in fnc_jammerPlayerLocal.sqf.

*///////////////////////////////////////////////

// GVAR(jamMap) is made of [_netId, [_unit, _rad, _strength, _enabled, _capabilities]];
private _allDroneJammers = (values GVAR(jamMap)) select { "DroneJammer" in _x#4 };	// keep jammers that have the "DroneJammer" capability
if (count _allDroneJammers == 0) exitWith {};	// there are no "DroneJammers"

// QEGVAR(spectrum,beacons) is made of [_unit, _frequency, _scanRange, _type];
private _jammableDrones = EGVAR(spectrum,beacons) select { _x#3 == "drone" };	// keep drone signals/beacons
if (count _jammableDrones == 0) exitWith {};	// there are no drones to jam

// check every jammable drone against every DroneJammer
{
	_x params ["_unit", "_frequency", "_scanRange", "_type"];
	private _jammersInRange = _allDroneJammers select { (_unit distance _x#0) < _x#1 };	// this _x is different to _x the code line above

	{
		_x params ["_jammer", "_radius", "_strength", "_enabled", "_capabilities"];	// and this is yet another _x
		[_unit, _enabled, _jammer] call EFUNC(spectrum,toggleJammingOnUnit);
	} forEach _jammersInRange;

} forEach _jammableDrones;
