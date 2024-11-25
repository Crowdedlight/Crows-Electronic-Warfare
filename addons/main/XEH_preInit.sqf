#include "script_component.hpp"
#include "XEH_PREP.hpp"

ADDON = true;

// hashmap for the objects - Only create locally if not already broadcasted and synced
// format: [_netId, [_unit, _radFalloff, _radEffective, _enabled, _capabilities]];
GVAR(jamMap) = createHashMap;

// server only 
if (isServer) then {
	// list of active objects for boosting TFAR
	// [[_emitter, _radius],...]
	GVAR(satcom_active_list) = createHashMap;

	// list of units inside effect area
	GVAR(satcom_boosted_units) = [];
};

// custom CBA setting to not have zeus immune to jamming
[
    QGVAR(zeus_jam_immune), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX", // setting type
    [localize "STR_CROWSEW_Main_cba_jamming_zeus_immune", localize "STR_CROWSEW_Main_cba_jamming_zeus_immune_tooltip"], 
    ["Crows Electronic Warfare", localize "STR_CROWSEW_Main_cba_jamming"],
    true, // data for this setting: [min, max, default, number of shown trailing decimals]
    nil, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
	FUNC(settingChangedZeusJamImmunity)
] call CBA_fnc_addSetting;
// custom CBA setting to not show jammers markers for zeus
[
    QGVAR(zeus_jam_marker_show), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX", // setting type
    [localize "STR_CROWSEW_Main_cba_jamming_zeus_mapmarker", localize "STR_CROWSEW_Main_cba_jamming_zeus_mapmarker_tooltip"], 
    ["Crows Electronic Warfare", localize "STR_CROWSEW_Main_cba_jamming"],
    true, // data for this setting: [min, max, default, number of shown trailing decimals]
    nil, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
	FUNC(settingChangedZeusMapMarkers)
] call CBA_fnc_addSetting;