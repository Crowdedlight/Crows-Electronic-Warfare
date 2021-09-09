#include "script_component.hpp"

// if not a player we don't do anything
if (!hasInterface) exitWith {}; 

// check if TFAR is loaded and set variable
GVAR(hasTFAR) = isClass (configFile >> "CfgPatches" >> "task_force_radio");
GVAR(hasAce) = isClass (configFile >> "CfgPatches" >> "ace_main");
GVAR(hasItcLandSystems) = isClass (configFile >> "CfgPatches" >> "itc_land_common");

// register zeus modules
call FUNC(zeusRegister);

// only if zeus, add draw3D handler for zeus-labels
if (isNull (getAssignedCuratorLogic player)) then {
	GVAR(unit_icon_drawEH) = addMissionEventHandler ["Draw3D", {
		// if zeus display is null, exit. Only drawing when zeus display is open
		if (isNull(findDisplay 312)) exitWith {};
		if (isNull _x) exitWith {};

		// cam position
		private _zeusPos = positionCameraToWorld [0,0,0];

		// Radio Chatter 
		{
			_x params ["_unit", "_voicepack"];
			// calculate distance from zeus camera to unit and post in systemchat 
			_dist = _zeusPos distance _unit;

			// if not within 500m, we don't draw it as the text does not scale and disappear with distance
			if (_dist > 500) then {continue;};

			// draw icon on relative pos 
			drawIcon3D ["", [1,0,0,1], ASLToAGL getPosASL _unit, 0, 0, 0, format["RadioChatter(%1)", _voicepack], 1, 0.03];
		} forEach EGVAR(spectrum,radioTrackingAiUnits);

		// Spectrum Signal 
		{
			// calculate distance from zeus camera to unit and post in systemchat 
			private _unit = _x select 0;
			private _dist = _zeusPos distance _unit;

			// if not within 500m, we don't draw it as the text does not scale and disappear with distance
			if (_dist > 500) then {continue;};

			// if type == chatter, don't show as those will already show "radio Chatter label" 
			if ((_x select 3) == "chatter") then {continue;};

			// draw icon on relative pos 
			private _txt = format["SignalSource(%1, RNG:%2)", _x select 1, round(_x select 2)];
			drawIcon3D ["", [1,0,0,1], ASLToAGL getPosASL _unit, 0, 0, 0, _txt, 1, 0.03];
		} forEach EGVAR(spectrum,beacons);

		// Jammer
		{
			_y params ["_jamObj", "_radius", "_strength", "_enabled"];

			// calculate distance from zeus camera to unit and post in systemchat 
			private _dist = _zeusPos distance _jamObj;

			// if not within 500m, we don't draw it as the text does not scale and disappear with distance
			if (_dist > 500) then {continue;};

			// draw icon on relative pos 
			private _txt = format["Jammer(STR:%1)", _strength];
			drawIcon3D ["", [1,0,0,1], ASLToAGL getPosASL _jamObj, 0, 0, 0, _txt, 1, 0.03];
		} forEach EGVAR(main,jamMap);

		// AddSound 
		{
			_x params ["_soundObj", "_loopTime", "_range", "_repeat", "_aliveCondition", "_soundPath", "_enabled", "_lastPlayed", "_startDelay", "_volume", "_displayName"];
			
			// calculate distance from zeus camera to unit and post in systemchat 
			private _dist = _zeusPos distance _soundObj;

			// if not within 500m, we don't draw it as the text does not scale and disappear with distance
			if (_dist > 500) then {continue;};

			// draw icon on relative pos 
			private _txt = format["Sound(%1:  RNG:%2, RPT:%3)", _displayName, _range, _repeat];
			drawIcon3D ["", [1,0,0,1], ASLToAGL getPosASL _soundObj, 0, 0, 0, _txt, 1, 0.03];

		} forEach EGVAR(sounds,soundList);
	}];
};