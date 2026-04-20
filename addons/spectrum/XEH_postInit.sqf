#include "script_component.hpp"


// register a custom ShareInformationHandler at LAMBS danger (if available) for both server and clients
private _lambsConfig = configFile >> "CfgPatches" >> "lambs_main";
private _hasLAMBS = isClass(_lambsConfig);
if (_hasLAMBS) then {
	// check LAMBS for minimum required version
	private _LAMBSversion = [_lambsConfig,"versionAr"] call BIS_fnc_returnConfigEntry;
	diag_log format ["CrowsEW-spectrum: LAMBS version %1 detected", _LAMBSversion]; // debug output
	// TODO: exitWith in case version is to low

	[FUNC(lambsShareInformationHandler)] call lambs_main_fnc_addShareInformationHandler;
};


// if server, set eventhandlers for server 
if (isServer) then {
	// event listener for adding trackable random radio chatter on units - server only
	private _randomRadioChatterTrackingId = [QGVAR(addRandomRadioTrackingChatter), FUNC(addRandomRadioTrackingChatterServer)] call CBA_fnc_addEventHandler;
	private _removeRandomRadioChatterTrackingId = [QGVAR(removeRandomRadioTrackingChatter), FUNC(removeRandomRadioTrackingChatterServer)] call CBA_fnc_addEventHandler;

	// EH for adding and removing beacons
	[QGVAR(addBeacon), FUNC(addBeaconServer)] call CBA_fnc_addEventHandler;
	[QGVAR(removeBeacon), FUNC(removeBeaconServer)] call CBA_fnc_addEventHandler;
	[QGVAR(requestBeacons), FUNC(requestBeaconServer)] call CBA_fnc_addEventHandler;

	// PFH for beacon cleanup
	GVAR(PFH_BeaconServerLoop) = [FUNC(beaconLoopServer), 1] call CBA_fnc_addPerFrameHandler; 

	// EH for jamming
	[QGVAR(toggleJammingOnUnit), FUNC(toggleJammingOnUnit)] call CBA_fnc_addEventHandler;
	[QGVAR(setUnitJammable), FUNC(initDroneSignals)] call CBA_fnc_addEventHandler;
};

// toggle AI function has to be available on all clients, as it only runs on whoever has the unit locally 
[QGVAR(toggleAI), FUNC(toggleAI)] call CBA_fnc_addEventHandler;

// if not a player we don't do anything
if (!hasInterface) exitWith {}; 

// spectrum device handlers and default settings are set in "spectrumEnableSettingChanged" to allow for disable/enable of device
//  The add beacon code and zeus modules are still active, as the disable can be set individually. And as long as the local handlers are disabled, they can't interferer.
[QGVAR(updateBeacons), FUNC(updateBeacons)] call CBA_fnc_addEventHandler;

GVAR(trackerUnit) = player; // what unit is used as tracker. Nessecary for zeus RC support

// EH for jamming disconnects
[QGVAR(disconnectPlayerUAV), FUNC(disconnectPlayerUAV) ] call CBA_fnc_addEventHandler;

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

GVAR(currentPlayerLocalRadioSoundIds) = []; // array of sound ids currently being played for this player (can be multiple in case of race-conditions)
GVAR(currentPlayerLocalRadioEmitter) = objNull; // unit that emits the sound currently being played for this player
GVAR(newRadioSoundStartedEHid) = -1;	// invalid initial id, will be set dynamically when we start listening to a sound

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

// request current state of beacons - for JIP/init
[QGVAR(requestBeacons), [player]] call CBA_fnc_serverEvent;

