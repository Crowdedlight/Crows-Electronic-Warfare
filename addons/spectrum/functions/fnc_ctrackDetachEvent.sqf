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
if (_itemName != "crowsew_ctrack") exitWith {};

// get object its attached to
private _attachedToObj = attachedTo _attachedObject;

// if temporary is false, then its removed by player action and we reset variable
if (!temporary) then {
	_attachedObject setVariable[QGVAR(ctrack_attached_frequency), 0];
	_attachedObject setVariable[QGVAR(ctrack_attached_range), 0];
};