#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_addZeusTextDisplayEH.sqf
Parameters: 
Return: none

Adds the drawEvent handlers to zeus to show the helper text for modules applied to units

*///////////////////////////////////////////////

// only if zeus, add draw3D handler for zeus-labels
GVAR(unit_icon_drawEH) = addMissionEventHandler ["Draw3D", {
	// if zeus display is null, exit. Only drawing when zeus display is open
	if (isNull(findDisplay 312)) exitWith {};
	if (isNull _x) exitWith {};
	if (!GVAR(zeusTextDisplay)) exitWith {};

	// cam position
	private _zeusPos = positionCameraToWorld [0,0,0];

	// Radio Chatter 
	{
		_x params ["_unit", "_voicepack"];
		// calculate distance from zeus camera to unit and post in systemchat 
		_dist = _zeusPos distance _unit;

		// if not within 500m, we don't draw it as the text does not scale and disappear with distance
		if (_dist > 500) then {continue;};

		// draw icon on relative pos z: 0
		drawIcon3D ["", [1,0,0,1], ASLToAGL getPosASL _unit, 0, 0, 0, format["%2(%1)", _voicepack, localize "STR_CROWSEW_Zeus_textdisplay_radiochatter"], 1, 0.03, "RobotoCondensed", "center", false];
	} forEach EGVAR(spectrum,radioTrackingAiUnits);

	// Spectrum Signal 
	{
		// figure out if we want to show this objects text
		private _unit = (_y#0)#0; // if key exists, then we would have at least one entry, so taking unit from any of those
		private _dist = _zeusPos distance _unit;

		if (_dist > 500) then {continue;};
		{		
			// if type == chatter, don't show as those will already show "radio Chatter label" 
			if ((_x select 3) == "chatter") then {continue;};
			
			// draw icon on relative pos 
			private _txt = format["%3(%1, RNG:%2)", _x select 1, round(_x select 2), localize "STR_CROWSEW_Zeus_textdisplay_signalsource"];
			// offset: z: -0.5
			private _pos = ASLToAGL getPosASL _unit;
			drawIcon3D ["", [1,0,0,1], [_pos#0, _pos#1, _pos#2-(0.5*(1 + _forEachIndex))], 0, 0, 0, _txt, 1, 0.03, "RobotoCondensed", "center", false];
		} forEach _y;
	} forEach GVAR(zeusTextBeaconMap);

	// Jammer
	{
		_y params ["_jamObj", "_radius", "_strength", "_enabled", "_capabilities"];

		// calculate distance from zeus camera to unit
		private _dist = _zeusPos distance _jamObj;

		// if not within 500m, we don't draw it as the text does not scale and disappear with distance
		if (_dist > 500) then {continue;};

		// draw icon on relative pos 
		private _txt = format["%3(STR:%1,CAP:%2)", _strength, str _capabilities, localize "STR_CROWSEW_Zeus_jammer"];
		// offset: z: 0
		drawIcon3D ["", [1,0,0,1], ASLToAGL getPosASL _jamObj, 0, 0, 0, _txt, 1, 0.03, "RobotoCondensed", "center", false];
	} forEach EGVAR(main,jamMap);

	// AddSound 
	{
		_x params ["_soundObj", "_loopTime", "_range", "_repeat", "_aliveCondition", "_soundPath", "_enabled", "_lastPlayed", "_startDelay", "_volume", "_displayName"];
		
		// calculate distance from zeus camera to unit
		private _dist = _zeusPos distance _soundObj;

		// if not within 500m, we don't draw it as the text does not scale and disappear with distance
		if (_dist > 500) then {continue;};

		// draw icon on relative pos 
		private _txt = format["%4(%1:  RNG:%2, Active:%3)", _displayName, _range, _enabled, localize "STR_CROWSEW_Zeus_sound"];
		// offset: z: 0.5
		private _pos = ASLToAGL getPosASL _soundObj;
		drawIcon3D ["", [1,0,0,1], [_pos#0, _pos#1, _pos#2+0.5], 0, 0, 0, _txt, 1, 0.03, "RobotoCondensed", "center", false];

	} forEach GETMVAR(EGVAR(sounds,activeSounds),[]);
	// PlaySound 
	{
		_x params ["_soundObj", "_displayName"];

		// calculate distance from zeus camera to unit
		private _dist = _zeusPos distance _soundObj;

		// if not within 500m, we don't draw it as the text does not scale and disappear with distance
		if (_dist > 500) then {continue;};

		// draw icon on relative pos 
		private _txt = format["%2 (%1)", _displayName, localize "STR_CROWSEW_Zeus_sound"];
		// offset: z: 0.5
		private _pos = ASLToAGL getPosASL _soundObj;
		drawIcon3D ["", [1,0,0,1], [_pos#0, _pos#1, _pos#2+0.5], 0, 0, 0, _txt, 1, 0.03, "RobotoCondensed", "center", false];

	} forEach GETMVAR(EGVAR(sounds,playedSounds),[]);
	// Jammed units
	{
		// calculate distance from zeus camera to unit
		private _dist = _zeusPos distance _x;

		// if not within 500m, we don't draw it as the text does not scale and disappear with distance
		if (_dist > 500) then {continue;};

		// draw icon on relative pos => Offset: z: -0.6
		private _txt = localize "STR_CROWSEW_Zeus_jammed";
		// offset: z: 1
		private _pos = ASLToAGL getPosASL _x;
		drawIcon3D ["", [1,0,0,1], [_pos#0, _pos#1, _pos#2+1], 0, 0, 0, _txt, 1, 0.03, "RobotoCondensed", "center", false];
	} forEach GETMVAR(EGVAR(spectrum,activeJammedUnits),[]);
	// SATCOM
	{
		_y params ["_obj", "_radius"];

		// calculate distance from zeus camera to unit
		private _dist = _zeusPos distance _obj;

		// if not within 500m, we don't draw it as the text does not scale and disappear with distance
		if (_dist > 500) then {continue;};

		// draw icon on relative pos 
		private _txt = format["%2 (RNG:%1)", _radius, localize "STR_CROWSEW_Zeus_satcom"];
		// offset: z: 0
		drawIcon3D ["", [1,0,0,1], ASLToAGL getPosASL _obj, 0, 0, 0, _txt, 1, 0.03, "RobotoCondensed", "center", false];

	} forEach GETMVAR(EGVAR(main,satcomActiveList),[]);
}];
