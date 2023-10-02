class CBA_Extended_EventHandlers_base;

class CfgVehicles {
	class Thing;
    class ThingX;

	// The object that gets attached in ace, this way we can show and run the functions needed?
	// TODO, can we get on-init or similar? 
    class crowsew_ctrack_effect: ThingX {
        scope = HIDDEN;
        displayName = "C-TRACK";
        model = QPATHTOF(data\c_track\c_track.p3d);
        // simulation = "thing";

        side = 7;//-1=NO_SIDE yellow box,3=CIV grey box,4=NEUTRAL yellow box,6=FRIENDLY green box,7=LOGIC no radar signature
        accuracy = 1000;
        cost = 0;
        armor = 500;
        threat[] = {0,0,0};
        nameSound = "";
        type = 1;
        weapons[] = {};
        magazines[] = {};
		vehicleClass = "";
        destrType = "DestructNo";

		class EventHandlers {
            class CBA_Extended_EventHandlers: CBA_Extended_EventHandlers_base {};
        };
    };
	class crowsew_ctrack_effect_5km : crowsew_ctrack_effect {
		range = 5000;
	};
};