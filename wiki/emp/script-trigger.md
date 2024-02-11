# Scripting

You can manually trigger a EMP by script by throwing an CBA serverEvent as shown below. Gets the same setting options as when using the zeus module.

```c++
// _pos: position asl
// _unit: the object/unit its placed on, objNull if using position instead of unit
// _range: The range the EMP is effective in meters. It can be seen further away, but this is the range of the "growing half-dome effect" and the radius where units will loose electric equipment
// _spawnDevice: spawning a "device" at position of EMP, or fire the EMP without spawning a device
// _scopeMode: How should it handle scope with built-in NV or Thermal. 0: Do not remove, 1: replace with basegame 1x scope, 2: remove without giving a replacement 
// _binoMode: How should it handle binoculars with built-in NV or Thermal. 0: Do not remove, 1: replace with basegame binocular, 2: remove without giving a replacement 
["crowsEW_emp_eventFireEMP", [_pos, _unit, _range, _spawnDevice, _scopeMode, _binoMode]] call CBA_fnc_serverEvent;

//example: Fire EMP at position with 500m radius without spawning a "device" object and remove any scopes or binos with NV or thermal built-in.  
["crowsEW_emp_eventFireEMP", [[2508.64,5681.47,171.718], objNull, 500, false, 2, 2]] call CBA_fnc_serverEvent;
```