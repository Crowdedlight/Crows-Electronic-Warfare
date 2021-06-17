#include "script_component.hpp"
#include "XEH_PREP.hpp"

ADDON = true;

// params ["_unit", "_delayBetween", "_range", "_repeat", "_aliveCondition", "_sound", "_enabled", "_delayInitial"];
GVAR(soundList) = [];

// hashmap with each sound and their playtime
GVAR(soundAttributes) = createHashMap;

// sound configs key: [length]
GVAR(soundAttributes) set ["jam_loop", [0.4, PATHTOF(data\sounds\jam_effect.ogg)]];
GVAR(soundAttributes) set ["jam_start", [0.9, PATHTOF(data\sounds\jam_start.ogg)]];
