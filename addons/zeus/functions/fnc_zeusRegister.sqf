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

	private _moduleList = [GVAR(hasTFAR)] call {
		params ["_isTFARLoaded"];
		private _modules = [
			["Set Spectrum Signal Source",{_this call FUNC(addSpectrumBeaconZeus)}, QPATHTOF(data\spectrum_signal.paa)],
			["Remove Spectrum Signal Source",{_this call FUNC(removeSpectrumBeaconZeus)}, QPATHTOF(data\spectrum_signal.paa)],
			["Add Sound",{_this call FUNC(addSoundZeus)}, "\a3\modules_f_curator\Data\iconSound_ca.paa"],
			["Remove Sound",{_this call FUNC(removeSoundZeus)}, "\a3\modules_f_curator\Data\iconSound_ca.paa"],
			["Play Sound",{_this call FUNC(playSoundZeus)}, "\a3\modules_f_curator\Data\iconSound_ca.paa"],
			["Fire EMP",{_this call FUNC(fireEMPZeus)}, QPATHTOF(data\EMP_Icon.paa)], 
			["Set Immune to EMP",{_this call FUNC(setImmuneEMPZeus)}, QPATHTOF(data\EMP_Icon_IMU.paa)], 
			["Add Radio Tracking Chatter",{_this call FUNC(addRandomRadioTrackingChatterZeus)}, QPATHTOF(data\EMP_Icon_IMU.paa)], 
			["Remove Radio Tracking Chatter",{_this call FUNC(removeRandomRadioTrackingChatterZeus)}, QPATHTOF(data\EMP_Icon_IMU.paa)] 
		];
		private _tfarModules = [
			["Set TFAR Jammer",{_this call FUNC(addJammerZeus)}, "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa"],
			["Remove TFAR Jammer",{_this call FUNC(removeJammerZeus)}, "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa"],
			["Toggle Radio Tracking",{_this call FUNC(setRadioTrackingZeus)}, "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa"]
		];

		// return the ones to load		
		if (_isTFARLoaded) then {
			_modules = _modules + _tfarModules;
		};
		_modules;
	};

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