class Extended_PreInit_EventHandlers {
	class ADDON {
		// This will be executed once in 3DEN, main menu and before briefing has started for every mission
		init = QUOTE( call COMPILE_FILE(XEH_preInit) );
	};
};

class Extended_PostInit_EventHandlers {
	class ADDON {
		// This will be executed once for each mission, once the mission has started
		init = QUOTE( call COMPILE_FILE(XEH_postInit) );
	};
};

class Extended_PreStart_EventHandlers {
	class ADDON {
		// This will be executed once before entering the main menu.
		init = QUOTE( call COMPILE_FILE(XEH_preStart) );
	};
};

// runs once per unit/vehicle after the postInit stage (Event data passed to the handler: [unit] with the unit/vehicle/object, just like a normal init event)
class Extended_InitPost_Eventhandlers {

	class UGV_01_base_F {
		class crowsew_dronesignal_eh {
			init = QUOTE( _this call FUNC(initDroneSignals) );
		};
	};
	class UGV_01_rcws_base_F {
		class crowsew_dronesignal_eh {
			init = QUOTE( _this call FUNC(initDroneSignals) );
		};
	};
	class UAV_03_dynamicLoadout_base_F {
		class crowsew_dronesignal_eh {
			init = QUOTE( _this call FUNC(initDroneSignals) );
		};
	};	
	class UGV_02_Demining_Base_F {
		class crowsew_dronesignal_eh {
			init = QUOTE( _this call FUNC(initDroneSignals) );
		};
	};	
	class UAV_06_antimine_base_F {
		class crowsew_dronesignal_eh {
			init = QUOTE( _this call FUNC(initDroneSignals) );
		};
	};

	// CTRACK - init function for ACE 
	class crowsew_ctrack_effect_5km {
	 	init = QUOTE( _this call FUNC(ctrackInit));
	};
};

// handle get-in and get-out events, so we can move the beacon to the vehicle if c-track is attached to self. 
class Extended_GetInMan_EventHandlers {
    class CAManBase {
		class crowsew_getin_eh {
			getInMan = QUOTE(_this call FUNC(ctrackHandleGetInVehicle));
		};
    };
};
class Extended_GetOutMan_EventHandlers {
    class CAManBase {
		class crowsew_getout_eh {
			getOutMan = QUOTE(_this call FUNC(ctrackHandleGetOutVehicle));
		};
    };
};


// UAV should probably not be included? 
// "UGV_01_base_F", "UGV_01_rcws_base_F", "UAV_03_dynamicLoadout_base_F", "UAV_02_base_F", "UAV_04_base_F"
