#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_zeusRegister.sqf
Parameters: none
Return: none

Using the same setup method as JShock in JSHK contamination mod. 

*///////////////////////////////////////////////

// check for zen 
private _hasZen = isClass (configFile >> "CfgPatches" >> "zen_custom_modules");
if !(_hasZen) exitWith
{
	diag_log "******CBA and/or ZEN not detected. They are required for Crows Electronic Warfare.";
};

//only load for zeus
if (!hasInterface) exitWith {};

//spawn script to register zen modules
private _wait = [player] spawn
{
	params ["_unit"];
	private _timeout = 0;
	waitUntil 
	{
		if (_timeout >= 10) exitWith 
		{
			diag_log format ["CrowsEW:%1: Timed out!!!", "fnc_zeusRegister"];
			true;
		};
		sleep 1;
		_timeout = _timeout + 1;
		if (count allCurators == 0 || {!isNull (getAssignedCuratorLogic _unit)}) exitWith {true};
		false;
	};

	private _moduleList = [
		["Set TFAR Jammer",{_this call EFUNC(main, addJammerZeus)}, "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa"] 
	];

	//registering ZEN custom modules
	{
		private _reg = 
		[
			"Crows Electronic Warfare",
			(_x select 0), 
			(_x select 1),
			(_x select 2)
		] call zen_custom_modules_fnc_register;
	} forEach _moduleList;
};
diag_log format ["CrowsEW:fnc_zeusRegister: Zeus initialization complete. Zeus Enhanced Detected: %2",_hasZen];