#include "script_component.hpp"

// only on server 
if (!isServer) exitWith {};

// register event listener to fire EMP
private _empId = [QGVAR(eventFireEMP), FUNC(fireEMP)] call CBA_fnc_addEventHandler;

diag_log QFUNC(fireEMP);
