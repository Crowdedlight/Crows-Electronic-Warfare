# Add Costum Sound API

This allow mission makers or other modmakers to add sounds to the "AddSound" and "PlaySound" module. 

API call
```sqf
// input param is array consiting of array elements of format `[key, length, filepath, displayname]`
// key: unique id for this sound, avoid spaces. Recommend using a personal prefix like: "myprefix_bell_tower"
// length: the length of the sound in seconds, provide in decimals format e.g. 0.4s
// filepath: the filepath to the sound file IMPORTANT, this is the path in arma virtual system, e.g for this mod: "z\crowsEW\addons\sounds\data\soundfile.ogg"
// displayname: the "pretty" name of the sound. So what the zeus will see when selecting it. can contains spaces. 

[["key", 0.4, "filepath", "displayname"], ... ] call crowsew_sounds_fnc_addCustomSounds;
```

```admonish info
If a sound fails to be added it will write it to the RPT log file. e.g.: "CrowsEW:fnc_addCustomSounds.sqf: _key, _length or _filepath is empty or 0 for: ["",0.0,"",""]"
```


Example:
```sqf

private _newSounds = [
	["crowsEW_tiger_roar", 1.8, "z\crowsEW\addons\sounds\data\tiger_roar.ogg", "Tiger Roar (1.8s)"],
	["crowsEW_tiger_growl", 1.3, "z\crowsEW\addons\sounds\data\tiger_growl.ogg", "Tiger Growl (1.3s)"],
	["crowsEW_tiger_stamp", 1.1, "z\crowsEW\addons\sounds\data\tiger_stamp.ogg", localize "STR_CROWSEW_Sounds_tiger_stamp"] // if doing localization
];

[_newSounds] call crowsew_sounds_fnc_addCustomSounds;
```