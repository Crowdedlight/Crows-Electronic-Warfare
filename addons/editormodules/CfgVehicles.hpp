class CfgVehicles
{
	class Logic;
	class Module_F: Logic
	{
		class AttributesBase
		{
			class Default;
			class Edit;					// Default edit box (i.e. text input field)
			class EditShort;
			class Combo;				// Default combo box (i.e. drop-down menu)
			class Checkbox;				// Default checkbox (returned value is Boolean)
			class CheckboxNumber;		// Default checkbox (returned value is Number)
			class ModuleDescription;	// Module description
			class Units;				// Selection of units on which the module is applied
		};

		// // Description base classes (for more information see below):
		class ModuleDescription
		{
			class Anything;
		};

		// class ArgumentsBaseUnits;
        // class ModuleDescription;
	};

	// Helping pages 
	// https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes:_Controls#Slider
	// https://community.bistudio.com/wiki/Modules 
	// https://github.com/acemod/ACE3/blob/62055d2605839c1254a75c33eacaecef0d414873/addons/fortify/CfgVehicles.hpp 

	class GVAR(moduleAddSignalSource): Module_F
	{
		// Standard object definitions:
		scope = 2;										// Editor visibility; 2 will show it in the menu, 1 will hide it.
		displayName = "Set Signal Source";				// Name displayed in the menu
		icon = QPATHTOEF(zeus,data\spectrum_signal.paa);	// Map icon. Delete this entry to use the default icon.
		vehicleClass = "Modules";
		category = "crowsEW_modules";
		function = QFUNC(addSignalSource);	// Name of function triggered once conditions are met
		functionPriority = 1;				// Execution priority, modules with lower number are executed first. 0 is used when the attribute is undefined
		isGlobal = 0;						// 0 for server only execution, 1 for global execution, 2 for persistent global execution
		isTriggerActivated = 1;				// 1 for module waiting until all synced triggers are activated
		isDisposable = 1;					// 1 if modules is to be disabled once it is activated (i.e. repeated trigger activation won't work)
		is3DEN = 0;							// 1 to run init function in Eden Editor as well
		// curatorInfoType = "RscDisplayAttributeModuleNuke"; // Menu displayed when the module is placed or double-clicked on by Zeus

		// Module attributes (uses https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes#Entity_Specific):
		class Attributes: AttributesBase 
		{
			// Arguments shared by specific module type (have to be mentioned in order to be present):
			// class Units: Units{};

			// Module-specific arguments:
			class Frequency: Edit
			{
				property = QGVAR(addsignalsource_freq);							// Unique property (use "<tag>_<moduleClass>_<attributeClass>" format to ensure that the name is unique)
				displayName = "Frequency (390Mhz to 500Mhz)";					// Argument label
				tooltip = "What frequency the Signal source will broadcast on";	// Tooltip description
				typeName = "NUMBER";											// Value type, can be "NUMBER", "STRING" or "BOOL"
				defaultValue = "460";											// Default attribute value. Warning: This is an expression, and its returned value will be used (50 in this case).
			};

			class Range: Edit
			{
				property = QGVAR(addsignalsource_range);
				displayName = "Range (1m to 5000m)";
				tooltip = "Range it can be seen from";
				typeName = "NUMBER";
				defaultValue = "300"
			};			

			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription 
		{
			description = "Sets a signal source to the synced object with the chosen range and frequency.";	// Short description, will be formatted as structured text
		};
	};

	// Jammer
	class GVAR(moduleAddJammer): Module_F
	{
		// Standard object definitions:
		scope = 2;										
		displayName = "Set Jammer";				
		icon = "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa";	
		vehicleClass = "Modules";
		category = "crowsEW_modules";
		function = QFUNC(addJammer);	
		functionPriority = 1;				
		isGlobal = 0;						
		isTriggerActivated = 1;				
		isDisposable = 1;					
		is3DEN = 0;							

		// Module attributes (uses https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes#Entity_Specific):
		class Attributes: AttributesBase 
		{
			// Arguments shared by specific module type (have to be mentioned in order to be present):
			// class Units: Units{};

			// Module-specific arguments:
			class Radius: Edit
			{
				property = QGVAR(addjammer_radius);							
				displayName = "Radius of jammer (10 to 5000m)";					
				tooltip = "What frequency the Signal source will broadcast on";	
				typeName = "NUMBER";											
				defaultValue = "500";											
			};

			class Strength: Edit
			{
				property = QGVAR(addjammer_strength);
				displayName = "Strength (0 to 100)";
				tooltip = "How strong the jammer is, so how much jammer is increased based on distance into the radius";
				typeName = "NUMBER";
				defaultValue = "50"
			};			

			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription 
		{
			description = "Sets the synced object as a jammer with set radius and strength. If no unit is synced to it, it will spawn a data-terminal and use that as jammer object.";	
		};
	};
	// Fire EMP
	class GVAR(moduleFireEMP): Module_F
	{
		// Standard object definitions:
		scope = 2;										
		displayName = "Fire EMP";				
		icon = QPATHTOEF(zeus,data\EMP_Icon.paa);	
		vehicleClass = "Modules";
		category = "crowsEW_modules";
		function = QFUNC(fireEMP);	
		functionPriority = 1;				
		isGlobal = 0;						
		isTriggerActivated = 1;				
		isDisposable = 1;					
		is3DEN = 0;							

		// Module attributes (uses https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes#Entity_Specific):
		class Attributes: AttributesBase 
		{
			// Arguments shared by specific module type (have to be mentioned in order to be present):
			// class Units: Units{};

			// Module-specific arguments:
			class Range: Edit
			{
				property = QGVAR(fireEMP_range);							
				displayName = "Range of EMP blast (50 to 2500m)";					
				tooltip = "How far will the EMP blast effect objects/people";	
				typeName = "NUMBER";											
				defaultValue = "500";											
			};

			class SpawnDevice: Checkbox
			{
				property = QGVAR(fireEMP_spawndevice);
				displayName = "Spawn device";
				tooltip = "Should a device be spawned to appear as center of EMP, or just the EMP effect";
				typeName = "BOOL";
				defaultValue = "false"
			};
			class ScopesOptions: Combo
			{
				control = "combo";
				property = QGVAR(fireEMP_scopeoptions);
				displayName = "NV/Thermal Scopes";
				tooltip = "How should scopes with built-in thermal and NV be handled";
				expression = "_this setVariable ['%s', _value];";
				defaultValue = 2;
				typeName = "NUMBER";
				class Values 
				{
					class None
					{
						name = "No Removal";
						// tooltip = "Some tooltip";
						value = 0;
					};
					class Replace {
						name = "Replace with base-game item";
						value = 1;
					};
					class Remove {
						name = "Removal";
						value = 2;
					};
				};
			};			
			class BinoOptions: Combo
			{
				control = "combo";
				property = QGVAR(fireEMP_binooptions);
				displayName = "Binoculars";
				tooltip = "How should binoculars with built-in thermal and NV be handled";
				expression = "_this setVariable ['%s', _value];";
				defaultValue = 2;
				typeName = "NUMBER";
				class Values 
				{
					class None
					{
						name = "No Removal";
						// tooltip = "Some tooltip";
						value = 0;
					};
					class Replace {
						name = "Replace with base-game item";
						value = 1;
					};
					class Remove {
						name = "Removal";
						value = 2;
					};
				};
			};	
			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription 
		{
			description = "Fires EMP at position, can be used with triggers. If spawn option is set, it will spawn a Device at center of EMP";	
		};
	};
	// Set Immune EMP
	class GVAR(moduleImmuneEMP): Module_F
	{
		// Standard object definitions:
		scope = 2;										
		displayName = "Set Immune to EMP";				
		icon = QPATHTOEF(zeus,data\EMP_Icon_IMU.paa);	
		vehicleClass = "Modules";
		category = "crowsEW_modules";
		function = QFUNC(setImmuneEMP);	
		functionPriority = 1;				
		isGlobal = 0;						
		isTriggerActivated = 1;				
		isDisposable = 1;					
		is3DEN = 0;							

		// Module attributes (uses https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes#Entity_Specific):
		class Attributes: AttributesBase 
		{
			// Arguments shared by specific module type (have to be mentioned in order to be present):
			// class Units: Units{};

			// Module-specific arguments:
			class Immune: Checkbox
			{
				property = QGVAR(immuneemp_immune);							
				displayName = "Set Immune to EMP";					
				tooltip = "Makes EMP have no effect on the object/unit";	
				typeName = "BOOL";											
				defaultValue = "true";											
			};	
			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription 
		{
			description = "Sets the synced objects immune to the effects from EMPs. Will work on all units synced to it";	
		};
	};
	// Set Radio Tracker Chatter
	class GVAR(moduleRadioTrackerChatter): Module_F
	{
		// Standard object definitions:
		scope = 2;										
		displayName = "Add Radio Tracking Chatter";				
		icon = "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa";	
		vehicleClass = "Modules";
		category = "crowsEW_modules";
		function = QFUNC(setRadioChatter);	
		functionPriority = 1;				
		isGlobal = 0;						
		isTriggerActivated = 1;				
		isDisposable = 1;					
		is3DEN = 0;							

		// Module attributes (uses https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes#Entity_Specific):
		class Attributes: AttributesBase 
		{
			// Arguments shared by specific module type (have to be mentioned in order to be present):
			// class Units: Units{};

			// Module-specific arguments:
			class VoicePack: Combo 
			{
				control = "combo";
				property = QGVAR(radiochatter_voicepack);
				displayName = "VoicePack";
				tooltip = "What pack of sounds should be used for the broadcasts";
				expression = "_this setVariable ['%s', _value];";
				defaultValue = 0;
				typeName = "STRING";
				class Values 
				{
					class british
					{
						name = "British";
						value = "british";
					};
					class morsecode
					{
						name = "Morse Code";
						value = "morsecode";
					};
					class electronic
					{
						name = "Electronic";
						value = "electronic";
					};
					class alienElectronic
					{
						name = "Alien Electronic";
						value = "alienElectronic";
					};
					class police
					{
						name = "Police Radio";
						value = "police";
					};
				};
			};

			class FrequencyMin: edit
			{
				property = QGVAR(radiochatter_frequency_minimum);							
				displayName = "Frequency min (60 to 250mhz)";					
				tooltip = "The minimum frequency used. Recommend small interval";	
				typeName = "NUMBER";											
				defaultValue = "220";											
			};	
			class FrequencyMax: edit
			{
				property = QGVAR(radiochatter_frequency_max);							
				displayName = "Frequency Max (60 to 250mhz)";					
				tooltip = "The maximum frequency used. Recommend small interval";	
				typeName = "NUMBER";											
				defaultValue = "221";											
			};	
			class Range: edit 
			{
				property = QGVAR(radiochatter_range);							
				displayName = "Range (1 to 10000)";					
				tooltip = "Range of the signal";	
				typeName = "NUMBER";											
				defaultValue = "2000";	
			};
			class DurationMin: edit
			{
				property = QGVAR(radiochatter_duration_minimum);							
				displayName = "Duration min (1 to 40s)";					
				tooltip = "The minimum duration of each chatter broadcast";	
				typeName = "NUMBER";											
				defaultValue = "5";											
			};	
			class DurationMax: edit
			{
				property = QGVAR(radiochatter_duration_max);							
				displayName = "Duration max (1 to 100s)";					
				tooltip = "The maximum duration of each chatter broadcast";	
				typeName = "NUMBER";											
				defaultValue = "30";											
			};	
			class PauseMin: edit
			{
				property = QGVAR(radiochatter_pause_min);							
				displayName = "Pause min (1 to 40s)";					
				tooltip = "The minimum time between chatter broadcasts";	
				typeName = "NUMBER";											
				defaultValue = "5";											
			};	
			class PauseMax: edit
			{
				property = QGVAR(radiochatter_pause_max);							
				displayName = "Pause max (1 to 100s)";					
				tooltip = "The maximum time between chatter broadcasts";	
				typeName = "NUMBER";											
				defaultValue = "30";											
			};	
			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription 
		{
			description = "Sets the synced unit to randomly broadcast radio chatter with the given parameters. The broadcasts can be tracked and listened to by Spectrum Devices. The editor module does not support dynamically added voicepacks, but the zeus module for this function does.";	
		};
	};
	// Set Jammable
	class GVAR(moduleSetJammable): Module_F
	{
		// Standard object definitions:
		scope = 2;										
		displayName = "Set Unit Jammable";				
		icon = QPATHTOEF(zeus,data\spectrum_signal.paa);
		vehicleClass = "Modules";
		category = "crowsEW_modules";
		function = QFUNC(setUnitJammable);	
		functionPriority = 1;				
		isGlobal = 0;						
		isTriggerActivated = 1;				
		isDisposable = 1;					
		is3DEN = 0;							

		// Module attributes (uses https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes#Entity_Specific):
		class Attributes: AttributesBase 
		{
			// Arguments shared by specific module type (have to be mentioned in order to be present):
			// class Units: Units{};

			// Module-specific arguments:
			class Classname: Checkbox
			{
				property = QGVAR(jammable_classnames);							
				displayName = "Apply to Classnames";					
				tooltip = "Make all spawned units of the synced units type jammable by default. (CANNOT BE UNDONE DURING MISSION)";	
				typeName = "BOOL";											
				defaultValue = "false";											
			};	
			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription 
		{
			description = "Sets all synced object able to be jammed by spectrum device. Select to apply to synced objects classname or only on specific instance of the synced objects. Applying to classnames can NOT be undone during mission!";	
		};
	};
	// Set TFAR Radio Tracking - Only works if TFAR is loaded...
	class GVAR(moduleSetTrackingTfar): Module_F
	{
		// Standard object definitions:
		scope = 2;										
		displayName = "Enable TFAR Radio Tracking";				
		icon = "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa";
		vehicleClass = "Modules";
		category = "crowsEW_modules";
		function = QFUNC(enableTrackingTfar);	
		functionPriority = 1;				
		isGlobal = 0;						
		isTriggerActivated = 1;				
		isDisposable = 1;					
		is3DEN = 0;							

		// Module attributes (uses https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes#Entity_Specific):
		class Attributes: AttributesBase 
		{
			// Arguments shared by specific module type (have to be mentioned in order to be present):
			// class Units: Units{};
			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription 
		{
			description = "Enables TFAR radio tracking and ICOM functionality. Requires TFAR is loaded and enabled!";	
		};
	};
};
