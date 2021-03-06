class CfgSounds
{
	class garbled
	{
		name = "garbled radio sound";
		sound[] = {PATHTOF(data\voice\garbled.ogg), db+6, 1};
		titles[] = {};
	};
	/// Spectrum device sounds and jamming sounds
	class jamcharging
	{
		name = "drone jammer charging";
		sound[] = {PATHTOF(data\sound\jam_power_on.wav), db+6, 1};
		titles[] = {};
	};
	class spectrumjamloop
	{
		name = "drone jam loop";
		sound[] = {PATHTOF(data\sound\jam_loop.wav), db+6, 1};
		titles[] = {};
	};
	class spectrumjamerror
	{
		name = "drone jam error";
		sound[] = {PATHTOF(data\sound\jam_error.wav), db+6, 1};
		titles[] = {0, "ERROR: Too weak Signal"};
	};
	class radioError : spectrumjamerror
	{
		titles[] = {0, "ERROR: Missing Icom radio in inventory"};
	};
	class ugvmotor
	{
		name = "UGV motor sound";
		sound[] = {PATHTOF(data\sound\ugv_motor_drone.wav), db+6, 1};
		titles[] = {};
	};
	class dronehelimotor
	{
		name = "Helicopter drone motor";
		sound[] = {PATHTOF(data\sound\helicopter_drone.wav), db+6, 1};
		titles[] = {};
	};
};