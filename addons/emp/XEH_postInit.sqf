#include "script_component.hpp"

// register event listener to fire EMP
if (isServer) then {
    [QGVAR(eventFireEMP), FUNC(fireEMP)] call CBA_fnc_addEventHandler;
};

if (hasInterface) then {
    [QGVAR(playerEffect), FUNC(playerEffect)] call CBA_fnc_addEventHandler;
    [QGVAR(sparkEffect), FUNC(targetSparkSFXSpawner)] call CBA_fnc_addEventHandler;
    [QGVAR(lightEffect), FUNC(lampEffect)] call CBA_fnc_addEventHandler;
};