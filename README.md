# Crows-Electronic-Warfare
A arma 3 mod that allows zeus to add additional eletronic measures available for the players. 

### Requirements
This mod requires Zeus Enhanced (ZEN) and CBA3

### Features

**The wiki for the features is available at:** https://github.com/Crowdedlight/Crows-Electronic-Warfare/wiki 

**Features:**
* **Set Spectrum Signal Source:** Allows Zeus to select a object that can be tracked by the spectrum analyzer with selected frequency and range it can be tracked from. Frequency has to be unique due to game limitations. Does not work on remote-controlled units. However a player-zeus would be able to use the spectrum analyzer himself.    
* **Add Sound:** Allows Zeus to select a object and play a selected sound with options such as: initial delay, on repeat, delay between repeat, removal if unit dies. Sound follows the unit around. (Be aware if using the long sounds, they can't stop mid-playing, only when played to end)  
* **Play Sound:** Allows Zeus to play a sound at selected position. Sound follows the unit around. (Be aware if using the long sounds, they can't stop mid-playing, only when played to end)  
* **EMP:** Added EMP module which makes Zeus able to fire an EMP. The EMP will remove NV/Thermal for men, weapons and vehicles. Vehicles electric components (lights,engine,turrest) will also be damaged. Launchers and static weapons that has NV/Thermal/electronic components will be damaged/removed. Binoculars and Scopes on weapons that has intergrated NV/Thermal will be either removed or replaced with base-game item that do not have NV/Thermal. This is configuable by the Zeus. If TFAR is loaded the radios of affected units/vehicles will stop working (Requires TFAR Beta). However new items picking up not affected by the EMP will work. Some equipment might not be removed if they are modded items that does not share base-game parent. In that case please let me know and I will add it. As I can't cover every single modded item, the module will have item/equipment limitations and is meant to be operated by trust with the players. Zeus are immune to the EMP effect and will not have equipment removed or damaged and will also not get white-out/screen blur effect, like the players.   
* **EMP Immunity:** Set any unit or vehicle immune to the EMP effect. Units inside a vehicle set immune is also immune to the effect.   

**Features requiring TFAR:**  

* **Set TFAR Jammer:** Allows Zeus to select a object that will work as a TFAR jammer with the chosen settings, until death or removal. Zeus has a continuous updated map marker showing the area it is active in. Zeus is not affected by the jammning and does not have to think about where the zeus character is currently placed to avoid jamming. 


**All features have been tested on a dedicated server with multiple clients. Big thanks to the people that helped me test. You know who you are!**

### Debugging
All logging made to the .RPT file will start with CrowsEW-module: where the module is whatever module is writing the entry. Only done upon errors.

### Contributors
Crowdedlight

### License 
Crows Electronic Warfare is licensed under the GPL-3.0 license. Please do not reupload to the Steam Workshop without permission!

### Fonts used in texture
Digital 7 by Sizenko Alexander, Style-7, http://www.styleseven.com

### Sounds used 
Sounds used is from freesound.org under [CC0 1.0 Universal (CC0 1.0) Public Domain Dedication](https://creativecommons.org/publicdomain/zero/1.0/) is listed here:

prayer calls in Anatolia by felix.blume: https://freesound.org/people/felix.blume/sounds/163463/  
angry mob by bevibeldesign: https://freesound.org/people/bevibeldesign/sounds/316640/   
zombie sounds by bradsimkisshill: https://freesound.org/people/bradsimkisshill/sounds/554936/  
t-rex calls by CaveBoyTup: https://freesound.org/people/CaveboyTup/sounds/529462/   
Dinosaur 5 by SieuAmThanh: https://freesound.org/people/SieuAmThanh/sounds/450387/  
Siren by Jwade722: https://freesound.org/people/Jwade722/sounds/534550/?page=1#comment  
Air Raid Siren Alarm by ScreamStudio: https://freesound.org/people/ScreamStudio/sounds/412171/  
Footsteps_Boots_Gritty_Ground_(Gravel) by Nox_sound: https://freesound.org/people/Nox_Sound/sounds/530589/  
War of the worlds Horn 1 by JarredGibb: https://freesound.org/people/JarredGibb/sounds/244796/  
Tinnitus sound by Breviceps: https://freesound.org/people/Breviceps/sounds/450620/  
EMP blast.wav by 2887679652: https://freesound.org/people/2887679652/sounds/110564/  
electro_static.mps by soulman 90: https://freesound.org/people/Soulman%2090/sounds/108859/  
Huge Explosion Part 1 - Shockwave by bevibeldesign: https://freesound.org/people/bevibeldesign/sounds/366091/  
spark by elliottmoo: https://freesound.org/people/elliottmoo/sounds/189630/  
spark.wav by BMacZero: https://freesound.org/people/BMacZero/sounds/94132/  



Any sounds used under [Attribution 3.0 Unported (CC BY 3.0)](https://creativecommons.org/licenses/by/3.0/) is listed here with credit:  

wilhelm_scream by Syna-Max: https://freesound.org/people/Syna-Max/sounds/64940/  
sad song by Maerkunst: https://freesound.org/people/maerkunst/sounds/195940/  
ship radar by Escwabe3: https://freesound.org/people/Eschwabe3/sounds/459838/  
Zombie Growling by gneube: https://freesound.org/people/gneube/sounds/315847/  
"Fox, Vocal Cry, Distant, 01.wav" by InspectorJ (www.jshaw.co.uk) of Freesound.org https://freesound.org/people/InspectorJ/sounds/485009/  
Trex roar by CGEffex: https://freesound.org/people/CGEffex/sounds/96223/  
Heavy Dinosaur Footsteps Jurassic Park water by theguitarmanjp. (He give credits to @ComicJohnPowers) https://freesound.org/people/theguitarmanjp/sounds/385013/  
"Tripod, Horn Blast, Single, 01.wav" by InspectorJ (www.jshaw.co.uk) of Freesound.org https://freesound.org/people/InspectorJ/sounds/455602/  
Permission to panic? by deleted_user_2906614 (who remixed it from http://freesound.org/people/CGEffex/sounds/121902/):  https://freesound.org/people/deleted_user_2906614/sounds/263621/  
"Footsteps, Dry Twigs, A.wav" by InspectorJ (www.jshaw.co.uk) of Freesound.org: https://freesound.org/people/InspectorJ/sounds/419052/
"Bird Whistling, Single, Robin, A.wav" by InspectorJ (www.jshaw.co.uk) of Freesound.org: https://freesound.org/people/InspectorJ/sounds/416529/  
"Rooster Calling, Close, A.wav" by InspectorJ (www.jshaw.co.uk) of Freesound.org: https://freesound.org/people/InspectorJ/sounds/439472/  
"Crow Call, Single, A.wav" by InspectorJ (www.jshaw.co.uk) of Freesound.org: https://freesound.org/people/InspectorJ/sounds/418262/  
"Heartbeat, Regular, Single, 01-01, LOOP.wav" by InspectorJ (www.jshaw.co.uk) of Freesound.org: https://freesound.org/people/InspectorJ/sounds/485076/  
"UI, Mechanical, Turning-Off, 02, FX.wav" by InspectorJ (www.jshaw.co.uk) of Freesound.org: https://freesound.org/people/InspectorJ/sounds/458584/  
"Car Alarm, Distant, A.wav" by InspectorJ (www.jshaw.co.uk) of Freesound.org: https://freesound.org/people/InspectorJ/sounds/422051/  
"Cathedral Bells, Close, A.wav" by InspectorJ (www.jshaw.co.uk) of Freesound.org: https://freesound.org/people/InspectorJ/sounds/417769/  
This Statement Is False by qubodup: https://freesound.org/people/qubodup/sounds/211996/  
rumble.wav by tim.kahn: https://freesound.org/people/tim.kahn/sounds/94114/  
couch hit.wav by MegaBlasterRecordings: https://freesound.org/people/MegaBlasterRecordings/sounds/368640/ 
spark 1.wav by ERH: https://freesound.org/people/ERH/sounds/31348/  


Sounds used under [Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/) is listed here with credit:

Stuka Siren Sound Effect by Alexander: https://orangefreesounds.com/stuka-siren-sound-effect/  
Dog Barking Noise by Alexander: https://orangefreesounds.com/dog-barking-noise/  
Woof Woof by Alexander: https://orangefreesounds.com/woof-woof/  
