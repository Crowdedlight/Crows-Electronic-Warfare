#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_setRadioChatter.sqf

*///////////////////////////////////////////////

// Argument 0 is module logic.
_logic = param [0,objNull,[objNull]];

// Argument 1 is list of affected units (affected by value selected in the 'class Units' argument))
_units = param [1,[],[[]]];

// True when the module was activated, false when it is deactivated (i.e., synced triggers are no longer active)
_activated = param [2,true,[true]];

// sleep for a sec as if we are not using trigger it can fire event before the eventhandlers on serverside har setup. 
sleep 1;

if (count _units < 1) exitWith {
	[QEGVAR(zeus,showHintZeus), ["AddRadioTrackerChatter editor module requires one unit/object synced to it as source"]] call CBA_fnc_globalEvent;
};

// Module specific behavior. Function can extract arguments from logic and use them.
if (_activated) then {
	// Attribute values are saved in module's object space under their class names
	private _pos = getPosASL _logic;
	private _unit = _units#0;
	private _range = _logic getVariable ["Range",2000];
	private _pauseMin = _logic getVariable ["PauseMin",5];
	private _pauseMax = _logic getVariable ["PauseMax",30];
	private _durationMin = _logic getVariable ["DurationMin",5];
	private _durationMax = _logic getVariable ["DurationMax",30];
	private _freqMin = _logic getVariable ["FrequencyMin",220];
	private _freqMax = _logic getVariable ["FrequencyMax",221];
	private _voicePack = _logic getVariable ["VoicePack","british"];

	// broadcast event to server - params ["_unit", "_loopTime", "_range", "_repeat", "_aliveCondition", "_sound"];
	[QEGVAR(spectrum,addRandomRadioTrackingChatter), [_unit, _range, [_pauseMin, _pauseMax], [_durationMin, _durationMax], [_freqMin, _freqMax], _voicePack]] call CBA_fnc_serverEvent;
};
// Module function is executed by spawn command, so returned value is not necessary, but it is good practice.

true;
