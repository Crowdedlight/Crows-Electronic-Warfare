#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: b-mayr-1984 - Bernhard Mayr
			   
File: fnc_disconnectPlayerUAV.sqf
Parameters: _player 	player that shall be disconnected from drone
			_drone		the drone from which to disconnect

Return: n.a.

Script is used to disconnect players, that are currently remote controlling a drone, 
from said drone.

Includes special case handling for Zeuses that are remote controlling via Zeus.

*///////////////////////////////////////////////

params [["_player", objNull 	/* player that shall be disconnected from drone */],
		["_drone",  objNull 	/* the drone from which to disconnect */]];

if (isNull _player || isNull _drone) exitWith {};	// sanity check

_player connectTerminalToUAV objNull;	// disconnect player from any drone

//detect a remote controlling Zeus
if (isNull (getConnectedUAV _player)  &&  _player in (UAVControl _drone) ) then {
	// systemChat "This player is remote controlling a unit as Zeus";

	// display red JAMMED message sligthly above center of screen
	[parseText "<t color='#ff0000'>JAMMED!</t>",-1,0.3,0.2,0.1,0,789] spawn BIS_fnc_dynamicText;
};
