#define COMPONENT spectrum
#include "\z\crowsEW\addons\main\script_mod.hpp"

#include "\a3\ui_f\hpp\defineDIKCodes.inc"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE

#ifdef DEBUG_ENABLED_MAIN
    #define DEBUG_MODE_FULL
#endif
    #ifdef DEBUG_SETTINGS_MAIN
    #define DEBUG_SETTINGS DEBUG_SETTINGS_MAIN
#endif

#include "\z\crowsEW\addons\main\script_macros.hpp"

#define PRIVATE 0 //unusable - only for inheritance
#define HIDDEN 1 //Hidden in Editor/Curator/Arsenal
#define PUBLIC 2 //usable and visible
