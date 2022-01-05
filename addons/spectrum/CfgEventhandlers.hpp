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
		init = QUOTE( _this call FUNC(initDroneSignals) );
	};
	class UGV_01_rcws_base_F {
		init = QUOTE( _this call FUNC(initDroneSignals) );
	};
	class UAV_03_dynamicLoadout_base_F {
		init = QUOTE( _this call FUNC(initDroneSignals) );
	};	
	class UGV_02_Demining_Base_F {
		init = QUOTE( _this call FUNC(initDroneSignals) );
	};	
	class UAV_06_antimine_base_F {
		init = QUOTE( _this call FUNC(initDroneSignals) );
	};
};


// UAV should probably not be included? 
// "UGV_01_base_F", "UGV_01_rcws_base_F", "UAV_03_dynamicLoadout_base_F", "UAV_02_base_F", "UAV_04_base_F"
