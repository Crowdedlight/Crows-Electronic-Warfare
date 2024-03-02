#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Landric
			   
File: fnc_cmotionDialog.sqf
Parameters: none
Return: none

Create the dialog for placing the C-MOTION device;
dynamically shows/hides relevant options

*///////////////////////////////////////////////

if(isNil QGVAR(cMotionUIValues)) then {
	GVAR(cMotionUIValues) = [GVAR(cmotionMaxRange)];

	if(GVAR(cmotionSpectrum)) then {
		GVAR(cMotionUIValues) pushBack true;
		GVAR(cMotionUIValues) pushBack 460;
	};

	if(GVAR(cmotionMarker)) then {
		GVAR(cMotionUIValues) pushBack true;
		GVAR(cMotionUIValues) pushBack 2;
		GVAR(cMotionUIValues) pushBack "Motion Alert";
		GVAR(cMotionUIValues) pushBack true;
	};

	if(GVAR(cmotionAudio)) then {
		GVAR(cMotionUIValues) pushBack true;
		GVAR(cMotionUIValues) pushBack 0;
	};
};
private _values = GVAR(cMotionUIValues);

private _options = [];

_options pushBack ["SLIDER","Sensor Radius (m)",[0.5,GVAR(cmotionMaxRange),GVAR(cmotionMaxRange),1]];

// TODO: overwrite the default values with the last values (e.g. if the dialog has been dynamically destroyed and recreated)

private _dynamicControls = createHashMapFromArray [["freq", -1], ["marker", -1], ["audio", -1]];


private _i = 1;
if(GVAR(cmotionSpectrum)) then {
	_dynamicControls set ["freq", _i];
	if(_values#(_i)) then {
		_options pushBack ["Checkbox",["Enable Frequency Alert", "When triggered, a signal source is created"+endl+"This can be detected by the spectrum device"],true];
		_options pushBack ["SLIDER","Frequency (Unique)",[390,500,460,1]];
		INC(_i);
	} else {
		_options pushBack ["Checkbox",["Enable Frequency Alert", "When triggered, a signal source is created"+endl+"This can be detected by the spectrum device"],false];
	};
	INC(_i);
};

if(GVAR(cmotionMarker)) then {
	_dynamicControls set ["marker", _i];
	if(_values#(_i)) then {
		_options pushBack ["Checkbox",["Enable Marker Alert", "When triggered, a map marker is created"],true];
		_options pushBack ["COMBO","Marker Colour", [
			["ColorBlack", "ColorWhite", "ColorRed", "ColorGreen", "ColorBlue", "ColorYellow", "ColorWEST", "ColorEAST", "ColorGUER", "ColorCIV"], // Must only contain colours from CfgMarkerColors
			["Black", "White", "Red", "Green", "Blue", "Yellow", "WEST", "EAST", "GUER", "CIV"],
			2
		]];
		INC(_i);
		_options pushBack ["EDIT","Marker Text", ["Motion Alert", {}]];
		INC(_i);
		_options pushBack ["CHECKBOX",["Append Timestamp", "Append the current time to the alert marker"], true];
		INC(_i);
	} else {
		_options pushBack ["Checkbox",["Enable Marker Alert", "When triggered, a map marker is created"],false];
	};
	INC(_i);
};

if(GVAR(cmotionAudio)) then {
	_dynamicControls set ["audio", _i];
	if(_values#(_i)) then {
		_options pushBack ["Checkbox",["Enable Audio Alert", "When triggered, an audio alert is played"+endl+"This will only be heard by you"],true];
		_options pushBack ["COMBO","Alert Sound", [
			["sos_morse_code", "what_hath_god_wrought_morse_code", "telephone_ringing", "old_telephone_ringing", "spaceship_alarm"],
			["Morse Code 1 (6s)", "Morse Code 2 (12s)", "Ring 1 (12s)", "Ring 2 (13s)", "Alarm (3s)"],
			0
		]];
		INC(_i);
	} else {
		_options pushBack ["Checkbox",["Enable Audio Alert", "When triggered, an audio alert is played"+endl+"This will only be heard by you"],false];		
	};
	INC(_i); // Not strictly needed, we don't use _i again for this
};

