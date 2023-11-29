#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_playSoundZeus.sqf
Parameters: pos, _unit
Return: none

Zeus dialog to add sound to object

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//ZEN dialog, just ignore ARES, as that mod itself is EOL and links to ZEN
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_targets",
		"_sound",
		"_range",
		"_volume"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

	// Clear sound preview
	stopSound GVAR(soundPreview);
	GVAR(soundPreviewSelected) = nil;
	GVAR(soundPreview) = nil;
	
	// manage input on _tarets to get one list
	_targets = [_targets] call FUNC(getListZenOwnersSelection);

	_soundIDList = [];
	if (count _targets == 0) then {
		// play sound
		private _soundID = ([_pos, _range, _sound, _volume, false] call EFUNC(sounds,playSoundPos));
		_soundIDList pushBack _soundID;
	} else {
		// send event
		[QEGVAR(sounds,playSoundLocal), [_pos, _range, _sound, _volume, true], _targets] call CBA_fnc_targetEvent;
		// TODO: how to get soundID from this?
	};

	// Attach the sound ID list to a logic object, so it can be deleted mid-play
	_logicCenter = createCenter sideLogic;
	_logicGroup = createGroup _logicCenter;
	_logic = _logicGroup createUnit ["Logic", _pos, [], 0, "NONE"];
	_logic setVariable [QGVAR(soundIDList), _soundIDList, true];
	_logic addEventHandler ["Deleted", {
		params ["_entity"];
		private _playedSounds = GETMVAR(EGVAR(sounds,playedSounds),[]);
		_playedSounds = _playedSounds - (_playedSounds select {(_x#0) isEqualTo _entity || isNull (_x#0)});
		SETMVAR(EGVAR(sounds,playedSounds),_playedSounds);

		{ stopSound _x } forEach (_entity getVariable [QGVAR(soundIDList), []]); 
	}];
	[_logic, [_sound] call EFUNC(sounds,getSoundLength)] spawn {
		params ["_logic", "_delay"];
		sleep _delay;
		deleteVehicle _logic;
	};
	["zen_common_updateEditableObjects", [[_logic]]] call CBA_fnc_serverEvent;

	private _playedSounds = GETMVAR(EGVAR(sounds,playedSounds),[]);
	_playedSounds pushBack [_logic, [_sound] call EFUNC(sounds,getSoundName)];
	SETMVAR(EGVAR(sounds,playedSounds),_playedSounds);
};

[
	"Play Sound (Can't be stopped if targetted, be aware of long sounds)", 
	[
		["OWNERS",["Targets to play sound. If none is selected it will play globally for all", "If none selected it will play globally, otherwise it will play local only for selected players"],[[],[],[],2], true], //no preselected defaults, and default tab open is players. Forcing defaults to deselect tp selection.
		["COMBO","Sound",[
			EGVAR(sounds,soundZeusDisplayKeys),
			EGVAR(sounds,soundZeusDisplay)
			,0]], // list of possible sounds, ideally we would like to preview them when selected.... but that is custom gui right?
		["SLIDER",["Range it can be heard [m]", "0 range is unlimited distance"],[0,1000,0,0]], //0 to 500, default 50 and showing 0 decimal
		["SLIDER","Volume",[1,5,2,0]] //1 to 5, default 2 and showing 0 decimal
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

	private _selectedSound = _values#1;
	private _volume = _values#3;

	// Check if a new sound file was selected
	if(isNil QGVAR(soundPreviewSelected) || {(GVAR(soundPreviewSelected)) != (_selectedSound)}) then {
		GVAR(soundPreviewSelected) = _selectedSound;

		// Stop the previous preview, and play the new one
		stopSound GVAR(soundPreview);
		GVAR(soundPreview) = playSoundUI [[_selectedSound] call EFUNC(sounds,getSoundPath), _volume];
	};
}];