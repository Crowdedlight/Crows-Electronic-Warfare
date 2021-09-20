class CfgMagazines {
    class CA_Magazine;
    class emp_device_mag: CA_Magazine {
        ammo = "emp_device_ammo";
        ACE_Explosives_Placeable = 0;  // Can be placed
        useAction = 0;  // Disable the vanilla interaction
        ACE_Explosives_SetupObject = "Crows_Emp_Device";  // The object placed before the explosive is armed
        ACE_Explosives_DelayTime = 1.5;  // Seconds between trigger activation and explosion
        class ACE_Triggers {  // Trigger configurations
            SupportedTriggers[] = {"Timer", "Command", "MK16_Transmitter", "DeadmanSwitch"};  // Triggers that can be used
            class Timer {
                FuseTime = 0.5;  // Time for the fuse to burn
            };
            class Command {
                FuseTime = 0.5;
            };
            class MK16_Transmitter: Command {};
            class DeadmanSwitch: Command {};
        };
    };
};
