#include "script_component.hpp"

// register event listener to fire EMP
if (isServer) then {
    [QGVAR(eventFireEMP), FUNC(fireEMP)] call CBA_fnc_addEventHandler;
};

if (hasInterface) then {
    [QGVAR(playerEffect), {_this spawn FUNC(playerEffect)}] call CBA_fnc_addEventHandler;
    [QGVAR(sparkEffect), {_this spawn FUNC(targetSparkSFXSpawner)}] call CBA_fnc_addEventHandler;
    [QGVAR(lightEffect), {_this spawn FUNC(lampEffect)}] call CBA_fnc_addEventHandler;
};