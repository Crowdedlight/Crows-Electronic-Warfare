#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Landric
			   
File: fnc_playerHasGPSCapability.sqf
Parameters: none
Return: bool - true if the (local!) player has a GPS (or UAV terminal) equipped

*///////////////////////////////////////////////

(player getSlotItemName 612) isKindOf ["ItemGPS", configFile >> "CfgWeapons"] ||
{(player getSlotItemName 612) isKindOf ["UavTerminal_base", configFile >> "CfgWeapons"]}