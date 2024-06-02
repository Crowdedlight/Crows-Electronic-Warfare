class CBA_Extended_EventHandlers_base;

 class CfgVehicles
 {
	class Land_Device_slingloadable_F;
	class Crows_Emp_Device: Land_Device_slingloadable_F
	{
		class EventHandlers {
			init = QUOTE([(_this select 0)] call FUNC(initTriggerEMP););
			class CBA_Extended_EventHandlers: CBA_Extended_EventHandlers_base {};
		};
		displayName = "$STR_CROWSEW_EMP_device_name";
		scope = 2; // available in editor
		scopeCurator = 2; // available in zeus
		author = "Crowdedlight";
		cost = 200000;
		ACE_offset[] = {0, 0, 0};  // Offset of the interaction point from the model in meters on the X,Y,Z axis. Try setting this to the place where it makes most sense (e.g. to buttons/switches/pins)
		vehicleClass = "Cargo";
		// class ACE_Actions {
		// 	class ACE_MainActions {
		// 		selection = "";
		// 		distance = 2;
		// 		condition = "true";
		// 		class ACE_SetTrigger {
		// 			selection = "";
		// 			displayName = "Select a Trigger";
		// 			condition = "true";
		// 			statement = "";
		// 			insertChildren = "[_target getVariable ""ace_explosives_class"", _target, _player] call ace_explosives_fnc_addTriggerActions;";
		// 			showDisabled = 0;
		// 			exceptions[] = {"isNotSwimming"};
		// 			icon = "\z\ace\addons\explosives\UI\Explosives_Menu_ca.paa";
		// 		};
		// 	};
		// };
	};
 };


// using the explosive systems is very messy as its made for placeable explosions. Make my own so I got control over it instead. //

 // use init function to register ACE actions. (base-game when ace is not loaded)
 // show option to select trigger only when either one of the two ACE clackers are in inventory
 // Selecting a trigger => changing action on object to "remove trigger", Add action to player under explosives as "detonate EMP". Set var on object as trigger is linked, remove option for other players to select trigger
 // triggering "detonate EMP", fire EMP, remove actions on device and player to avoid multiple detonations. Set damage on object
 // "remove trigger" function: set var to allow people to set trigger on it again. Remove detonate action from player
