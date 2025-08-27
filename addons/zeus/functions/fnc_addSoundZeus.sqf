#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_addSoundZeus.sqf
Parameters: pos, _unit
Return: none

Zeus dialog to add sound to object

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

if (isNull _unit) exitWith {hint localize "STR_CROWSEW_Zeus_error_sound"};

private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_sound",
		"_delay",
		"_range",
		"_startDelay",
		"_volume",
		"_repeat",
		"_aliveCondition"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
	
	stopSound GVAR(soundPreview);
	GVAR(soundPreviewSelected) = nil;
	GVAR(soundPreview) = nil;

	// broadcast event to server - params ["_unit", "_loopTime", "_range", "_repeat", "_aliveCondition", "_sound"];
	[QEGVAR(sounds,addSound), [_unit, _delay, _range, _repeat, _aliveCondition, _sound, _startDelay, _volume]] call CBA_fnc_serverEvent;
};

[
	localize "STR_CROWSEW_Zeus_setsound_name", 
	[
		["COMBO",localize "STR_CROWSEW_Zeus_playsound_sound",[
			EGVAR(sounds,soundZeusDisplayKeys),
			EGVAR(sounds,soundZeusDisplay)
			,0]], // list of possible sounds, ideally we would like to preview them when selected.... but that is custom gui right?
		["SLIDER",localize "STR_CROWSEW_Zeus_addsound_delay",[0,120,0,1]], //0 to 120, default 0 and showing 1 decimal.
		["SLIDER",[localize "STR_CROWSEW_Zeus_playsound_range", localize "STR_CROWSEW_Zeus_playsound_range_tooltip"],[0,1000,50,0]], //0 to 500, default 50 and showing 0 decimal
		["SLIDER",localize "STR_CROWSEW_Zeus_addsound_start_delay",[0,500,0,1]], //0 to 500, default 0 and showing 0 decimal
		["SLIDER",localize "STR_CROWSEW_Zeus_playsound_volume",[1,5,2,0]], //1 to 5, default 2 and showing 0 decimal
		["CHECKBOX",localize "STR_CROWSEW_Zeus_addsound_repeat",[true]],
		["CHECKBOX",localize "STR_CROWSEW_Zeus_addsound_remove_when_dead",[true]]
	],
	_onConfirm,
	{stopSound GVAR(soundPreview); GVAR(soundPreviewSelected) = nil; GVAR(soundPreview) = nil;},
	_this
] call zen_dialog_fnc_create;


// This will need to be updated if the UI design is changed
((uiNamespace getVariable "zen_common_display") displayCtrl 1003) ctrlAddEventHandler ["LBSelChanged", {

	params ["_control", "_lbCurSel"];

	// There's probably a better way of doing the below, using just the params above...
	
	// Get the values of all content controls
	private _display = (uiNamespace getVariable "zen_common_display");
	(_display getVariable "zen_dialog_params") params ["_controls", "_onConfirm", "_onCancel", "_args", "_saveID"];
	private _values = _controls apply {
	    _x params ["_controlsGroup", "_settings"];
	    [_controlsGroup, _settings] call (_controlsGroup getVariable "zen_dialog_fnc_value")
	};

	private _selectedSound = _values#0;
	private _volume = _values#4;

	// Check if a new sound file was selected
	if(isNil QGVAR(soundPreviewSelected) || {(GVAR(soundPreviewSelected)) != (_selectedSound)}) then {
		GVAR(soundPreviewSelected) = _selectedSound;

		// Stop the previous preview, and play the new one
		stopSound GVAR(soundPreview);
		GVAR(soundPreview) = playSoundUI [[_selectedSound] call EFUNC(sounds,getSoundPath), _volume];
	};
}];
