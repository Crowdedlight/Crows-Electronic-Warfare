#include "\x\cba\addons\main\script_macros_common.hpp"

#define DFUNC(var1) TRIPLES(ADDON,fnc,var1)

#define GETVAR_SYS(var1,var2) getVariable [ARR_2(QUOTE(var1),var2)]

#define SETVAR_SYS(var1,var2) setVariable [ARR_2(QUOTE(var1),var2)]
#define SETPVAR_SYS(var1,var2) setVariable [ARR_3(QUOTE(var1),var2,true)]

// Macro for mission-namespace, Always public and sync'ed
#define SETMVAR(var1,var2) missionNamespace SETPVAR_SYS(var1,var2)
#define GETMVAR(var1,var2) (missionNamespace GETVAR_SYS(var1,var2))

#ifdef DISABLE_COMPILE_CACHE
    #undef PREP
    #define PREP(fncName) DFUNC(fncName) = compile preprocessFileLineNumbers QPATHTOF(functions\DOUBLES(fnc,fncName).sqf)
#else
    #undef PREP
    #define PREP(fncName) [QPATHTOF(functions\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
#endif
