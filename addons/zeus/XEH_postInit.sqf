#include "script_component.hpp"

// if not a player we don't do anything
if (!hasInterface) exitWith {}; 

// check if TFAR is loaded and set variable
GVAR(hasTFAR) = isClass (configFile >> "CfgPatches" >> "task_force_radio");

// register zeus modules
call FUNC(zeusRegister);
