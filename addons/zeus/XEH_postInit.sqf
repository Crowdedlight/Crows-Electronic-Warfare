#include "script_component.hpp"

// if not a player we don't do anything
if (!hasInterface) exitWith {}; 

// check if TFAR is loaded and set variable
GVAR(hasTFAR) = isClass (configFile >> "CfgPatches" >> "task_force_radio");
GVAR(hasAce) = isClass (configFile >> "CfgPatches" >> "ace_main");
GVAR(hasItcLandSystems) = isClass (configFile >> "CfgPatches" >> "itc_land_common");

// register zeus modules
call FUNC(zeusRegister);

// register CBA keybinding to toggle zeus-drawn text
GVAR(zeusTextDisplayKeybind) = [
	["Crows Electronic Warfare", "Zeus"],
	"zeus_text_display", 
	["Show help display text", "Shows text in zeus view for units with applied modules"], 
	{GVAR(zeusTextDisplay) = !GVAR(zeusTextDisplay)}, 
	"", 
	[DIK_I, [true, true, false]], // [DIK code, [Shift?, Ctrl?, Alt?]]
	false] call CBA_fnc_addKeybind;

// spawn function as we need to check if zeus, and we cannot do that at mission time 0 due to race-condition
private _waitZeus = [player] spawn
{
	params ["_unit"];
	private _timeout = 0;
	waitUntil 
	{
		if (_timeout >= 10) exitWith 
		{
			diag_log format ["CrowsEW:%1: Timed out!!!", "fnc_zeusRegister"];
			true;
		};
		sleep 1;
		_timeout = _timeout + 1;
		if (count allCurators == 0 || {!isNull (getAssignedCuratorLogic _unit)}) exitWith {true};
		false;
	};
	// call function to set eventHandler - Zeus should be initialized by now, so we can check if zeus or not
	if (call FUNC(isZeus)) then {
		call FUNC(addZeusTextDisplayEH);
	};
};
