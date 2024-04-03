#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: b-mayr-1984 - Bernhard Mayr & Crowdedlight
			   
File: fnc_jammerServerLoop.sqf
Parameters:	none
Return: 	n.a.

Runs the server-side loop handling jamming effects that 
can't be dealt with locally on client-side.

It is mostly used to stop drones that are not controlled by a player.
Player controlled drones are handled in fnc_jammerPlayerLocal.sqf.

*///////////////////////////////////////////////

/////////////////////////////
/// Jammer Cleanup part ///
/////////////////////////////

// check all jammers if alive, and remove those that aren't. Using list to not modify the map while we are iterating it
private _removeList = [];
{
	// get jammer obj
    _y params ["_jamObj"];

	// if object not alive, add to deletion list 
	if (isNull _jamObj || !alive _jamObj) then {
		// add object to remove list 
		_removeList pushBack _x;
	};
} forEach GVAR(jamMap);

// remove all jammers from remove list
[_removeList] call FUNC(removeJammerArrayServer);

/////////////////////////////
/// Drone AI Jamming part ///
/////////////////////////////

// GVAR(jamMap) is made of [_netId, [_unit, _rad, _strength, _enabled, _capabilities]];
private _allDroneJammers = (values GVAR(jamMap)) select { JAM_CAPABILITY_DRONE in _x#4 };	// keep jammers that have the JAM_CAPABILITY_DRONE capability
if (count _allDroneJammers == 0) exitWith {};	// there are no "DroneJammers"

// QEGVAR(spectrum,beacons) is made of [_unit, _frequency, _scanRange, _type];
private _jammableDrones = EGVAR(spectrum,beacons) select { _x#3 == "drone" };	// keep drone signals/beacons
if (count _jammableDrones == 0) exitWith {};	// there are no drones to jam

// check every jammable drone against every DroneJammer
{
	// set jamming status if in range
	_x params ["_unit", "_frequency", "_scanRange", "_type"]; 
	private _jammersInRange = _allDroneJammers select { (_unit distance _x#0) < (_x#2) };	// this _x is different to _x the code line above

	{
		_x params ["_jammer", "_radFalloff", "_radEffective", "_enabled", "_capabilities"];	// and this is yet another _x
		[_unit, _enabled, _jammer] call EFUNC(spectrum,toggleJammingOnUnit);
	} forEach _jammersInRange;

	// reset any jamming status if jammer or drone moves out of range
	private _activeJammers = _unit getVariable[QEGVAR(spectrum,activeJammingObjects), []];
	if (count _activeJammers > 0) then {
		private _jammersOutOfRange = _allDroneJammers - _jammersInRange;
		private _rmArr = [];
		{
			_x params ["_jammer", "_radFalloff", "_radEffective", "_enabled", "_capabilities"];
			_rmArr pushBack _jammer;
		} forEach _jammersOutOfRange;

		_activeJammers = _activeJammers - _rmArr;
		_activeJammers = _activeJammers arrayIntersect _activeJammers;	// remove duplicates and leave only unique items
		_unit setVariable [QEGVAR(spectrum,activeJammingObjects), _activeJammers];
	};

} forEach _jammableDrones;
