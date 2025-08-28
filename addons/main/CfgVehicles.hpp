class CBA_Extended_EventHandlers_base;

 class CfgVehicles
 {
	class Land_DataTerminal_01_F;
	// class Crows_dataterminal: Land_DataTerminal_01_F
	// have to overwrite basegame classname, as otherwise the 
	class Crows_dataterminal: Land_DataTerminal_01_F
	{
		class EventHandlers {
			class CBA_Extended_EventHandlers: CBA_Extended_EventHandlers_base {};
		};
		displayName = "Data Terminal (destructible)";
		scope = 2;          // 2 = class is available in the editor; 1 = class is unavailable in the editor, but can be accessed via a macro; 0 = class is unavailable (and used for inheritance only).
		scopeCurator = 2;   // 2 = class is available in Zeus; 0 = class is unavailable in Zeus.
		author = "Crowdedlight";
		// cost = 200000;
		ACE_offset[] = {0, 0, 0};  // Offset of the interaction point from the model in meters on the X,Y,Z axis. Try setting this to the place where it makes most sense (e.g. to buttons/switches/pins)
		// vehicleClass = "Cargo";
		// simulation = "house";
		// simulation = "thing";
		// entries not set by default but thing requires being set
		// submerged = 0;
		// submergeSpeed = 0;
		// timeToLive = 1e+20;
		// disappearAtContact = 0;
		// airFriction0[] = {0.01,0.01,0.01};
		// airFriction1[] = {0.01,0.01,0.01};
		// airFriction2[] = {0.01,0.01,0.01};
		// airRotation = 0;
		// gravityFactor = 1;
		// minHeight = 0.1;
		// avgHeight = 0.2;
		// maxHeight = 0.4;
	};
 };
