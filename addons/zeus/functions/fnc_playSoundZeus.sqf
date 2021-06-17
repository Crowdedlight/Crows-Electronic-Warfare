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
		"_sound",
		"_range",
		"_volume"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
	
	// play sound
	[_pos, _range, _sound, _volume] call EFUNC(sounds,playSoundPos);
};
[
	"Play Sound", 
	[
		["COMBO","Sound",[
			["jam_loop", "jam_start"],
			["Jammer Loop Sound", "Computer Startup Sound"]
			,0]], // list of possible sounds, ideally we would like to preview them when selected.... but that is custom gui right?
		["SLIDER","Range it can be heard",[0,500,50,0]], //0 to 500, default 50 and showing 0 decimal // TODO tooltip, 0 means unlimited?
		["SLIDER","Volume",[1,5,2,0]] //1 to 5, default 2 and showing 0 decimal
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;