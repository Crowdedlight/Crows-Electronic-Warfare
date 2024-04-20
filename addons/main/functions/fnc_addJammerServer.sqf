#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_addJammerServer.sqf
Parameters: pos, _unit
Return: none

SERVER ONLY
Called upon event, adds the jammer to local gvar array and starts while loop, if it isn't running

*///////////////////////////////////////////////
params ["_unit", "_radFalloff", "_radEffective", "_enabled", "_capabilities"];

// if object is null, exitwith. Can happen if we get event as JIP but object has been removed
if (isNull _unit || !isServer) exitWith {};

private _netId = netId _unit;

// if dataterminal do animation 
if (typeof _unit == "Land_DataTerminal_01_F") then {
	
	// set texture of left screen to custom 
	_unit setObjectTextureGlobal [0, QPATHTOF(data\data_terminal_screen_CO.paa)];
	_unit setObjectMaterialGlobal [0, "\A3\Props_F_Exp_A\Military\Equipment\Data\DataTerminal_green.rvmat"];
	
	if (_enabled) then {		
		[_unit,3] call BIS_fnc_dataTerminalAnimate;	// animate activation
	} else {
		[_unit,0] call BIS_fnc_dataTerminalAnimate;	// keep data terminal closed
	};

	// add eventhandler to allow it to be blown up. Essential explosives
	_unit addEventHandler ["hitpart",
	{
		(_this select 0) params ["_target", "_shooter", "_projectile", "_position", "_velocity", "_selection", "_ammo", "_vector", "_radius", "_surfaceType", "_isDirect"];
		_ammo params ["_hitVal", "_inHitVal", "_inHitRange", "_explosiveDmg", "_ammoClassName"];

		// if over 0.5 
		if (_explosiveDmg > 0.5 && _hitVal > 100) then {
			// if blown up with explosive, delete the vehicle
			deleteVehicle _target; 
		};
	}];
};

// add to map, netId is key		jammer, _radFalloff, _radEffective, enabled and capabilities
GVAR(jamMap) set [_netId, [_unit, _radFalloff, _radEffective, _enabled, _capabilities]];

// broadcast update
[QGVAR(updateJammers), [GVAR(jamMap)]] call CBA_fnc_globalEvent;

// if hosted multiplayer the jamMaps are shared between player and client for host, and thus update handler on client won't detect "new" jammers added on client side (as there is no difference between their jamMaps).
//  So we have to add actions/markers to jammers here
if (isServer && hasInterface) then {
	// add actions to new jammers
	_unit addAction ["<t color=""#FFFF00"">De-activate jammer", FUNC(actionJamToggle), [_netId], 7, true, true, "", format ["([%1] call %2)", str(_netId), FUNC(isJammerActive)], 6];
	_unit addAction ["<t color=""#FFFF00"">Activate jammer", FUNC(actionJamToggle), [_netId], 7, true, true, "", format ["!([%1] call %2)", str(_netId), FUNC(isJammerActive)], 6];

	// if zeus, add map marker for new ones
	if (call EFUNC(zeus,isZeus)) then {
		[_unit, _netId, _radFalloff, _radEffective, false, _enabled] call FUNC(updateJamMarker);
	};
};

if (_enabled) then {
	private _range = _radFalloff + _radEffective;
	private _frequencyRange = EGVAR(spectrum,spectrumDeviceFrequencyRange);
	// add jammer as a signal beacon (so that it can be tracked down with the Spectrum Device)
	if (JAM_CAPABILITY_RADIO in _capabilities) then {
		[_unit, (_frequencyRange#0)#0, _range, "sweep_radio"] call EFUNC(spectrum,addBeaconServer);
	};
	if (JAM_CAPABILITY_DRONE in _capabilities) then {
		[_unit, (_frequencyRange#2)#0, _range, "sweep_drone"] call EFUNC(spectrum,addBeaconServer);
	};
};

// set variable on unit that its a jammer. Helps checking if zeus should get right-click context option, compared to checking if exists going through all jammers etc. 
_unit setVariable[QGVAR(isJammer), true, true];

// Experiment information from logging data hits
// Results: that explosive damage should be > 0.5, and hit value > 100

// MAAWS
// [hit value, indirect hit value, indirect hit range, explosive damage, ammo class name]
// 18:44:45 [150,14,3,0.8,"R_MRAAWS_HEAT_F"]
// 18:44:45 [150,14,3,0.8,"R_MRAAWS_HEAT_F"]
// 18:44:45 [495,0,0,0,"ammo_Penetrator_MRAAWS"]

// DEMO BLOCK
// 18:46:24 [9,0,0,0,"rhs_ammo_556x45_M855_Ball"]
// 18:46:24 [9,0,0,0,"rhs_ammo_556x45_M855_Ball"]
// 18:46:49 [1000,1000,3,1,"rhsusf_m112_ammo"]

// Claymore 
// 18:48:08 [40,40,30,1,"ClaymoreDirectionalMine_Remote_Ammo"]

// Grenade M67 Frag
// 18:49:33 [8,8,6,1,"GrenadeHand"]

// Underslung 40MM
// 18:51:44 [80,8,6,1,"G_40mm_HE"]

// M112 Standard demo block
// 18:54:07 [500,500,7,1,"DemoCharge_Remote_Ammo"]

// M112 4x (4x of the small ones) demo block
// 18:54:53 [3000,3000,5,1,"rhsusf_m112x4_ammo"]

// 200g TNT
// 18:55:22 [400,400,3,1,"rhs_ec200_sand_ammo"]

// 400g TNT 
// 18:56:04 [1000,1000,5,1,"rhs_ec400_sand_ammo"]

// RPG OG-7V
// 18:57:57 [75,20,15,1,"rhs_rpg7v2_og7v"]

// panzerfaust 
// 18:59:01 [200,10,1,0.35,"rhs_ammo_panzerfaust60_rocket"]
// 18:59:01 [200,10,1,0.35,"rhs_ammo_panzerfaust60_rocket"]
// 18:59:01 [290,0,0,0,"rhs_ammo_panzerfaust60_penetrator"]