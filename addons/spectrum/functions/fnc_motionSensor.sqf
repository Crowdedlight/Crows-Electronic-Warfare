#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Landric
			   
File: fnc_motionSensor.sqf
Parameters: sensor - the sensor Object (to which the user-defined variables are attached)
			detected - Array of Objects activating the cMotion trigger (i.e. thisList)
Return: bool

Returns true if an object in the trigger radius has moved since it was last observed (false otherwise)

*///////////////////////////////////////////////

params [["_sensor", objNull, [objNull]], ["_detected", [], [[]]]];

_detected = _detected select {_x isNotEqualTo _sensor};
// TODO: also remove PRONE units?
// Would allow units to sneak past sensors - particularly useful if they're ever linked to explosives
// Potentially a server-setting

// TODO: filter out animals (rabbits/snakes/etc.)?


if(isNull _sensor) exitWith { diag_log "crowsEW-spectrum: C-MOTION triggered with no associated sensor"; };

_previousSensorList = _sensor getVariable [QGVAR(cmotionSensorList), createHashMap];

_newSensorList = (_detected apply {hashValue _x}) createHashMapFromArray (_detected apply {getPosASL _x});

_prevKeys = keys _previousSensorList;
_prevKeys sort true;

_newKeys = keys _newSensorList;
_newKeys sort true;

private _motionDetected = false;
if( _prevKeys isNotEqualTo _newKeys ) then {
	_motionDetected = true;
} else {
	private _tolerance = 0.05; // TODO: make a CBA setting?
	{
		if(((_previousSensorList get _x) distance (_newSensorList get _x)) > _tolerance) then {
			_motionDetected = true;
			break;
		};
	} forEach _prevKeys;
};

// TODO: Technically, the above won't detect motion if a unit stands still and the sensor moves away from them;
// we could solve this by ALSO checking distance from the sensor - however, see below

// TODO: In theory we should also check for movement of the sensor Object itself from its last-known position;
// however, in almost all cases we care about (e.g. it was picked up) there will be another object to trigger it,
// and where this is not the case (e.g. it slides down a hill), triggering it may not be desirable anyway

// TODO: both of the above go away if the sensor is made sim-disabled

_sensor setVariable [QGVAR(cmotionSensorList), _newSensorList];

_motionDetected