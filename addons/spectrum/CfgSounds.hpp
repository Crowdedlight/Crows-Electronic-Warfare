class CfgSounds
{
	class garbled
	{
		name = "garbled radio sound";
		sound[] = {QPATHTOF(data\voice\garbled.ogg), QUOTE(db+6), 1};
		titles[] = {};
	};
	/// Spectrum device sounds and jamming sounds
	class jamcharging
	{
		name = "drone jammer charging";
		sound[] = {QPATHTOF(data\sound\jam_power_on.wav), QUOTE(db+6), 1};
		titles[] = {};
	};
	class spectrumjamloop
	{
		name = "drone jam loop";
		sound[] = {QPATHTOF(data\sound\jam_loop.wav), QUOTE(db+6), 1};
		titles[] = {};
	};
	class spectrumjamerror
	{
		name = "drone jam error";
		sound[] = {QPATHTOF(data\sound\jam_error.wav), QUOTE(db+6), 1};
		titles[] = {0, "ERROR: Too weak Signal"};
	};
	class radioError : spectrumjamerror
	{
		titles[] = {0, "ERROR: Missing Icom radio in inventory"};
	};
	class ugvmotor
	{
		name = "UGV motor sound";
		sound[] = {QPATHTOF(data\sound\ugv_motor_drone.wav), QUOTE(db+6), 1};
		titles[] = {};
	};
	class dronehelimotor
	{
		name = "Helicopter drone motor";
		sound[] = {QPATHTOF(data\sound\helicopter_drone.wav), QUOTE(db+6), 1};
		titles[] = {};
	};
};