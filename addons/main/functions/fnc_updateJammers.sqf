#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_updateJammers.sqf
Parameters: _jamMap (hashmap)
Return: none

Gets the newest state of jamMap from the server which is the source of truth. So we update local jamMap and handle edge cases like if jamMap is empty and deleting markers from removed jammers

*///////////////////////////////////////////////
params ["_jamMap"];

// get diff of values between new value and current one, to get list of netIds to remove markers from - only applicable to zeus
if (call EFUNC(zeus,iszeus)) then {
	// get difference between values
	private _diff = (keys GVAR(jamMap)) - (keys _jamMap);
	[_diff] call FUNC(removeJamMarkers); 
};

// get new keys
private _newJammers = (keys _jamMap) - (keys GVAR(jamMap));
{
	private _netId = _x;
	// get object from hashmap
	(_jamMap get _x) params ["_unit", "_radFalloff", "_radEffective", "_enabled"];
	
	// add actions to new jammers
	_unit addAction [("<t color=""#FFFF00"">" + localize "STR_CROWSEW_Main_jammer_deactivate_action_name"), FUNC(actionJamToggle), [_netId], 7, true, true, "", format ["([%1] call %2)", str(_netId), FUNC(isJammerActive)], 6];
	_unit addAction [("<t color=""#FFFF00"">" + localize "STR_CROWSEW_Main_jammer_activate_action_name"), FUNC(actionJamToggle), [_netId], 7, true, true, "", format ["!([%1] call %2)", str(_netId), FUNC(isJammerActive)], 6];
} forEach _newJammers;

// reset effects if 0, as 0 == no logic being run in local PFH
if (count _jamMap == 0) then {
	[player] call FUNC(resetRadioIfDegraded);

	// reset jamming effect on video signal if updated to be empty
	private _PP_film = GVAR(FilmGrain_jamEffect);
	_PP_film ppEffectEnable false;
	_PP_film ppEffectCommit 0;
};

// keep the old state so we can tell what changed once the local map is updated
private _oldJamMap = GVAR(jamMap);

// update local map
GVAR(jamMap) = _jamMap;

// raise local events for what changed. The server (and host) already raised them when it changed the map, as it shares the map with its own handler and would see no diff here
if (!isServer) then {
	{
		[QGVAR(jammerRemoved), [_x, _oldJamMap get _x]] call CBA_fnc_localEvent;
	} forEach ((keys _oldJamMap) - (keys _jamMap));

	{
		[QGVAR(jammerAdded), [_x, _jamMap get _x]] call CBA_fnc_localEvent;
	} forEach _newJammers;

	{
		private _entry = _jamMap get _x;
		// toggled if the jammer existed before and its enabled state differs
		if (_x in _oldJamMap && {(_oldJamMap get _x)#3 isNotEqualTo _entry#3}) then {
			[QGVAR(jammerToggled), [_x, _entry#3, _entry]] call CBA_fnc_localEvent;
		};
	} forEach (keys _jamMap);
};
