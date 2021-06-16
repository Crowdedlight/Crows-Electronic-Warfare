#include "script_component.hpp"
#include "XEH_PREP.hpp"

ADDON = true;

// params ["_unit", "_delay", "_range", "_repeat", "_aliveCondition", "_sound", "_enabled"];
GVAR(soundList) = [];

// hashmap with each sound and their playtime
GVAR(soundAttributes) = createHashMap;

// sound configs key: [length]
GVAR(soundAttributes) set ["jam_loop", 0.4];
GVAR(soundAttributes) set ["jam_start", 0.9];
