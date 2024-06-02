#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_showHintZeus.sqf
Parameters: 
Return:

*///////////////////////////////////////////////
params ["_message"];

if (call FUNC(isZeus)) then {
	hint (_message call BIS_fnc_localize);
	systemChat (_message call BIS_fnc_localize);
	diag_log "CrowsEW: " + _message;
};
