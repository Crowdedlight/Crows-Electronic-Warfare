#include "script_component.hpp"

// only players
if (hasInterface) then {
	// register CBA event for playing local sound
	private _localSoundId = [QGVAR(playSoundLocal), FUNC(playSoundPos)] call CBA_fnc_addEventHandler;
};

// only if we are on server
if (!isServer) exitWith {}; 

// register event callback, "addSound", as rest is local, event runs local jam function that adds to array and starts the while loop 
private _addId = [QGVAR(addSound), FUNC(addSound)] call CBA_fnc_addEventHandler;
private _removeId = [QGVAR(removeSound), FUNC(removeSound)] call CBA_fnc_addEventHandler;
private _enabledId = [QGVAR(setSoundEnable), FUNC(setSoundEnable)] call CBA_fnc_addEventHandler;

// due to best practices we are gonna put the track loop in unscheduled space. 
// TODO, remove/add PFH based if any sources are active... 
GVAR(PFH_SoundHandler) = [FUNC(soundLoopServer) , 0.1] call CBA_fnc_addPerFrameHandler; 
