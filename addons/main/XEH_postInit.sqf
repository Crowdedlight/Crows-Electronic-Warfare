#include "script_component.hpp"

//Don't do anything in Singleplayer, as TFAR isn't enabled in SP
if (!isMultiplayer && !is3DENMultiplayer) exitWith {};

// set global var array to empty
GVAR(jamlist) = [];

// if not a player we don't do anything
if (!hasInterface) exitWith {}; 

// register event callback, "addJammer", as rest is local, event runs local jam function that adds to array and starts the while loop 
private _id = [QGVAR(addJammer), FUNC(addJammer)] call CBA_fnc_addEventHandler;
	
// register zeus module
call FUNC(zeusRegister);
