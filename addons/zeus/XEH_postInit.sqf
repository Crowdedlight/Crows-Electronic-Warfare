#include "script_component.hpp"

// if not a player we don't do anything
if (!hasInterface) exitWith {}; 

// register zeus modules
call FUNC(zeusRegister);