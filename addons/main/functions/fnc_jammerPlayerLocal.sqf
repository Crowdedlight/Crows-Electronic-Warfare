#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_jammerPlayerLocal.sqf
Parameters: 
Return: none

main script that handles the jamming whenever there is at least 1 active jammer

*///////////////////////////////////////////////

// if no jammers exit
if (count GVAR(jamMap) == 0) exitWith {};

//IF ZEUS, update markers and skip.
if (call EFUNC(zeus,isZeus)) then {
	// update markers 
	{
		_y params ["_jamObj", "_radius", "_strength", "_enabled", "_capabilities"];

		// jamObj, netId, radius, updating, enabled
		[_jamObj, _x, _radius, true, _enabled] call FUNC(updateJamMarker);
	} forEach GVAR(jamMap);
};

// TFAR Jamming logic - do not run if zeus, as zeus is immune to TFAR jamming only
if (!(call EFUNC(zeus,isZeus))) then {
	// find nearest jammer within range
	private _nearestJammer = [objNull];
	private _distJammer = -1;
	private _distRad = -1;
	{
		_y params ["_jamObj", "_radius", "_strength", "_enabled", "_capabilities"];

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

	private _nearestJammerObject = (_nearestJammer select 0);

	// if no jammer are within range, reset tfar vars and exit
	if (isNull _nearestJammerObject) then {
		// reset values of TFAR, if they are degraded
		[player] call FUNC(resetTfarIfDegraded);
	} else {
		// check for jammer capabilities and counteract signals accordingly
		if ( JAM_CAPABILITY_RADIO in (_nearestJammer select 4) ) then {
			// we now got distance, and nearest jammer, time to calculate jamming
			private _distPercent = _distJammer / _distRad;
			private _jamStrength = _nearestJammer select 2;
			private _rxInterference = 1;
			private _txInterference = 1;

			// for now staying with linear degradation of signal. Might make it a tad better for players than the sudden commms -> no comms exponential could induce
			private _rxInterference = _jamStrength - (_distPercent * _jamStrength) + 1;     // recieving interference. above 1 to have any effect.
			private _txInterference = 1 / _rxInterference;                                  // transmitting interference, below 1 to have any effect.

			// Set the TF receiving and sending distance multipliers
			player setVariable ["tf_receivingDistanceMultiplicator", _rxInterference];
			player setVariable ["tf_sendingDistanceMultiplicator", _txInterference];

			//Debugging
			// if (false) then {	
			// 	// systemChat format ["Distance: %1, Percent: %2", _distJammer,  100 * _distPercent];
			// 	systemChat format ["tfar_rx: %1, tfar_tx: %2", _rxInterference, _txInterference];
			// 	systemChat format ["Closest Jammer netID: %1, radius: %2, enabled: %3", netId (_nearestJammer select 0), _nearestJammer select 1, _nearestJammer select 3];
			// };
		};
	};
};

// handle drone jammers
private _PP_film = GVAR(FilmGrain_jamEffect);
_PP_film ppEffectEnable false; // restore players view back to normal if no other logic decides otherwise
private _drone = getConnectedUAV player;
if (!isNull _drone) then {
	// sort drone jammers by distance to drone not distance to player (which only makes sense for VoiceCommJammers)
	private _sortingCode = { _input0 distance _x#0 };	// sort by distance between drone and jammer
	private _filterCode = { _x#3  && { JAM_CAPABILITY_DRONE in _x#4 } };	// keep jammers that are enabled and have the JAM_CAPABILITY_DRONE capability
	private _droneJammersSorted = [ values GVAR(jamMap), [_drone], _sortingCode, "ASCEND", _filterCode] call BIS_fnc_sortBy; 
	
	if (count _droneJammersSorted == 0) exitWith {};	// there are no enabled "DroneJammers"
	
	private _nearestDroneJammer = _droneJammersSorted#0;
	_nearestDroneJammer params ["_jamObj", "_radius", "_strength", "_enabled", "_capabilities"];
	private _distDroneToJammer = _drone distance _jamObj;
	
	if (_distDroneToJammer < _radius) then {
		// hardest actions to take when being inside the jammer area
		player connectTerminalToUAV objNull; // disconnect player from drone
		hint parseText "Drone is jammed<br/><t color='#ff0000'>Connection lost</t>";	// notify player why this happened
		// jamming of non player controlled drones is handled in fnc_jammerServerLoop.sqf.
	} else {
		// less intense actions when drone is only approaching the jammer area (gives pilot time to react to the presence of the jammer)
		if (isRemoteControlling player && (isNull curatorCamera)) then {	// if player uses UAV camera currently (and did not step into Zeus mode)
			// calculate video image distortion
			private _distDrone2killRadius = _distDroneToJammer - _radius;
			private _distDrone2pilot = _drone distance player;
			private _sharpness = [0, 4, _distDrone2killRadius/_distDrone2pilot] call BIS_fnc_lerp;
			//systemChat format ["ratio %1, _sharpness %2", _distDrone2killRadius/_distDrone2pilot, _sharpness];
			
			_PP_film ppEffectAdjust [1,_sharpness,3.3,2,2,true]; 
			_PP_film ppEffectEnable true; 
		}; 
	};
};
_PP_film ppEffectCommit 0;	// commit what ever change has been made
