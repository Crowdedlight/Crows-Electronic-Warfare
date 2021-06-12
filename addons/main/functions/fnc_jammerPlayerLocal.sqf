#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_jammerPlayerLocal.sqf
Parameters: 
Return: none

main script that handles the jamming whenever there is at least 1 active jammer

*///////////////////////////////////////////////

// if on server or headless, stop execution
if (!hasInterface) exitWith {};
// if no jammers exit
if (count GVAR(jamMap) == 0) exitWith {};

// check all jammers if alive, and remove those that arent. Using list to not modify the map while we are iterating it
private _removeList = [];
{
	// get jammer obj
    _y params ["_jamObj"];

	// if object not alive, add to deletion list 
	if (_jamObj == objNull || !alive _jamObj) then {
		// add key to remove list 
		_removeList pushBack _x;
		
		// remove marker from map, if zeus. TODO if its deleted the marker doesn't get removed as obj is null, and thus the variable for the markers aren't there... Consider adding marker var to array as [_jammer, _marker] instead. 
		if (call FUNC(isZeus)) then {
			// remove marker based on netID
			[_x] call FUNC(removeJamMarker);
		};
	};
} forEach GVAR(jamMap);

{
	// remove from hashmap
	GVAR(jamMap) deleteAt _x;
} forEach _removeList;


//IF ZEUS, DON'T JAM...update markers and skip.
if (call EFUNC(zeus,isZeus)) then {
	// update markers 
	{
		_y params ["_jamObj", "_radius", "_strength", "_enabled"];

		// jamObj, netId, radius
		[_jamObj, _x, _radius, true] call FUNC(updateJamMarker);
	} forEach GVAR(jamMap);

	// TODO uncomment, currently commented out for testing purpose, Zeus should not be jammed
	// continue;
};

// find nearest jammer within range
private _nearestJammer = [objNull];
private _distJammer = -1;
private _distRad = -1;
{
	_y params ["_jamObj", "_radius", "_strength", "_enabled"];

	// if disabled, skip the jammer 
	if (!_enabled) then {continue};

	// get current dist 
	private _dist = player distance _jamObj;

	// if distance to object is bigger than radius of jammer, continue 
	if (_dist > _radius) then {continue;};

	// we are now within jammer area, if this jammer is closer than previous jammers, we save it
	if (_distJammer == -1 || _distJammer > _dist) then {
		_distJammer = _dist;
		_distRad = _radius;
		_nearestJammer = _y;
	};
} forEach GVAR(jamMap);

diag_log _nearestJammer;
private _nearestJammerObject = (_nearestJammer select 0);

// if no jammer are within range, reset tfar vars and exit
if (isNull _nearestJammerObject) then {
	// reset values of TFAR, if they are degraded
	[player] call FUNC(resetTfarIfDegraded);
	exit; //skip jamming calcs
};

// we now got distance, and nearest jammer, time to calculate jamming
private _distPercent = _distJammer / _distRad;
private _jamStrength = _nearestJammer select 2;
private _rxInterference = 1;
private _txInterference = 1;

// for now staying with linear degradation of signal. Might make it a tad better for players than the sudden commms -> no comms exponential could induce
private _rxInterference = _jamStrength - (_distPercent * _jamStrength) + 1; 	// recieving interference. above 1 to have any effect.
private _txInterference = 1 / _rxInterference; 									// transmitting interference, below 1 to have any effect.

// Set the TF receiving and sending distance multipliers
player setVariable ["tf_receivingDistanceMultiplicator", _rxInterference];
player setVariable ["tf_sendingDistanceMultiplicator", _txInterference];

//Debugging
if (true) then {	
	// systemChat format ["Distance: %1, Percent: %2", _distJammer,  100 * _distPercent];
	systemChat format ["tfar_rx: %1, tfar_tx: %2", _rxInterference, _txInterference];
	systemChat format ["Closest Jammer netID: %1, radius: %2, enabled: %3", netId (_nearestJammer select 0), _nearestJammer select 1, _nearestJammer select 3];
};