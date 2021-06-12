#include "script_component.hpp"

//Don't do anything in Singleplayer, as TFAR isn't enabled in SP
if (!isMultiplayer && !is3DENMultiplayer) exitWith {};

// if not a player we don't do anything
if (!hasInterface) exitWith {}; 

// register event callback, "addJammer", as rest is local, event runs local jam function that adds to array and starts the while loop 
private _addJamid = [QGVAR(addJammer), FUNC(addJammer)] call CBA_fnc_addEventHandler;
private _removeJamid = [QGVAR(removeJammer), FUNC(removeJammer)] call CBA_fnc_addEventHandler;

// register event callback, "actionToggleJam" so a disable/enable of a jammer by a player is sync'ed across the network
private _toggleJamid = [QGVAR(actionToggleJam), FUNC(actionJamToggleListener)] call CBA_fnc_addEventHandler;

// due to best practices we are gonna put the jam loop in unscheduled space, so we use a PFH to run every 1s 
GVAR(PFH_jamPlayer) = [FUNC(jammerPlayerLocal) , 1] call CBA_fnc_addPerFrameHandler; 
