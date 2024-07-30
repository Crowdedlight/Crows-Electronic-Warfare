class CfgSounds
{

	#include "CfgSoundsPolice.hpp"
	#include "CfgSoundsAlienElectronic.hpp"
	#include "CfgSoundsElectronic.hpp"
	#include "CfgSoundsMorseCode.hpp"
	#include "CfgSoundsBritish.hpp"

	class crowsEW_garbled
	{
		name = "$STR_CROWSEW_Spectrum_sounds_garbled";
		sound[] = {QPATHTOF(data\voice\garbled.ogg), QUOTE(db+6), 1};
		titles[] = {};
	};
	/// Spectrum device sounds and jamming sounds
	class crowsEW_jamcharging
	{
		name = "$STR_CROWSEW_Spectrum_sounds_jammer_charging";
		sound[] = {QPATHTOF(data\sound\jam_power_on.wav), QUOTE(db+6), 1};
		titles[] = {};
	};
	class crowsEW_spectrumjamloop
	{
		name = "$STR_CROWSEW_Spectrum_sounds_jam_loop";
		sound[] = {QPATHTOF(data\sound\jam_loop.wav), QUOTE(db+6), 1};
		titles[] = {};
	};
	class crowsEW_spectrumjamerror
	{
		name = "$STR_CROWSEW_Spectrum_sounds_jam_error";
		sound[] = {QPATHTOF(data\sound\jam_error.wav), QUOTE(db+6), 1};
		titles[] = {0, "$STR_CROWSEW_Spectrum_sounds_jam_error_title"};
	};
	class crowsEW_radioError : crowsEW_spectrumjamerror
	{
		titles[] = {0, "$STR_CROWSEW_Spectrum_sounds_radio_error"};
	};
	class crowsEW_ugvmotor
	{
		name = "$STR_CROWSEW_Spectrum_sounds_ugv_motor";
		sound[] = {QPATHTOF(data\sound\ugv_motor_drone.wav), QUOTE(db+6), 1};
		titles[] = {};
	};
	class crowsEW_dronehelimotor
	{
		name = "$STR_CROWSEW_Spectrum_sounds_drone_heli_motor";
		sound[] = {QPATHTOF(data\sound\helicopter_drone.wav), QUOTE(db+6), 1};
		titles[] = {};
	};
};
