#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_satcomServerLoop.sqf
Parameters: netID
Return: none

Runs the server-side loop handling satcom boosting

*///////////////////////////////////////////////

// called every 0.5s, 
if (count GVAR(satcom_active_list) == 0 && count GVAR(satcom_boosted_units) == 0) exitWith {};

// loop through all current active objects
private _newBoostedList = [];
private _removeList = [];

{
	_y params["_emitter", "_radius"];

	// if emitter is null, we skip it, and set it to be deleted
	if (isNull _emitter || !alive _emitter) then {
		_removeList pushBack _x;
		continue;
	};

	// get nearest men, radius saved
	private _effectUnitsList = _emitter nearEntities [["CAManBase", "LandVehicle", "Helicopter", "Plane", "Ship"], _radius];
	// get crew of all vehicles
	private _effectUnits = [];
	{
		_effectUnits append (crew _x);
	} forEach _effectUnitsList;
	
	{
		// check if player, otherwise skip. AI won't use TFAR. TODO future, handle remote control as zeus to also boost RC'ed unit if in range?
		if (!isPlayer _x) then {continue;};

		// check if player already in effect, then we skip
		if (_x in GVAR(satcom_boosted_units)) then {continue;};

		// set current tfar variables. For now we do satcom, so always 4x boost, no matter the jamming
		_x setVariable ["tf_receivingDistanceMultiplicator", 4, true];
		_x setVariable ["tf_sendingDistanceMultiplicator", 4, true];
	} forEach _effectUnits;

	// update array of current effected players
	_newBoostedList append _effectUnits;
} forEach GVAR(satcom_active_list);

// remove lost satcoms
[_removeList] call FUNC(removeSatcom);

// get players no longer effected 
private _gonePlayers = GVAR(satcom_boosted_units) - _newBoostedList;

// reset players that left area of effect. We reset to 1
{
	_x setVariable ["tf_receivingDistanceMultiplicator", 1, true];
	_x setVariable ["tf_sendingDistanceMultiplicator", 1, true];
} forEach _gonePlayers;

// save current effected players
GVAR(satcom_boosted_units) = _newBoostedList;
