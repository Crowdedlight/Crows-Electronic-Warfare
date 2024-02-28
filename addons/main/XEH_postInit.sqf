#include "script_component.hpp"

// for now only work if TFAR is loaded, as we only jam TFAR 
private _hasTFAR = isClass (configFile >> "CfgPatches" >> "task_force_radio");
if (!_hasTFAR) exitWith {diag_log "crowsEW-jamming: TFAR not loaded, so TFAR Jamming is not available"};

//Don't do anything in Singleplayer, as TFAR isn't enabled in SP
if (!isMultiplayer && !is3DENMultiplayer) exitWith {};

// if not a player we don't do anything
if (isServer) then {
	// satcom boost loop
	GVAR(PFH_satcomHandler) = [FUNC(satcomServerLoop) , 0.5] call CBA_fnc_addPerFrameHandler; 
	private _addSatcomId = [QGVAR(addSatcom), FUNC(addSatcom)] call CBA_fnc_addEventHandler;
	private _removeSatcomId = [QGVAR(removeSatcom), FUNC(removeSatcom)] call CBA_fnc_addEventHandler;

	// drone AI & cleanup jamming loop
	GVAR(PFH_jammerServerLoop) = [FUNC(jammerServerLoop) , 1] call CBA_fnc_addPerFrameHandler; 

	// event handlers for adding and removing jammers
	[QGVAR(addJammer), FUNC(addJammerServer)] call CBA_fnc_addEventHandler;
	[QGVAR(removeJammer), FUNC(removeJammerServer)] call CBA_fnc_addEventHandler;
	// EH for requesting current jammer state (Init/JIP)
	[QGVAR(requestJammers), FUNC(requestJammers)] call CBA_fnc_addEventHandler;
}; 

// last of this init is only for interfaces, so skipping if we don't have one... aka we are dedicated server
if (!hasInterface) exitWith{};

// EH for updating state of jammers
[QGVAR(updateJammers), FUNC(updateJammers)] call CBA_fnc_addEventHandler;
// EH for jam marker removal (Zeus)
[QGVAR(removeJamMarker), FUNC(removeJamMarkers)] call CBA_fnc_addEventHandler;

// register event callback, "actionToggleJam" so a disable/enable of a jammer by a player is sync'ed across the network
private _toggleJamid = [QGVAR(actionToggleJam), FUNC(actionJamToggleListener)] call CBA_fnc_addEventHandler;

// due to best practices we are gonna put the jam loop in unscheduled space, so we use a PFH to run every 0.5s 
GVAR(PFH_jamPlayer) = [FUNC(jammerPlayerLocal) , 0.5] call CBA_fnc_addPerFrameHandler; 

GVAR(FilmGrain_jamEffect) = ppEffectCreate ["FilmGrain",2000]; 

// Requesting sync of jammer state - Server will return a targeted event with current state on "updateJammers"
[QGVAR(requestJammers), []] call CBA_fnc_serverEvent;

// DEBUG
// GVAR(debugbla) = [{
// 	systemChat format ["Send: %1, Recv: %2", player getVariable ["tf_sendingDistanceMultiplicator", -1],player getVariable ["tf_receivingDistanceMultiplicator", -1]];
// 	} , 0.5] call CBA_fnc_addPerFrameHandler; 

// zeus only 
// spawn function as we need to check if zeus, and we cannot do that at mission time 0 due to race-condition
private _waitZeus = [player] spawn
{
	params ["_unit"];
	private _timeout = 0;
	waitUntil 
	{
		if (_timeout >= 10) exitWith 
		{
			diag_log format ["CrowsEW:%1: Timed out!!!", "main_postInit_waitzeus"];
			true;
		};
		sleep 1;
		_timeout = _timeout + 1;
		if (count allCurators == 0 || {!isNull (getAssignedCuratorLogic _unit)}) exitWith {true};
		false;
	};
	// call function to set eventHandler - Zeus should be initialized by now, so we can check if zeus or not
	if (call EFUNC(zeus,isZeus)) then {
		// handler for satcom markers
		GVAR(PFH_satcomMarkerHandler) = [FUNC(satcomServerMapDisplay) , 0.1] call CBA_fnc_addPerFrameHandler;
		// event handler for removal of satcom markers. Required to not leave dangling map-markers
		private _removeSatcomMarkerId = [QGVAR(removeSatcomMarker), FUNC(removeSatcomMarker)] call CBA_fnc_addEventHandler;		
	};
};
