#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_ctrackDetachEvent.sqf
Parameters: _unit
Return: none

*///////////////////////////////////////////////

// Just before an item gets detached/removed from a unit/vehicle. _temporary flag means its detached because the player unit entered a vehicle.
params ["_attachedObject", "_itemName", "_temporary"];

// only handle my items
if (!(_itemName isEqualTo "crowsew_ctrack")) exitWith {};

// get object its attached to
private _attachedToObj = attachedTo _attachedObject;
private _jipID = _attachedToObj getVariable[QGVAR(ctrack_attached_jipID), ""];

// no matter what cause is for detach, we always remove jip event to not linger - // - TODO Should probably change so spectrum beacons save their own jip id, and when they "cleanup" they remove it to avoid having large amount of dead jips events
if (_jipID != "") then {
	[_jipID] call CBA_fnc_removeGlobalEventJIP;
	_attachedToObj setVariable[QGVAR(ctrack_attached_jipID), ""];
};

// if temporary is false, then its removed by player action and we reset variable
if (!temporary) then {
	_attachedObject setVariable[QGVAR(ctrack_attached_frequency), 0];
	_attachedObject setVariable[QGVAR(ctrack_attached_range), 0];
};