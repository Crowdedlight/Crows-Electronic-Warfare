class CfgAmmo {
    class PipeBombBase;
    class emp_device_ammo: PipeBombBase {
        ace_explosives_magazine = "emp_device_mag";
        soundActivation[] = {"", 0, 0, 0};  // No sound on activation
        soundDeactivation[] = {"", 0, 0, 0};  // No sound on deactivation
        triggerWhenDestroyed = 0;  // (Optional) Explode when the object is shot and destroyed (after being placed) (0-disabled, 1-enabled).
        ACE_explodeOnDefuse = 0.00;  // (Optional) Add a chance for the explosive to detonate after being disarmed (in percent)
        ACE_explosives_defuseObjectPosition[] = {-1.415, 0, 0.12};  // (Optional) The position relative to the model where the defuse helper object will be attached and thus the interaction point will be rendered
        ACE_explosives_size = 1;  // (Optional) Setting to 1 will use a defusal action with a larger radius (useful for large mines or mines with a wide pressure plane trigger area)
        ace_minedetector_detectable = 1;

        // Model and animation for Device
        mapSize=4.71;
		class SimpleObject
		{
			eden=1;
			animate[]=
			{
				
				{
					"damage_hide",
					0
				},
				
				{
					"light_1_rot",
					3013.71
				},
				
				{
					"vent_1_rot",
					3013.71
				},
				
				{
					"vent_2_rot",
					3013.71
				},
				
				{
					"vent_3_rot",
					3013.71
				},
				
				{
					"vent_4_rot",
					3013.71
				},
				
				{
					"vent_5_rot",
					3013.71
				},
				
				{
					"vent_6_rot",
					3013.71
				},
				
				{
					"vent_7_rot",
					3013.71
				},
				
				{
					"vent_8_rot",
					3013.71
				},
				
				{
					"vent_9_rot",
					3013.71
				}
			};
			hide[]=
			{
				"zasleh",
				"light_1_hide",
				"zadni svetlo",
				"brzdove svetlo",
				"clan",
				"podsvit pristroju",
				"poskozeni"
			};
			verticalOffset=0.824;
			verticalOffsetWorld=0;
		};
		// _generalMacro="Land_Device_slingloadable_F";
		model="\A3\Props_F_Exp\Military\Camps\Device_slingloadable_F.p3d";
		memoryPointTaskMarker="TaskMarker_1_pos";
		slingLoadCargoMemoryPoints[]=
		{
			"SlingLoadCargo1",
			"SlingLoadCargo2",
			"SlingLoadCargo3",
			"SlingLoadCargo4"
		};
		class Reflectors
		{
			class Light_1
			{
				color[]={1,0.25,0.02};
				ambient[]={0.001,0.00025000001,1.9999999e-005};
				intensity=10000;
				size=1;
				innerAngle=125;
				outerAngle=175;
				coneFadeCoef=10;
				position="Light_1_pos";
				direction="Light_1_dir";
				hitpoint="Light_1_hit";
				selection="Light_1_hide";
				useFlare=1;
				flareSize=1.5;
				flareMaxDistance=50;
				class Attenuation
				{
					start=0;
					constant=0;
					linear=15;
					quadratic=7;
					hardLimitStart=7;
					hardLimitEnd=10;
				};
			};
		};
    };
};
