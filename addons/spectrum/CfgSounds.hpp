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
	class ugvmotor
	{
		name = "UGV motor sound";
		sound[] = {PATHTOF(data\sound\ugv_motor.wav), db+6, 1};
		titles[] = {};
	};
	class dronehelimotor
	{
		name = "Helicopter drone motor";
		sound[] = {PATHTOF(data\sound\helicopter_drone.wav), db+6, 1};
		titles[] = {};
	};
};