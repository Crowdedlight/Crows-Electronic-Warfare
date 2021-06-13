class CfgSounds
{
	sounds[] = {};
	class jam_loop
	{
		name = "jam_loop";
		sound[] = {PATHTOF(data\sounds\jam_effect.ogg), db+9, 1};
		titles[] = {};
	};
	class jam_start
	{
		name = "jam_start";
		sound[] = {PATHTOF(data\sounds\jam_start.ogg), db+3, 1}
	};
};