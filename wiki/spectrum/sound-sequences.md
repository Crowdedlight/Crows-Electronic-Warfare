# Transmitting sound sequences
Mission makers (who are famliar with scripting) can **make any object transmit any number of sounds in sequence**.

Players can listen to those transmissions, when equipped with a [Spectrum Device and appropriate antenna](basic-use.md).

After reaching the end, the sequence can loop back to the beginning (if so desired). This is useful for creating never ending radio broadcasts (e.g. to simulate radio towers with music, news etc.).

Any [sound file](https://community.bistudio.com/wiki/Arma_3:_Sound_Files) or entry from [CfgSounds](https://community.bistudio.com/wiki/Description.ext#CfgSounds) can be used in the sequence.

To get started have a look at the function header of [fnc_addSoundSequenceServer.sqf](../../addons/spectrum/functions/fnc_addSoundSequenceServer.sqf). 
It explains this feature in more detail and shows some example calls.
