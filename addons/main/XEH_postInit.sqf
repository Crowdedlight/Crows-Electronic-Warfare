#include "script_component.hpp"

//Don't do anything in Singleplayer, as TFAR isn't enabled in SP
if (!isMultiplayer && !is3DENMultiplayer) exitWith {
	systemChat "CrowsEW will not work properly in singleplayer mode!!! Please restart in multiplayer mode.";
	diag_log "CrowsEW started in singleplayer mode. Some features will not work.";
};

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
	[QGVAR(toggleJammer), FUNC(toggleJammerServer)] call CBA_fnc_addEventHandler;
	// EH for requesting current jammer state (Init/JIP)
	[QGVAR(requestJammers), FUNC(requestJammers)] call CBA_fnc_addEventHandler;
}; 

// init 3den-placed data terminals
private _allCrowsTerminals = allMissionObjects "Crows_dataterminal";
{ _x call FUNC(initCrowsDataterminal); } forEach _allCrowsTerminals;
// Add class eventhandler for data terminals that are spawned on all clients as they run locally
["Crows_dataterminal", "initpost", FUNC(initCrowsDataterminal), true, [], false] call CBA_fnc_addClassEventHandler;
// Note: 3den-placed terminals don't work for some reason with _applyInitRetroactively=true
// see discussion at: https://discord.com/channels/976165959041679380/976228110078992456/1407346710425894912

// add EH to handle locality of the data terminal
[QGVAR(dataTerminalBlownupEvent), FUNC(handleCrowsDataterminalBlownUp)] call CBA_fnc_addEventHandler;


// last of this init is only for interfaces, so skipping if we don't have one... aka we are dedicated server
if (!hasInterface) exitWith{};

// EH for updating state of jammers
[QGVAR(updateJammers), FUNC(updateJammers)] call CBA_fnc_addEventHandler;

// register event callback, "actionToggleJam" so a disable/enable of a jammer by a player is sync'ed across the network
private _toggleJamid = [QGVAR(actionToggleJam), FUNC(actionJamToggleListener)] call CBA_fnc_addEventHandler;

// local jammer loop to handle jamming on the client. PFH running every 0.5s 
GVAR(PFH_jamPlayer) = [FUNC(jammerPlayerLocal) , 0.5] call CBA_fnc_addPerFrameHandler; 
GVAR(FilmGrain_jamEffect) = ppEffectCreate ["FilmGrain",2000]; 

// Requesting sync of jammer state - Server will return a targeted event with current state on "updateJammers"
[QGVAR(requestJammers), [player]] call CBA_fnc_serverEvent;

// If ACRE is loaded run the function to register interference handling of signal
if (EGVAR(zeus,hasACRE)) then {
	call FUNC(signalHandlerACRE);
};

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
		GVAR(PFH_satcomMarkerHandler) = [FUNC(satcomZeusMapDisplay), 0.5] call CBA_fnc_addPerFrameHandler;
		// event handler for removal of satcom markers. Required to not leave dangling map-markers
		private _removeSatcomMarkerId = [QGVAR(removeSatcomMarker), FUNC(removeSatcomMarker)] call CBA_fnc_addEventHandler;		
	};
};
