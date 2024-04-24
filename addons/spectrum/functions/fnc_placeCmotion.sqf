#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Landric
			   
File: fnc_cmotionPlace.sqf
Parameters: dialogResult
Return: none

Places the C-MOTION device - a motion sensor that will alert the
owner when it detects AI within its range

*///////////////////////////////////////////////

params ["_dialogResult"];

/*/////////////////////////////////////////////////
	Place the actual sensor object &
	set up actions (e.g. pickup, carry, etc.)
*///////////////////////////////////////////////

player removeItem "crowsew_cmotion";
private _cMotion = createVehicle ["crowsew_cmotionObj", getPosATL player, [], 0, "CAN_COLLIDE"];
["zen_common_addObjects", [_cMotion]] call CBA_fnc_serverEvent;

if(EGVAR(zeus,hasAce)) then {
	[_cMotion, true, [0, 1.5, 0], 0] remoteExecCall ["ace_dragging_fnc_setCarryable", 0, true];

	// TODO: fortify/ace-explosive -style place preview?
	[player, _cMotion] call ace_dragging_fnc_startCarry;

	private _pickupAction = [
	    "crowsewPickupCmotion",
	    "Pick up C-MOTION",
	    "",
	    {
	        params ["_target", "_player"];
	        deleteVehicle (_target getVariable [QGVAR(cmotionTrigger), objNull]);
			deleteVehicle _target;
	        _player addItem "crowsew_cmotion";
	    },
	    {true}
	] call ace_interact_menu_fnc_createAction;

	[
		_cMotion,
		0,
		["ACE_MainActions"],
		_pickupAction
	] remoteExecCall ["ace_interact_menu_fnc_addActionToObject", 0, true];

	// TODO: Eventually - add a way to link C-Motion to ACE explosives as a trigger

} else {
	_cMotion setPosASL (getPosASL player);
	_cMotion addAction
	[
		"Pick up C-MOTION",
		{
			params ["_target", "_caller", "_actionId", "_arguments"];
			deleteVehicle (_target getVariable [QGVAR(cmotionTrigger), objNull]);
			deleteVehicle _target;
	        _caller addItem "crowsew_cmotion";
		},
		nil,		// arguments
		1.5,		// priority
		true,		// showWindow
		true,		// hideOnUse
		"",			// shortcut
		"true", 	// condition
		50			// radius
	];
};


/*/////////////////////////////////////////////////
	Set up alert variables (based on dialog)
*///////////////////////////////////////////////

private _i = 1;
if(GVAR(cmotionSpectrum)) then {
	if(_dialogResult#(_i)) then {
		INC(_i);
		_cMotion setVariable [QGVAR(cmotionFreq), _dialogResult#(_i)];
	};
	INC(_i);		
};
if(GVAR(cmotionMarker)) then {
	if(_dialogResult#(_i)) then {
		_cMotion setVariable [QGVAR(cmotionMarkerChannel), currentChannel];
		INC(_i);
		_cMotion setVariable [QGVAR(cmotionMarkerColour), _dialogResult#(_i)];
		INC(_i);
		_cMotion setVariable [QGVAR(cmotionMarkerText), _dialogResult#(_i)];
		INC(_i);
		_cMotion setVariable [QGVAR(cmotionMarkerTimestamp), _dialogResult#(_i)];
	};
	INC(_i);
};

if(GVAR(cmotionAudio)) then {
	if(_dialogResult#(_i)) then {
		INC(_i);
		_cMotion setVariable [QGVAR(cmotionAudio), _dialogResult#(_i)];
	};
	INC(_i); // Not strictly needed, we don't use _i again
};


/*/////////////////////////////////////////////////
	Set up trigger
*///////////////////////////////////////////////

private _motionTrigger = createTrigger ["EmptyDetector", getPosATL _cMotion];
private _radius = _dialogResult#0;
_motionTrigger setTriggerArea [_radius, _radius, 0, false, _radius];
_motionTrigger setTriggerActivation ["ANY", "PRESENT", true];
_motionTrigger setTriggerInterval (GVAR(cmotionInterval)/2); // Halve the interval, to "flip flop" detection
_motionTrigger setTriggerStatements [
	QUOTE([ARR_2(thisTrigger getVariable QQGVAR(cmotionObj),thisList)] call FUNC(motionSensor) && { time >= ((thisTrigger getVariable QQGVAR(cmotionCooldownTimer)) + GVAR(cmotionCooldown)) && {(thisTrigger getVariable QQGVAR(cmotionFlipflop))}}), // Condition
	QUOTE((thisTrigger setVariable [ARR_2(QQGVAR(cmotionCooldownTimer),time)]); thisTrigger setVariable [ARR_2(QQGVAR(cmotionFlipflop),not (thisTrigger getVariable QQGVAR(cmotionFlipflop)))]; [(thisTrigger getVariable QQGVAR(cmotionObj))] call FUNC(triggerCmotion);), // Activation
	QUOTE((thisTrigger setVariable [ARR_2(QQGVAR(cmotionFlipflop),not(thisTrigger getVariable [ARR_2(QQGVAR(cmotionFlipflop),false)]))]);) //Deactivation
];
_motionTrigger attachTo [_cMotion, [0,0,0]];
_motionTrigger setVariable [QGVAR(cmotionObj), _cMotion];
_motionTrigger setVariable [QGVAR(cmotionCooldownTimer), time];
_motionTrigger setVariable [QGVAR(cmotionFlipflop), true]; // Variable to "flipflop" the trigger
_cMotion setVariable [QGVAR(cmotionTrigger), _motionTrigger];

//TODO: server setting to create marker showing sensor area?


// Keep a list of player's cMotions for "emergency" audio kill
private _cmotionList = player getVariable [QGVAR(cmotionList), []];
_cmotionList pushBack _cMotion;
player setVariable [QGVAR(cmotionList), _cmotionList];

/*/////////////////////////////////////////////////
	Set up Event Handlers for kill/delete
*///////////////////////////////////////////////

_cMotion addEventHandler ["Killed", {
	params ["_unit", "_killer", "_instigator", "_useEffects"];
	deleteVehicle (_unit getVariable QGVAR(cmotionTrigger));
	// TODO: Remove option to pick-up destroyed item
}];

_cMotion addEventHandler ["Deleted", {
	params ["_entity"];
	deleteVehicle (_entity getVariable QGVAR(cmotionTrigger));
}];
