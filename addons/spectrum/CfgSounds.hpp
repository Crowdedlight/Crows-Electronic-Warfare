class CfgSounds
{
	class radiocheck
	{
		name = "radiocheck";
		sound[] = {PATHTOF(data\voice\radiocheck.ogg), db+6, 1};
		titles[] = {0, "10 seconds radio check. Go to secure channel"};
	};	
	class bolembuggy
	{
		name = "Bolem Buggy received";
		sound[] = {PATHTOF(data\voice\bolembuggy.ogg), db+6, 1};
		titles[] = {
			0, "Have you seen the new Bolem Buggys we just received?",
			3, "Yeah they are great right?"
			};
	};
	class garbled
	{
		name = "garbled radio sound";
		sound[] = {PATHTOF(data\voice\garbled.ogg), db+6, 1};
		titles[] = {};
	};
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