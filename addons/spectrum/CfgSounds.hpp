class CfgSounds
{
	class garbled
	{
		name = "$STR_CROWSEW_Spectrum_sounds_garbled";
		sound[] = {QPATHTOF(data\voice\garbled.ogg), QUOTE(db+6), 1};
		titles[] = {};
	};
	/// Spectrum device sounds and jamming sounds
	class jamcharging
	{
		name = "$STR_CROWSEW_Spectrum_sounds_jammer_charging";
		sound[] = {QPATHTOF(data\sound\jam_power_on.wav), QUOTE(db+6), 1};
		titles[] = {};
	};
	class spectrumjamloop
	{
		name = "$STR_CROWSEW_Spectrum_sounds_jam_loop";
		sound[] = {QPATHTOF(data\sound\jam_loop.wav), QUOTE(db+6), 1};
		titles[] = {};
	};
	class spectrumjamerror
	{
		name = "$STR_CROWSEW_Spectrum_sounds_jam_error";
		sound[] = {QPATHTOF(data\sound\jam_error.wav), QUOTE(db+6), 1};
		titles[] = {0, "$STR_CROWSEW_Spectrum_sounds_jam_error_title"};
	};
	class radioError : spectrumjamerror
	{
		titles[] = {0, "$STR_CROWSEW_Spectrum_sounds_radio_error"};
	};
	class ugvmotor
	{
		name = "$STR_CROWSEW_Spectrum_sounds_ugv_motor";
		sound[] = {QPATHTOF(data\sound\ugv_motor_drone.wav), QUOTE(db+6), 1};
		titles[] = {};
	};
	class dronehelimotor
	{
		name = "$STR_CROWSEW_Spectrum_sounds_drone_heli_motor";
		sound[] = {QPATHTOF(data\sound\helicopter_drone.wav), QUOTE(db+6), 1};
		titles[] = {};
	};
};