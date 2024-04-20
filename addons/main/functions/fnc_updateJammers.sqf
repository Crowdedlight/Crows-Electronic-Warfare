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
	_unit addAction ["<t color=""#FFFF00"">De-activate jammer", FUNC(actionJamToggle), [_netId], 7, true, true, "", format ["([%1] call %2)", str(_netId), FUNC(isJammerActive)], 6];
	_unit addAction ["<t color=""#FFFF00"">Activate jammer", FUNC(actionJamToggle), [_netId], 7, true, true, "", format ["!([%1] call %2)", str(_netId), FUNC(isJammerActive)], 6];

	// if zeus, add map marker for new ones
	if (call EFUNC(zeus,isZeus)) then {
		[_unit, _netId, _radFalloff, _radEffective, false, _enabled] call FUNC(updateJamMarker);
	};
} forEach _newJammers;

// reset effects if 0, as 0 == no logic being run in local PFH
if (count _jamMap == 0) then {
	[player] call FUNC(resetTfarIfDegraded);

	// reset jamming effect on video signal if updated to be empty
	private _PP_film = GVAR(FilmGrain_jamEffect);
	_PP_film ppEffectEnable false;
	_PP_film ppEffectCommit 0;
};

// update local map
GVAR(jamMap) = _jamMap;
