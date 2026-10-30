# Transmitting sound sequences
Mission makers (who are famliar with scripting) can **make any object transmit any number of sounds in sequence**.

Players can listen to those transmissions, when equipped with a [Spectrum Device and appropriate antenna](basic-use.md).

After reaching the end, the sequence can loop back to the beginning (if so desired). This is useful for creating never ending radio broadcasts (e.g. to simulate radio towers with music, news etc.).

Any [sound file](https://community.bistudio.com/wiki/Arma_3:_Sound_Files) or entry from [CfgSounds](https://community.bistudio.com/wiki/Description.ext#CfgSounds) can be used in the sequence.

To get started have a look at the function header of [fnc_addSoundSequenceServer.sqf](../../addons/spectrum/functions/fnc_addSoundSequenceServer.sqf). 
It explains this feature in more detail and shows some example calls.
A few examples will also be shown here, but the file linked to above will have the latest examples. 

### Parameters:  
	_unit		unit/object to attach the signal to
	_freq		frequency to broadcast on
	_range		range of the broadcasted signal
	_sounds		array of sounds to be played/transmitted in sequence
					alternatively, instead of a sound a number can be given (then no sound is played, just silence for that duration in seconds)
	_loop		boolean that tells if the sequence shall loop indefinately (default: false); useful for permanently active radio broadcasting stations
    
    Return:  script handle of spawned loop (can be used to terminate the sound sequence by using "terminate _handle;")



Use this function to add a list of sounds (CfgSounds or a sound file; see BIKI on playSoundUI for details) to be broadcast in the spectrum.

### Examples
```sqf
	_audioSequenceLoop = [_myRadioTower, 98.5, 5000, ["News_Jingle", "News_idap"], true] call crowsew_spectrum_fnc_addsoundsequenceserver;

	_audioSequenceLoop = [_myRadioTower, 98.5, 5000, ["News_Jingle", 1.5, "News_idap", 1.1], true] call crowsew_spectrum_fnc_addsoundsequenceserver;

	// to stop the sequence later make these 2x calls:
	terminate _audioSequenceLoop;
	[_myRadioTower, "sound"] call crowsew_spectrum_fnc_removebeaconserver;
```