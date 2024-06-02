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
		[localize "STR_CROWSEW_Zeus_modules_spectrumsignal_add",{_this call FUNC(addSpectrumBeaconZeus)}, QPATHTOF(data\spectrum_signal.paa)],
		[localize "STR_CROWSEW_Zeus_modules_spectrumsignal_remove",{_this call FUNC(removeSpectrumBeaconZeus)}, QPATHTOF(data\spectrum_signal.paa)],
		[localize "STR_CROWSEW_Zeus_modules_addsound",{_this call FUNC(addSoundZeus)}, "\a3\modules_f_curator\Data\iconSound_ca.paa"],
		[localize "STR_CROWSEW_Zeus_modules_removesound",{_this call FUNC(removeSoundZeus)}, "\a3\modules_f_curator\Data\iconSound_ca.paa"],
		[localize "STR_CROWSEW_Zeus_modules_playsound",{_this call FUNC(playSoundZeus)}, "\a3\modules_f_curator\Data\iconSound_ca.paa"],
		[localize "STR_CROWSEW_Zeus_modules_fireemp",{_this call FUNC(fireEMPZeus)}, QPATHTOF(data\EMP_Icon.paa)], 
		[localize "STR_CROWSEW_Zeus_modules_immuneemp",{_this call FUNC(setImmuneEMPZeus)}, QPATHTOF(data\EMP_Icon_IMU.paa)], 
		[localize "STR_CROWSEW_Zeus_modules_radiochatter_add",{_this call FUNC(addRandomRadioTrackingChatterZeus)}, QPATHTOF(data\EMP_Icon_IMU.paa)], 
		[localize "STR_CROWSEW_Zeus_modules_radiochatter_remove",{_this call FUNC(removeRandomRadioTrackingChatterZeus)}, QPATHTOF(data\EMP_Icon_IMU.paa)], 
		[localize "STR_CROWSEW_Zeus_modules_jammable",{_this call FUNC(setUnitJammableZeus)}, QPATHTOF(data\spectrum_signal.paa)],
		[localize "STR_CROWSEW_Zeus_modules_jammer_add",{_this call FUNC(addJammerZeus)}, "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa"],
		[localize "STR_CROWSEW_Zeus_modules_jammer_remove",{_this call FUNC(removeJammerZeus)}, "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa"]
	];
	private _tfarModules = [
		[localize "STR_CROWSEW_Zeus_modules_radiotracking",{_this call FUNC(setRadioTrackingZeus)}, "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa"]
	];
	private _radioModules = [
		[localize "STR_CROWSEW_Zeus_modules_addsatcom",{_this call FUNC(addSatcomZeus)}, "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa"], //TODO SATELLITE DISH ICON
		[localize "STR_CROWSEW_Zeus_modules_removesatcom",{_this call FUNC(removeSatcomZeus)}, "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa"] //TODO SATELLITE DISH ICON
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
        [QGVAR(context_menu_jammer),localize "STR_CROWSEW_Zeus_contextmenu_jammer","\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa", {}, {!isNull _hoveredEntity && {_hoveredEntity getVariable[QEGVAR(main,isJammer), false]}}, [], {[
			[[QGVAR(context_menu_toggle_jammer_on_off),localize "STR_CROWSEW_Zeus_contextmenu_on_off","\a3\modules_f\data\portraitmodule_ca.paa", {[null, null, null, [netId _hoveredEntity]] call EFUNC(main,actionJamToggle)}] call zen_context_menu_fnc_createAction, [], 0]
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
