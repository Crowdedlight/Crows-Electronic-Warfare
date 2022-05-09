#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_removeSatcom.sqf
Parameters: 
Return: none

Called upon event, removes active satcom to local gvar map

*///////////////////////////////////////////////
params ["_netids"];

// remove from array
{
	GVAR(satcom_active_list) deleteAt _x;

	// remove marker 
	[QEGVAR(main,removeSatcomMarker), [_x]] call CBA_fnc_globalEvent;

} forEach _netids;

// update 
missionNamespace setVariable[QGVAR(satcomActiveList), GVAR(satcom_active_list), true];
