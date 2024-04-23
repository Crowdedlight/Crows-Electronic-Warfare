#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_zeusRegister.sqf
Parameters: none
Return: none

Registers modules

*///////////////////////////////////////////////

// check for zen 
private _hasZen = isClass (configFile >> "CfgPatches" >> "zen_custom_modules");
if !(_hasZen) exitWith
{
	diag_log "******CBA and/or ZEN not detected. They are required for Crows Electronic Warfare.";
};

//only load for players
if (!hasInterface) exitWith {};

//register zen modules
private _moduleList = [GVAR(hasTFAR), GVAR(hasACRE)] call {
	params ["_isTFARLoaded", "_isACRELoaded"];
	private _modules = [
		["Add Spectrum Signal Source",{_this call FUNC(addSpectrumBeaconZeus)}, QPATHTOF(data\spectrum_signal.paa)],
		["Remove Spectrum Signal Source",{_this call FUNC(removeSpectrumBeaconZeus)}, QPATHTOF(data\spectrum_signal.paa)],
		["Add Sound",{_this call FUNC(addSoundZeus)}, "\a3\modules_f_curator\Data\iconSound_ca.paa"],
		["Remove Sound",{_this call FUNC(removeSoundZeus)}, "\a3\modules_f_curator\Data\iconSound_ca.paa"],
		["Play Sound",{_this call FUNC(playSoundZeus)}, "\a3\modules_f_curator\Data\iconSound_ca.paa"],
		["Fire EMP",{_this call FUNC(fireEMPZeus)}, QPATHTOF(data\EMP_Icon.paa)], 
		["Add Immune to EMP",{_this call FUNC(setImmuneEMPZeus)}, QPATHTOF(data\EMP_Icon_IMU.paa)], 
		["Add Radio Tracking Chatter",{_this call FUNC(addRandomRadioTrackingChatterZeus)}, QPATHTOF(data\EMP_Icon_IMU.paa)], 
		["Remove Radio Tracking Chatter",{_this call FUNC(removeRandomRadioTrackingChatterZeus)}, QPATHTOF(data\EMP_Icon_IMU.paa)], 
		["Set Unit Jammable",{_this call FUNC(setUnitJammableZeus)}, QPATHTOF(data\spectrum_signal.paa)],
		["Add Jammer",{_this call FUNC(addJammerZeus)}, "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa"],
		["Remove Jammer",{_this call FUNC(removeJammerZeus)}, "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa"]
	];
	private _tfarModules = [
		["Toggle Radio Tracking",{_this call FUNC(setRadioTrackingZeus)}, "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa"]
	];
	private _radioModules = [
		["Add SATCOM",{_this call FUNC(addSatcomZeus)}, "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa"], //TODO SATELLITE DISH ICON
		["Remove SATCOM",{_this call FUNC(removeSatcomZeus)}, "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa"] //TODO SATELLITE DISH ICON
	];

	// return the ones to load		
	if (_isTFARLoaded) then {
		_modules = _modules + _tfarModules;
	};
	if (_isTFARLoaded || _isACRELoaded) then {
		_modules = _modules + _radioModules;
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

// context actions
private _contextActionList = [
    // Action name, Display name, Icon and Icon colour, code, Condition to show, arguments, dynamic children, modifier functions
    [
        [QGVAR(context_menu_jammer),"Jammer","\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa", {}, {!isNull _hoveredEntity && {_hoveredEntity getVariable[QEGVAR(main,isJammer), false]}}, [], {[
			[[QGVAR(context_menu_toggle_jammer_on_off),"Toggle On/off","\a3\modules_f\data\portraitmodule_ca.paa", {[null, null, null, [netId _hoveredEntity]] call EFUNC(main,actionJamToggle)}] call zen_context_menu_fnc_createAction, [], 0]
		]}] call zen_context_menu_fnc_createAction,
        [],
        0
    ]
];
{
    [
        // action, parent path, priority
        (_x select 0), (_x select 1), (_x select 2)
    ] call zen_context_menu_fnc_addAction;
} forEach _contextActionList;

diag_log format ["CrowsEW:fnc_zeusRegister: Zeus initialization complete. Zeus Enhanced Detected: %2",_hasZen];
