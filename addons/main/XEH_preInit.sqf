#include "script_component.hpp"
#include "XEH_PREP.hpp"

ADDON = true;

// hashmap for the objects - Only create locally if not already broadcasted and synced
// format: [_netId, [_unit, _rad, _strength, _enabled, _capabilities]];
GVAR(jamMap) = createHashMap;

// server only 
if (isServer) then {
	// list of active objects for boosting TFAR
	// [[_emitter, _radius],...]
	GVAR(satcom_active_list) = createHashMap;

	// list of units inside effect area
	GVAR(satcom_boosted_units) = [];
};