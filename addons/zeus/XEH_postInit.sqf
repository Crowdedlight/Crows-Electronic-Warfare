#include "script_component.hpp"

// check if TFAR is loaded and set variable
GVAR(hasTFAR) = isClass (configFile >> "CfgPatches" >> "task_force_radio");
GVAR(hasACRE) = isClass (configFile >> "CfgPatches" >> "acre_main");
GVAR(hasAce) = isClass (configFile >> "CfgPatches" >> "ace_main");
GVAR(hasItcLandSystems) = isClass (configFile >> "CfgPatches" >> "itc_land_common");

// if not a player we don't do anything
if (!hasInterface) exitWith {}; 

// register zeus modules
call FUNC(zeusRegister);

// register hint to zeus callback
[QGVAR(showHintZeus), FUNC(showHintZeus)] call CBA_fnc_addEventHandler;

// register CBA keybinding to toggle zeus-drawn text
GVAR(zeusTextDisplayKeybind) = [
	["Crows Electronic Warfare", "Zeus"],
	"zeus_text_display", 
	["Show help display text", "Shows text in zeus view for units with applied modules"], 
	{GVAR(zeusTextDisplay) = !GVAR(zeusTextDisplay)}, 
	"", 
	[DIK_I, [true, true, false]], // [DIK code, [Shift?, Ctrl?, Alt?]] => default: ctrl + shift + i
	false] call CBA_fnc_addKeybind;

// spawn function as we need to check if zeus, and we cannot do that at mission time 0 due to race-condition
// set eventhandler that waits for player to go into zeus interface, then registeres the textDisplayEHs.... A way to handle the race-condition of not being set as zeus as postinit is run, while being zeus. 
["zen_curatorDisplayLoaded", {
    // remove event immediately
    [_thisType, _thisId] call CBA_fnc_removeEventHandler;
    call FUNC(addZeusTextDisplayEH);
}] call CBA_fnc_addEventHandlerArgs;