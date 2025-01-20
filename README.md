# Crows-Electronic-Warfare
A arma 3 mod that allows zeus to add additional electronic measures available for the players. 

### Requirements
This mod requires Zeus Enhanced (ZEN) and CBA3

### Features

**The wiki for the features is available at:** https://crowdedlight.github.io/Crows-Electronic-Warfare/   
I can recommend reading it to see how features work and whats available. The list below is more like a short summery. 

**Features:**

* **Set Spectrum Signal Source:** Allows Zeus to select a object that can be tracked by the spectrum analyzer with selected frequency and range it can be tracked from. Frequency has to be unique due to game limitations. Does not work on remote-controlled units. However a player-zeus would be able to use the spectrum analyzer himself.    
* **C-Track trackers:** Player items that can be attached to self or vehicles with ACE Attach, or basegame scrollwheel options, and make whatever they are attached to, trackable with the spectrum device  
* **Add Sound:** Allows Zeus to select a object and play a selected sound with options such as: initial delay, on repeat, delay between repeat, removal if unit dies. Sound follows the unit around. (Be aware if using the long sounds, they can't stop mid-playing, only when played to end)  
* **Play Sound:** Allows Zeus to play a sound at selected position. Sound follows the unit around. (Be aware if using the long sounds, they can't stop mid-playing, only when played to end). Can also be played only for selected players 
* **EMP:** Added EMP module which makes Zeus able to fire an EMP. The EMP will remove NV/Thermal for men, weapons and vehicles. Vehicles electric components (lights,engine,turrest) will also be damaged. Launchers and static weapons that has NV/Thermal/electronic components will be damaged/removed. Binoculars and Scopes on weapons that has intergrated NV/Thermal will be either removed or replaced with base-game item that do not have NV/Thermal. This is configuable by the Zeus. If TFAR is loaded the radios of affected units/vehicles will stop working (Requires TFAR Beta). However new items picking up not affected by the EMP will work. Some equipment might not be removed if they are modded items that does not share base-game parent. In that case please let me know and I will add it. As I can't cover every single modded item, the module will have item/equipment limitations and is meant to be operated by trust with the players. Zeus are immune to the EMP effect and will not have equipment removed or damaged and will also not get white-out/screen blur effect, like the players.   
* **EMP Immunity:** Set any unit or vehicle immune to the EMP effect. Units inside a vehicle set immune is also immune to the effect.   
* **RadioChatter:** A module to put on AI that simulates the AI using radios to each other. The radio broadcasts a spectrum signal while "transmitting". Configurable by zeus. The player can "listen" to these transmission with the spectrum device if there is enough signal strength. The sounds/voice-lines played depends on the voice-pack used by zeus. There is a few different available.   
* **Jamming of Drones:** spawned drones automatically has a signal source attached to them. This makes them jammable when using the "jamming" antenna on the spectrum device. Jamming it will stop all AI functions and it is possible to walk past it while jammed without it being aware of your presence afterwards. Zeus can remove the signal-source on the UGVs and thus making it unjammable. The units can still be remote-controlled by zeus while jammed. Players controlling drones will be disconnected if drone is jammed, and if using the new omni-jammer, then their video feed will degrade as they get closer to the jammer.      
* **Multiple Editor modules:** Most of the zeus functions have editor modules that can be synced to triggers for more complex control. 

**Features requiring TFAR/ACRE:**  

* **Radio Jammer (TFAR or ACRE):** Allows to select a object that will work as a radio jammer with the chosen settings, until death or removal. Zeus has a continuous updated map marker showing the area it is active in. Zeus is not affected by the jammning and does not have to think about where the zeus character is currently placed to avoid jamming.

* **Radio Tracking (TFAR only):** Zeus can enable the module which makes all usage of the TFAR radios broadcast a spectrum signal while transmitting. Can be used to track enemies using the radio. If the player has the Icom radio (misc equipment) in the inventory the player can listen to the TFAR traffic being tracked and hear the other players.   


**All features have been tested on a dedicated server with multiple clients. Big thanks to the people that helped me test. You know who you are!**

### Debugging
All logging made to the .RPT file will start with CrowsEW-module: where the module is whatever module is writing the entry. Only done upon errors.

### Contributors
Crowdedlight (Main Author)  
b-mayr-1984 (Dev Work)  
Landric (Dev Work)  
OverlordZorn (Dev Work)  
DartRuffian (Dev Work)    
MonkeyBadger (Voice-line work)  
Technovibegames (Voice-line work)  
WindWalker (Voice-line work)  
Huzy1018 (Translation)  

### License 
Crows Electronic Warfare is licensed under the Arma Public License Share Alike. Please do not reupload to the Steam Workshop without permission!

### Building Wiki
Wiki is build automatically for tags and deployed. To manually preview them locally run:
```
cargo install mdbook
mdbook serve
```
Requires rust is installed. 

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
large alien machine call by john129pats: https://freesound.org/people/john129pats/sounds/147907/  
custom reaper horn.mp3 by darkadders: https://freesound.org/people/darkadders/sounds/217517/  
Four_Voices_Whispering_2.wav by geoneo0: https://freesound.org/people/geoneo0/sounds/193811/ 
Shadows by carmsie: https://freesound.org/people/carmsie/sounds/271634/ 
Kid Ghost Sigh.wav by HorrorAudio: https://freesound.org/people/HorrorAudio/sounds/431979/ 
horror Ghost low-pitched sound.wav by HaraldDeLuca: https://freesound.org/people/HaraldDeLuca/sounds/380511/ 
predator.ogg by Ediecz: https://freesound.org/people/Ediecz/sounds/507771/ 


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
FM_on_AM.wav by AlienXXX: https://freesound.org/people/AlienXXX/sounds/243540/  
Transformer malfunction by complex_waveform: https://freesound.org/people/complex_waveform/sounds/213147/   
Helicopter by deleted_user_3544904: https://freesound.org/people/deleted_user_3544904/sounds/194250/  
Walking in the mud by arnaud coutancier: https://freesound.org/people/arnaud%20coutancier/sounds/582400/ 


Sounds used under [Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/) is listed here with credit:

Stuka Siren Sound Effect by Alexander: https://orangefreesounds.com/stuka-siren-sound-effect/  
Dog Barking Noise by Alexander: https://orangefreesounds.com/dog-barking-noise/  
Woof Woof by Alexander: https://orangefreesounds.com/woof-woof/  
Telephone Ring Sound Effect BY SPANAC: https://www.freesoundslibrary.com/telephone-ring-sound-effect/ 
Old Fashioned Telephone Ringing Sound BY SPANAC: https://www.freesoundslibrary.com/old-fashioned-telephone-ringing-sound/ 
Cutting Tree BY SPANAC: https://www.freesoundslibrary.com/cutting-tree/ 
Whisper swoosh_8(mltprcssng).wav by newlocknew: https://freesound.org/people/newlocknew/sounds/582488/
Foliage_Rustling_001.wav by duckduckpony: https://freesound.org/people/duckduckpony/sounds/204030/ 
Ghost Child by RetroGuy23: https://freesound.org/people/RetroGuy23/sounds/651953/ 
tiger roar by videog: https://freesound.org/people/videog/sounds/149190/ 


Sounds used under [Sampling Plus 1.0](https://creativecommons.org/licenses/sampling+/1.0/) is listed here with credit:

scary.wav by Y0Klaver: https://freesound.org/people/Y0Klaver/sounds/109320/ 
