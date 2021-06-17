#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_addSoundZeus.sqf
Parameters: pos, _unit
Return: none

Zeus dialog to add sound to object

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

if (isNull _unit) exitWith {hint "Have to select an object to put sound on"};

//ZEN dialog, just ignore ARES, as that mod itself is EOL and links to ZEN
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
	
	// broadcast event to server - params ["_unit", "_loopTime", "_range", "_repeat", "_aliveCondition", "_sound"];
	[QEGVAR(sounds,addSound), [_unit, _delay, _range, _repeat, _aliveCondition, _sound, _startDelay, _volume]] call CBA_fnc_serverEvent;
};
[
	"Set Sound", 
	[
		["COMBO","Sound",[
			["jam_loop", "jam_start"],
			["Jammer Loop Sound", "Computer Startup Sound"]
			,0]], // list of possible sounds, ideally we would like to preview them when selected.... but that is custom gui right?
		["SLIDER","Delay between repeats [s]",[0,120,0,1]], //0 to 120, default 0 and showing 1 decimal.
		["SLIDER","Range it can be heard",[0,500,50,0]], //0 to 500, default 50 and showing 0 decimal // TODO tooltip, 0 means unlimited?
		["SLIDER","Start Delay [s]",[0,500,0,1]], //0 to 500, default 0 and showing 0 decimal
		["SLIDER","Volume",[1,5,2,0]], //1 to 5, default 2 and showing 0 decimal
		["CHECKBOX","Should it repeat the sound?",[true]],
		["CHECKBOX","Remove sound when dead?",[true]]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;