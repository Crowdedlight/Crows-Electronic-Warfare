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
		displayName = "$STR_CROWSEW_Editormodules_addsignalsource";				// Name displayed in the menu
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
				property = QGVAR(addsignalsource_freq);												// Unique property (use "<tag>_<moduleClass>_<attributeClass>" format to ensure that the name is unique)
				displayName = "$STR_CROWSEW_Editormodules_addsignalsource_frequency_displayname";	// Argument label
				tooltip = "$STR_CROWSEW_Editormodules_addsignalsource_frequency_tooltip";			// Tooltip description
				typeName = "NUMBER";																// Value type, can be "NUMBER", "STRING" or "BOOL"
				defaultValue = "805";																// Default attribute value. Warning: This is an expression, and its returned value will be used (50 in this case).
			};

			class Range: Edit
			{
				property = QGVAR(addsignalsource_range);
				displayName = "$STR_CROWSEW_Editormodules_addsignalsource_range_displayname";
				tooltip = "$STR_CROWSEW_Editormodules_addsignalsource_range_tooltip";
				typeName = "NUMBER";
				defaultValue = "300";
			};			

			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription 
		{
			description = "$STR_CROWSEW_Editormodules_addsignalsource_description";	// Short description, will be formatted as structured text
		};
	};

	// Jammer
	class GVAR(moduleAddJammer): Module_F
	{
		// Standard object definitions:
		scope = 2;										
		displayName = "$STR_CROWSEW_Editormodules_jammer_displayname";				
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
			class IsActiveAtMissionStart: Checkbox
			{
				property = QGVAR(addjammer_isActiveAtMissionStart);
				displayName = "$STR_CROWSEW_Editormodules_jammer_missionstart_name";
				tooltip = "$STR_CROWSEW_Editormodules_jammer_missionstart_tooltip";
				typeName = "BOOL";
				defaultValue = "true";
			};

			class IsVoiceCommsJammer: Checkbox
			{
				property = QGVAR(addjammer_isVoiceCommsJammer);
				displayName = "$STR_CROWSEW_Editormodules_jammer_voicecomms_name";
				tooltip = "$STR_CROWSEW_Editormodules_jammer_voicecomms_tooltip";
				typeName = "BOOL";
				defaultValue = "true";
			};

			class IsDroneJammer: Checkbox
			{
				property = QGVAR(addjammer_isDroneJammer);
				displayName = "$STR_CROWSEW_Editormodules_jammer_drones_name";
				tooltip = "$STR_CROWSEW_Editormodules_jammer_drones_tooltip";
				typeName = "BOOL";
				defaultValue = "false";
			};

			class EffectiveRadius: Edit
			{
				property = QGVAR(addjammer_radius);							
				displayName = "$STR_CROWSEW_Editormodules_jammer_effective_radius_name";					
				tooltip = "$STR_CROWSEW_Editormodules_jammer_effective_radius_tooltip";	
				typeName = "NUMBER";											
				defaultValue = "200";											
			};

			class FalloffRadius: Edit
			{
				property = QGVAR(addjammer_strength);
				displayName = "$STR_CROWSEW_Editormodules_jammer_falloff_name";
				tooltip = "$STR_CROWSEW_Editormodules_jammer_falloff_tooltip";
				typeName = "NUMBER";
				defaultValue = "400";
			};			

			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription 
		{
			description = "$STR_CROWSEW_Editormodules_jammer_description";	
		};
	};
	// Fire EMP
	class GVAR(moduleFireEMP): Module_F
	{
		// Standard object definitions:
		scope = 2;										
		displayName = "$STR_CROWSEW_Editormodules_emp_name";				
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
				displayName = "$STR_CROWSEW_Editormodules_emp_range_name";					
				tooltip = "$STR_CROWSEW_Editormodules_emp_range_tooltip";	
				typeName = "NUMBER";											
				defaultValue = "500";											
			};

			class SpawnDevice: Checkbox
			{
				property = QGVAR(fireEMP_spawndevice);
				displayName = "$STR_CROWSEW_Editormodules_emp_spawn_device_name";
				tooltip = "$STR_CROWSEW_Editormodules_emp_spawn_device_tooltip";
				typeName = "BOOL";
				defaultValue = "false";
			};
			class ScopesOptions: Combo
			{
				control = "combo";
				property = QGVAR(fireEMP_scopeoptions);
				displayName = "$STR_CROWSEW_Editormodules_emp_scopes_name";
				tooltip = "$STR_CROWSEW_Editormodules_emp_scopes_tooltip";
				expression = "_this setVariable ['%s', _value];";
				defaultValue = 2;
				typeName = "NUMBER";
				class Values 
				{
					class None
					{
						name = "$STR_CROWSEW_Editormodules_emp_options_no_removal";
						// tooltip = "Some tooltip";
						value = 0;
					};
					class Replace {
						name = "$STR_CROWSEW_Editormodules_emp_options_replace_basegame";
						value = 1;
					};
					class Remove {
						name = "$STR_CROWSEW_Editormodules_emp_options_removal";
						value = 2;
					};
				};
			};			
			class BinoOptions: Combo
			{
				control = "combo";
				property = QGVAR(fireEMP_binooptions);
				displayName = "$STR_CROWSEW_Editormodules_emp_bino_name";
				tooltip = "$STR_CROWSEW_Editormodules_emp_bino_tooltip";
				expression = "_this setVariable ['%s', _value];";
				defaultValue = 2;
				typeName = "NUMBER";
				class Values 
				{
					class None
					{
						name = "$STR_CROWSEW_Editormodules_emp_options_no_removal";
						// tooltip = "Some tooltip";
						value = 0;
					};
					class Replace {
						name = "$STR_CROWSEW_Editormodules_emp_options_replace_basegame";
						value = 1;
					};
					class Remove {
						name = "$STR_CROWSEW_Editormodules_emp_options_removal";
						value = 2;
					};
				};
			};	
			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription 
		{
			description = "$STR_CROWSEW_Editormodules_emp_description";	
		};
	};
	// Set Immune EMP
	class GVAR(moduleImmuneEMP): Module_F
	{
		// Standard object definitions:
		scope = 2;										
		displayName = "$STR_CROWSEW_Editormodules_immune_emp_name";				
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
				displayName = "$STR_CROWSEW_Editormodules_immune_emp_name";					
				tooltip = "$STR_CROWSEW_Editormodules_immune_emp_tooltip";	
				typeName = "BOOL";											
				defaultValue = "true";											
			};	
			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription 
		{
			description = "$STR_CROWSEW_Editormodules_immune_emp_description";	
		};
	};
	// Set Radio Tracker Chatter
	class GVAR(moduleRadioTrackerChatter): Module_F
	{
		// Standard object definitions:
		scope = 2;										
		displayName = "$STR_CROWSEW_Editormodules_radio_chatter_name";				
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
				displayName = "$STR_CROWSEW_Editormodules_radio_chatter_voicepack_name";
				tooltip = "$STR_CROWSEW_Editormodules_radio_chatter_voicepack_tooltip";
				expression = "_this setVariable ['%s', _value];";
				defaultValue = 0;
				typeName = "STRING";
				class Values 
				{
					class british
					{
						name = "$STR_CROWSEW_Editormodules_radio_chatter_british";
						value = "british";
					};
					class morsecode
					{
						name = "$STR_CROWSEW_Editormodules_radio_chatter_morsecode";
						value = "morsecode";
					};
					class electronic
					{
						name = "$STR_CROWSEW_Editormodules_radio_chatter_electronic";
						value = "electronic";
					};
					class alienElectronic
					{
						name = "$STR_CROWSEW_Editormodules_radio_chatter_alien_electronic";
						value = "alienElectronic";
					};
					class police
					{
						name = "$STR_CROWSEW_Editormodules_radio_chatter_police_radio";
						value = "police";
					};
				};
			};

			class FrequencyMin: Edit
			{
				property = QGVAR(radiochatter_frequency_minimum);							
				displayName = "$STR_CROWSEW_Editormodules_radio_chatter_frequency_min_name";					
				tooltip = "$STR_CROWSEW_Editormodules_radio_chatter_frequency_min_tooltip";	
				typeName = "NUMBER";											
				defaultValue = "220";											
			};	
			class FrequencyMax: Edit
			{
				property = QGVAR(radiochatter_frequency_max);							
				displayName = "$STR_CROWSEW_Editormodules_radio_chatter_frequency_max_name";					
				tooltip = "$STR_CROWSEW_Editormodules_radio_chatter_frequency_max_tooltip";	
				typeName = "NUMBER";											
				defaultValue = "221";											
			};	
			class Range: Edit 
			{
				property = QGVAR(radiochatter_range);							
				displayName = "$STR_CROWSEW_Editormodules_radio_chatter_range_name";					
				tooltip = "$STR_CROWSEW_Editormodules_radio_chatter_range_tooltip";	
				typeName = "NUMBER";											
				defaultValue = "2000";	
			};
			class DurationMin: Edit
			{
				property = QGVAR(radiochatter_duration_minimum);							
				displayName = "$STR_CROWSEW_Editormodules_radio_chatter_duration_min_name";					
				tooltip = "$STR_CROWSEW_Editormodules_radio_chatter_duration_min_tooltip";	
				typeName = "NUMBER";											
				defaultValue = "5";											
			};	
			class DurationMax: Edit
			{
				property = QGVAR(radiochatter_duration_max);							
				displayName = "$STR_CROWSEW_Editormodules_radio_chatter_duration_max_name";					
				tooltip = "$STR_CROWSEW_Editormodules_radio_chatter_duration_max_tooltip";	
				typeName = "NUMBER";											
				defaultValue = "30";											
			};	
			class PauseMin: Edit
			{
				property = QGVAR(radiochatter_pause_min);							
				displayName = "$STR_CROWSEW_Editormodules_radio_chatter_pause_min_name";					
				tooltip = "$STR_CROWSEW_Editormodules_radio_chatter_pause_min_tooltip";	
				typeName = "NUMBER";											
				defaultValue = "5";											
			};	
			class PauseMax: Edit
			{
				property = QGVAR(radiochatter_pause_max);							
				displayName = "$STR_CROWSEW_Editormodules_radio_chatter_pause_max_name";					
				tooltip = "$STR_CROWSEW_Editormodules_radio_chatter_pause_max_tooltip";	
				typeName = "NUMBER";											
				defaultValue = "30";											
			};	
			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription 
		{
			description = "$STR_CROWSEW_Editormodules_radio_chatter_description";	
		};
	};
	// Set Jammable
	class GVAR(moduleSetJammable): Module_F
	{
		// Standard object definitions:
		scope = 2;										
		displayName = "$STR_CROWSEW_Editormodules_jammable_name";				
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
				displayName = "$STR_CROWSEW_Editormodules_jammable_classnames_name";					
				tooltip = "$STR_CROWSEW_Editormodules_jammable_classnames_tooltip";	
				typeName = "BOOL";											
				defaultValue = "false";											
			};	
			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription 
		{
			description = "$STR_CROWSEW_Editormodules_jammable_description";	
		};
	};
	// Set TFAR Radio Tracking - Only works if TFAR is loaded...
	class GVAR(moduleSetTrackingTfar): Module_F
	{
		// Standard object definitions:
		scope = 2;										
		displayName = "$STR_CROWSEW_Editormodules_radio_tracking_name";				
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
			description = "$STR_CROWSEW_Editormodules_radio_tracking_description";	
		};
	};
};
