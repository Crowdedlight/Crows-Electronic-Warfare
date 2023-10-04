class CBA_Extended_EventHandlers_base;

class CfgVehicles {
	class Thing;
    class ThingX;

	// The object that gets attached in ace, this way we can show and run the functions needed?
    class crowsew_ctrack_effect: ThingX {
        scope = HIDDEN;
        displayName = "C-TRACK";
        model = QPATHTOF(data\c_track\c_track.p3d);
		vehicleClass = "";

		class EventHandlers {
            class CBA_Extended_EventHandlers: CBA_Extended_EventHandlers_base {};
        };
    };
	class crowsew_ctrack_effect_3km : crowsew_ctrack_effect {
		range = 3000;
	};
};

