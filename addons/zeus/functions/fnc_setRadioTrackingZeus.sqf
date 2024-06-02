#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_setRadioTrackingZeus.sqf
Parameters: pos, _unit
Return: none

Set if radio tracking is enabled or not

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//ZEN dialog, just ignore ARES, as that mod itself is EOL and links to ZEN
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_enabled"
	];
	
	// fire event to change 
	[QEGVAR(spectrum,toggleRadioTracking), [_enabled], QEGVAR(spectrum,radioTracking)] call CBA_fnc_globalEventJIP;
};

[
	localize "STR_CROWSEW_Zeus_radiotracking_name", 
	[
		["TOOLBOX:YESNO", [localize "STR_CROWSEW_Zeus_radiotracking_enable", localize "STR_CROWSEW_Zeus_radiotracking_enable_tooltip"], [EGVAR(spectrum,radioTrackingEnabled)], true]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;