[
	"C-MOTION Alarm Options", 
	_options,
	FUNC(placeCmotion),
	{
		(_display getVariable "zen_dialog_params") params ["_controls", "_onConfirm", "_onCancel", "_args", "_saveID"];
		private _values = _controls apply {
		    _x params ["_controlsGroup", "_settings"];
		    [_controlsGroup, _settings] call (_controlsGroup getVariable "zen_dialog_fnc_value")
		};
		GVAR(cMotionUIValues) = _values;
	},
	[_dynamicControls]
] call zen_dialog_fnc_create;

private _allControls = allControls (uiNamespace getVariable "zen_common_display");
private _checkboxes = _allControls select { ctrlType _x == 77};

// TODO: really not happy with the amount of "magic numbers" floating around in creating/executing these EHs

// Frequency checkbox EH
if(GVAR(cmotionSpectrum)) then {
	_checkboxes#0 ctrlAddEventHandler ["CheckedChanged", {
		params ["_control", "_checked"];

		// Get (and store) the current values of all content controls
		((uiNamespace getVariable "zen_common_display") getVariable "zen_dialog_params") params ["_controls", "_onConfirm", "_onCancel", "_args", "_saveID"];
		private _values = _controls apply {
		    _x params ["_controlsGroup", "_settings"];
		    [_controlsGroup, _settings] call (_controlsGroup getVariable "zen_dialog_fnc_value")
		};

		private _checkboxIndex = _args#0 get "freq";
		if(_checked == 1) then {
			_values insert [_checkboxIndex+1, [460], false];
		} else {
			_values deleteRange [_checkboxIndex+1,1];
		};

		// Recreate the display	
		closeDialog 2;
		GVAR(cMotionUIValues) = _values;
		call FUNC(cmotionDialog);	
	}];
	_checkboxes deleteAt 0;
};

// Marker checkbox EH
if(GVAR(cmotionMarker)) then {
	private _blockPresent = cbChecked (_checkboxes#0);

	_checkboxes#0 ctrlAddEventHandler ["CheckedChanged", {
		params ["_control", "_checked"];

		// Get (and store) the current values of all content controls
		((uiNamespace getVariable "zen_common_display") getVariable "zen_dialog_params") params ["_controls", "_onConfirm", "_onCancel", "_args", "_saveID"];
		private _values = _controls apply {
		    _x params ["_controlsGroup", "_settings"];
		    [_controlsGroup, _settings] call (_controlsGroup getVariable "zen_dialog_fnc_value")
		};

		private _checkboxIndex = _args#0 get "marker";
		if(_checked == 1) then {
			_values insert [_checkboxIndex+1, ["ColorRed", "Motion Alert", true], false];
		} else {
			_values deleteRange [_checkboxIndex+1,3];
		};

		// Recreate the display	
		closeDialog 2;
		GVAR(cMotionUIValues) = _values;
		call FUNC(cmotionDialog);	
	}];
	_checkboxes deleteAt 0;

	// This "block" also contains a checkbox
	// Make sure we remove it (if this block is present)
	if(_blockPresent) then {
		_checkboxes deleteAt 0;
	};
};

// Audio checkbox EH
if(GVAR(cmotionAudio)) then {
	_checkboxes#0 ctrlAddEventHandler ["CheckedChanged", {
		params ["_control", "_checked"];

		// Get (and store) the current values of all content controls
		((uiNamespace getVariable "zen_common_display") getVariable "zen_dialog_params") params ["_controls", "_onConfirm", "_onCancel", "_args", "_saveID"];
		private _values = _controls apply {
		    _x params ["_controlsGroup", "_settings"];
		    [_controlsGroup, _settings] call (_controlsGroup getVariable "zen_dialog_fnc_value")
		};

		private _checkboxIndex = _args#0 get "audio";
		if(_checked == 1) then {
			_values insert [_checkboxIndex+1, ["sos_morse_code"], false];
		} else {
			_values deleteRange [_checkboxIndex+1,1];
		};

		// Recreate the display	
		closeDialog 2;
		GVAR(cMotionUIValues) = _values;
		call FUNC(cmotionDialog);	
	}];
	_checkboxes deleteAt 0; // Not strictly needed
};
