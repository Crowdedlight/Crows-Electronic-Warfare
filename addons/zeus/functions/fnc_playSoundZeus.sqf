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
	
	// manage input on _tarets to get one list
	_targets = [_targets] call FUNC(getListZenOwnersSelection);

	if (count _targets == 0) then {
		// play sound
		[_pos, _range, _sound, _volume, false] call EFUNC(sounds,playSoundPos);
	} else {
		// send event

		[QEGVAR(sounds,playSoundLocal), [_pos, _range, _sound, _volume, true], _targets] call CBA_fnc_targetEvent;
	};
};
[
	"Play Sound (Can't be stopped, be aware of long sounds)", 
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
	{},
	_this
] call zen_dialog_fnc_create;