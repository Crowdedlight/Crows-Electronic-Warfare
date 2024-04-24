#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Landric
			   
File: fnc_cmotionNoACE.sqf
Parameters: none
Return: none

Set up the C-MOTION for use without ACE-interact

*///////////////////////////////////////////////

player addAction
[
	"Place C-MOTION",
	{
		call FUNC(cmotionDialog);
	},
	nil,		// arguments
	1.5,		// priority
	true,		// showWindow
	true,		// hideOnUse
	"",			// shortcut
	"'crowsew_cmotion' in (items player)", // condition // TODO: add exclusions (e.g. swimming, climbing, surrendered, etc.)
	-1			// radius
];