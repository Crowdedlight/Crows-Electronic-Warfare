#include "script_component.hpp"

// for now only work if TFAR is loaded, as we only jam TFAR 
private _hasTFAR = isClass (configFile >> "CfgPatches" >> "task_force_radio");
if (!_hasTFAR) exitWith {diag_log "crowsEW-jamming: TFAR not loaded, so TFAR Jamming is not available"};

//Don't do anything in Singleplayer, as TFAR isn't enabled in SP
if (!isMultiplayer && !is3DENMultiplayer) exitWith {};

// if not a player we don't do anything
if (!hasInterface) exitWith {}; 

// register event callback, "addJammer", as rest is local, event runs local jam function that adds to array and starts the while loop 
private _addJamid = [QGVAR(addJammer), FUNC(addJammer)] call CBA_fnc_addEventHandler;
private _removeJamid = [QGVAR(removeJammer), FUNC(removeJammer)] call CBA_fnc_addEventHandler;

// register event callback, "actionToggleJam" so a disable/enable of a jammer by a player is sync'ed across the network
private _toggleJamid = [QGVAR(actionToggleJam), FUNC(actionJamToggleListener)] call CBA_fnc_addEventHandler;

// due to best practices we are gonna put the jam loop in unscheduled space, so we use a PFH to run every 0.5s 
GVAR(PFH_jamPlayer) = [FUNC(jammerPlayerLocal) , 0.5] call CBA_fnc_addPerFrameHandler; 

// satcom boost loop
if (isServer) then {
	GVAR(PFH_satcomHandler) = [FUNC(satcomServerLoop) , 0.5] call CBA_fnc_addPerFrameHandler; 
	private _addSatcomId = [QGVAR(addSatcom), FUNC(addSatcom)] call CBA_fnc_addEventHandler;
	private _removeSatcomId = [QGVAR(removeSatcom), FUNC(removeSatcom)] call CBA_fnc_addEventHandler;
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
		GVAR(PFH_satcomMarkerHandler) = [FUNC(satcomServerMapDisplay) , 0.1] call CBA_fnc_addPerFrameHandler;
		// event handler for removal of satcom markers. Required to not leave dangling map-markers
		private _removeSatcomMarkerId = [QGVAR(removeSatcomMarker), FUNC(removeSatcomMarker)] call CBA_fnc_addEventHandler;		
	};
};
