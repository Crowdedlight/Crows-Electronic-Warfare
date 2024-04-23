### Script
You can add jammers with the following scripts executed on a single client. (It updates for all clients automatically)
```c
// _unit: object to set as jammer
// _radFalloff: radius for the falloff effect
// _radEffective: radius for the effective effect
// _isActiveAtMissionStart: should the jammer be enabled straight away
// _capabilities: Array of strings that sets if jammer works against radio and/or drones. Example: ["VoiceCommsJammer","DroneJammer"] for both.
["crowsEW_main_addJammer", [_unit, _radFalloff, _radEffective, _isActiveAtMissionStart, _capabilities]] call CBA_fnc_serverEvent;
```

Be advised that this does not handle adding the sound effect to the jammer. This has to be done manually if wanted same effect as when using the zeus/editor module:
```c
// _unit: jammer object
// _isActiveAtMissionStart: bool that decides if sound effect is active from start
[getPosATL _unit, 50, "jam_start", 3] call EFUNC(sounds,playSoundPos);
["crowsEW_sounds_addSound", [_unit, 0.5, 50, true, true, "jam_loop", 3, 3]] call CBA_fnc_serverEvent;
["crowsEW_sounds_setSoundEnable", [_unit, _isActiveAtMissionStart]] call CBA_fnc_serverEvent;
```
