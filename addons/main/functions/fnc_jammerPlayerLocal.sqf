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
		_y params ["_jamObj", "_radFalloff", "_radEffective", "_enabled", "_capabilities"];
		// jamObj, netId, radFalloff, radEffective, updating, enabled
		[_jamObj, _x, _radFalloff, _radEffective, _enabled] call FUNC(updateJamMarker);
	} forEach GVAR(jamMap);
};

// TFAR Jamming logic - do not run if zeus, as zeus is immune to TFAR jamming only
if (!(call EFUNC(zeus,isZeus))) then {
	// find nearest jammer within range
	private _nearestJammer = [objNull];
	private _distJammer = -1;
	private _distRad = -1;
	{
		_y params ["_jamObj", "_radFalloff", "_radEffective", "_enabled", "_capabilities"];

		// if disabled, skip the jammer 
		if (!_enabled) then {continue};

		// get current dist 
		private _dist = player distance _jamObj;

		// if distance to object is bigger than radius of effective + falloff, continue 
		if (_dist > (_radFalloff + _radEffective)) then {continue;};

		// we are now within influence area, if this jammer is closer than previous jammers, we save it
		if (_distJammer == -1 || _distJammer > _dist) then {
			_distJammer = _dist;
			_nearestJammer = _y;
		};
	} forEach GVAR(jamMap);

	private _nearestJammerObject = (_nearestJammer select 0);

	// if no jammer are within range, reset tfar vars and exit
	if (isNull _nearestJammerObject) then {
		// reset values of TFAR, if they are degraded
		[player] call FUNC(resetRadioIfDegraded);
	} else {
		// check for jammer capabilities and counteract signals accordingly
		if ( JAM_CAPABILITY_RADIO in (_nearestJammer select 4) ) then {
			// get jamStrength of nearest jammer
			private _radFalloff = _nearestJammer select 1;
			private _radEffective = _nearestJammer select 2;

			// apply interference, TFAR or ACRE style
			if (EGVAR(zeus,hasTFAR)) then {
				[_distJammer, _radFalloff, _radEffective] call FUNC(applyInterferenceTFAR);
			};

			if (EGVAR(zeus,hasACRE)) then {
				[_distJammer, _radFalloff, _radEffective] call FUNC(applyInterferenceACRE);
			};
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
	_nearestDroneJammer params ["_jamObj", "_radFalloff", "_radEffective", "_enabled", "_capabilities"];
	private _distDroneToJammer = _drone distance _jamObj;

	// to keep consistency, if we are outside effective + falloff range of jammer, then we don't get any interference
	if (_distDroneToJammer > (_radEffective + _radFalloff)) exitWith {};
	
	if (_distDroneToJammer < _radEffective) then {
		// hardest actions to take when being inside the jammer area
		player connectTerminalToUAV objNull; // disconnect player from drone
		hint parseText "Drone is jammed<br/><t color='#ff0000'>Connection lost</t>";	// notify player why this happened
		// jamming of non player controlled drones is handled in fnc_jammerServerLoop.sqf.
	} else {
		// less intense actions when drone is only approaching the jammer area (gives pilot time to react to the presence of the jammer)
		if (isRemoteControlling player && (isNull curatorCamera)) then {	// if player uses UAV camera currently (and did not step into Zeus mode)
			// calculate video image distortion
			private _distDrone2killRadius = abs(_distDroneToJammer - _radEffective);
			private _sharpness = [0, 4, _distDrone2killRadius/_radFalloff] call BIS_fnc_lerp;
			// systemChat format ["ratio %1, _sharpness %2", _distDrone2killRadius/_radFalloff, _sharpness];
			
			_PP_film ppEffectAdjust [1,_sharpness,3.3,2,2,true]; 
			_PP_film ppEffectEnable true; 
		}; 
	};
};
_PP_film ppEffectCommit 0;	// commit what ever change has been made
