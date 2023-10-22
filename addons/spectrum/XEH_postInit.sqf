#include "script_component.hpp"

// if server, set eventhandlers for server 
if (isServer) then {
	// event listener for adding trackable random radio chatter on units - server only
	private _randomRadioChatterTrackingId = [QGVAR(addRandomRadioTrackingChatter), FUNC(addRandomRadioTrackingChatterServer)] call CBA_fnc_addEventHandler;
	private _removeRandomRadioChatterTrackingId = [QGVAR(removeRandomRadioTrackingChatter), FUNC(removeRandomRadioTrackingChatterServer)] call CBA_fnc_addEventHandler;
};

// if not a player we don't do anything
if (!hasInterface) exitWith {}; 

// spectrum device handlers and default settings are set in "spectrumEnableSettingChanged" to allow for disable/enable of device
//  The add beacon code and zeus modules are still active, as the disable can be set individually. And as long as the local handlers are disabled, they can't interferer.

GVAR(trackerUnit) = player; // what unit is used as tracker. Nessecary for zeus RC support

// register event callback, "addBeacon", as rest is local, event runs local jam function that adds to array and starts the while loop 
private _addId = [QGVAR(addBeacon), FUNC(addBeacon)] call CBA_fnc_addEventHandler;
private _removeId = [QGVAR(removeBeacon), FUNC(removeBeacon)] call CBA_fnc_addEventHandler;

// event listener to enable/disable TFAR signal sourcing
private _tfarTrackingId = [QGVAR(toggleRadioTracking), FUNC(toggleRadioTracking)] call CBA_fnc_addEventHandler;

// eventhandler for respawn as the TFAR EH we are using is removed upon respawn
player addEventHandler ["Respawn", {
    params ["_unit", "_corpse"];

	// to support zeus RC tracking, changed to variable system for tracker. Reset tracker upon respawn
	GVAR(trackerUnit) = player;

	// if TFAR tracking is enabled we reapply the TFAR eventhandler
	if (GVAR(radioTrackingEnabled)) then {
    	[QGVAR(radioTrackingBroadcastLocal), "OnTangent", FUNC(radioTrackingBroadcastLocal), _unit] call TFAR_fnc_addEventHandler;
	};
}];

// eventhandler for RC'ing as zeus. To give new unit the TFAR EH. Gotta spawn it to wait for zeus to be registered
// Set for all players, as this event can only be triggered by zeus' anyway
private _zeusRcEventStartId = ["zen_remoteControlStarted", FUNC(eventZeusStartRC)] call CBA_fnc_addEventHandler;
private _zeusRcEventStopId = ["zen_remoteControlStopped", FUNC(eventZeusStopRC)] call CBA_fnc_addEventHandler;

// Eventhandlers for ctrack, adding ACE one to detech when a ctrack is detached and we can reset variable
private _aceDetachId = ["ace_attach_detaching", FUNC(ctrackDetachEvent)] call CBA_fnc_addEventHandler;

// if no ace, we run the function for ctrack without ace 
if (!EGVAR(zeus,hasAce)) then {
	[] call FUNC(ctrackNoAce);
};
