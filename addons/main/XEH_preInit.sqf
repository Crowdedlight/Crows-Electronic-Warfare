#include "script_component.hpp"
#include "XEH_PREP.hpp"

ADDON = true;

// hashmap for the objects
GVAR(jamMap) = createHashMap;

// server only 
if (isServer) then {
	// list of active objects for boosting TFAR
	// [[_emitter, _radius],...]
	GVAR(satcom_active_list) = createHashMap;

	// list of units inside effect area
	GVAR(satcom_boosted_units) = [];
};