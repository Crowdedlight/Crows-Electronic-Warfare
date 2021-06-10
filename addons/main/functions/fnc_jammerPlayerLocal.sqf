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
if (count GVAR(jamlist) == 0) exitWith {};

// check all jammers if alive, and remove those that arent. Do this first, to ensure the destruction or deactivation always works
private _jamRemoveList = [];
{
	// if object not alive, add to deletion list 
	if (_x == objNull || !alive _x) then {
		// remove
		_jamRemoveList pushBack _x;

		// remove marker from map, if zeus. TODO if its deleted the marker doesn't get removed as obj is null, and thus the variable for the markers aren't there... Consider adding marker var to array as [_jammer, _marker] instead. 
		if (call FUNC(isZeus)) then {
			[_x] call FUNC(removeJamMarker);
		};
	};
} forEach GVAR(jamlist);

// update list of alive jammers
GVAR(jamlist) = GVAR(jamlist) - _jamRemoveList;

//IF ZEUS, DON'T JAM...update markers and skip.
if (call EFUNC(zeus,isZeus)) then {
	// update markers 
	{
		[_x, true] call FUNC(updateJamMarker);
	} forEach GVAR(jamlist);

	// TODO uncomment, currently commented out for testing purpose
	// continue;
};

// find nearest jammer within range
private _nearestJammer = objNull;
private _distJammer = -1;
private _distRad = -1;
{
	// if disabled, skip the jammer 
	private _jammingEnabled = _x getVariable [QGVAR(jamming_enabled), false];
	if (!_jammingEnabled) then {continue};

	// get current dist 
	private _dist = player distance _x;

	// get set radius - If something has gone wrong setting the variable it returns -1, and the jammer won't work then
	private _rad = _x getVariable [QGVAR(jamming_radius), -1];

	// if distance to object is bigger than radius of jammer, continue 
	if (_dist > _rad) then {continue;};

	// we are now within jammer area, if this jammer is closer than previous jammers, we save it
	if (_distJammer == -1 || _distJammer > _dist) then {
		_distJammer = _dist;
		_distRad = _rad;
		_nearestJammer = _x;
	};
} forEach GVAR(jamlist);

// if no jammer are within range, go sleep and repeat
if (_nearestJammer == objNull) then {
	// reset values of TFAR, if they are degraded
	[player] call FUNC(resetTfarIfDegraded);
	continue; //skip jamming calcs
};

// we now got distance, and nearest jammer, time to calculate jamming
private _distPercent = _distJammer / _distRad;
private _jamStrength = _nearestJammer getVariable [QGVAR(jamming_strength), 0];
private _rxInterference = 1;
private _txInterference = 1;

// for now staying with linear degradation of signal. Might make it a tad better for players than the sudden commms -> no comms exponential could induce
private _rxInterference = _jamStrength - (_distPercent * _jamStrength) + 1; 	// recieving interference. above 1 to have any effect.
private _txInterference = 1 / _rxInterference; 									//transmitting interference, below 1 to have any effect.

// Set the TF receiving and sending distance multipliers
player setVariable ["tf_receivingDistanceMultiplicator", _rxInterference];
player setVariable ["tf_sendingDistanceMultiplicator", _txInterference];

//Debugging loaned for now from "Jam Radios script for TFAR created by Asherion and Rebel"
if (true) then {	
	// systemChat format ["Distance: %1, Percent: %2", _distJammer,  100 * _distPercent];
	systemChat format ["tfar_rx: %1, tfar_tx: %2", _rxInterference, _txInterference];
	// systemChat format ["Closest Jammer: %1", _nearestJammer];
};