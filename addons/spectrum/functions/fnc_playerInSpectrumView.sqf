#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Landric
			   
File: fnc_playerInSpectrumView.sqf
Parameters: none
Return: bool - true if the (local!) player is in the "GUNNER" view of the Spectrum device

*///////////////////////////////////////////////

(currentWeapon player) isKindOf ["hgun_esd_01_F", configFile >> "CfgWeapons"] &&
{cameraOn == player && {cameraView == "GUNNER"}}