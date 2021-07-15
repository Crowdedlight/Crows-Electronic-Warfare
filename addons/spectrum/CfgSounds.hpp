class CfgSounds
{
	class radiocheck
	{
		name = "radiocheck";
		sound[] = {PATHTOF(data\voice\radiocheck.ogg), db+0, 1};
		titles[] = {0, "10 seconds radio check. Go to secure channel"};
	};	
	class bolembuggy
	{
		name = "Bolem Buggy received";
		sound[] = {PATHTOF(data\voice\bolembuggy.ogg), db+0, 1};
		titles[] = {
			0, "Have you seen the new Bolem Buggys we just received?",
			3, "Yeah they are great right?"
			};
	};
	class garbled
	{
		name = "garbled radio sound";
		sound[] = {PATHTOF(data\voice\garbled.ogg), db+0, 1};
		titles[] = {};
	};
};