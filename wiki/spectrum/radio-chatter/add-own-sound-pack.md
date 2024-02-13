# Adding own voicepack to Radio Chatter module
Its possible to add your own pack of voicelines to the radio-chatter module. The easiest is to do it by adding it to a template of a particular mission. An example of a template with added sounds can be [downloaded here](https://github.com/Crowdedlight/Crows-Electronic-Warfare/files/10202058/sound_add_template_example.vn_the_bra.zip).

Besides adding the ``.ogg`` soundfiles to the template you need to do the following: 

1. Make an config file to include the sound in, in this example I call it: ``CfgSoundsRadioChatter.hpp``. 

```admonish info
Make sure to test and find a volume value for the sound that fits to not deafen people ingame! Its the ``db+12`` parameter you can change to ``db+5`` or ``db+16`` to lower or raise the default volume of the sound
```

```cpp
class CfgSounds
{
	/// Voice lines

	class tiger_growl // classname of the sound, needed for later
	{
		name = "tiger_growl";
		sound[] = {"sounds\tiger_growl.ogg", db+12, 1};
		titles[] = {};
	};
	class tiger_roar
	{
		name = "tiger_roar";
		sound[] = {"sounds\tiger_roar.ogg", db+12, 1};
		titles[] = {};
	};
};
```


2. Add ``#include "CfgSoundsRadioChatter.hpp"`` (Or what you called the include file.) to the ``description.ext`` file. 

3. Add the following to your ``initPlayerLocal.sqf`` file to register the new voicepack so the ingame module picks it up and lists it. 
```admonish info
if ``initPlayerLocal.sqf`` does not exist then create it in the root of the template.
```

```cpp
// registering custom radio chatter sounds
// [cfgSound class-name, length in secounds]
crowsEW_spectrum_voiceLinesAnimalList = [
	["tiger_roar", 1.7],
	["tiger_growl", 5.2]
];

// weighted array, so if you wanted some lines to be more rare than others you can change the weight per sound
crowsEW_spectrum_voiceLinesAnimalWeights = [
	1,
	1
];

// "tiger" is the internal name of the pack, use lowercase only, then array of the list and weights of the new pack, and at the end the the Display name for the pack, this one you can beautify as you want. 
crowsEW_spectrum_voiceLinePacks set ["tiger", [crowsEW_spectrum_voiceLinesAnimalList, crowsEW_spectrum_voiceLinesAnimalWeights, "Tigers"]];
```

