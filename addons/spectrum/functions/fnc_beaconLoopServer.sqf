#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_beaconLoopServer.sqf
Parameters: 
Return: 

PFH that handles cleanup of dead or removed beacons
SERVER ONLY

*///////////////////////////////////////////////

// only calculate if there is any signals, otherwise reset the list
if (count GVAR(beacons) == 0) exitWith {};

// update local array for deleted or dead elements
private _removeArr = [];
{
    // get target obj
    private _target = _x select 0;

    // if removed or dead, remove it from tracking array
    if (isNull _target || !alive _target) then {
        _removeArr pushBack _x;
    };
} forEach GVAR(beacons);

// if removeArr is empty we exit
if (count _removeArr == 0) exitWith {};

// update list
GVAR(beacons) = GVAR(beacons) - _removeArr;

// broadcast changes
[QGVAR(updateBeacons), [GVAR(beacons)]] call CBA_fnc_globalEvent;
