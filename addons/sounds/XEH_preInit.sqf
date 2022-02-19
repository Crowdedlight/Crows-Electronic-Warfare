#include "script_component.hpp"
#include "XEH_PREP.hpp"

ADDON = true;

// params ["_unit", "_delayBetween", "_range", "_repeat", "_aliveCondition", "_sound", "_enabled", "_delayInitial"];
GVAR(soundList) = [];

// hashmap with each sound and their playtime
GVAR(soundAttributes) = createHashMap;

// sound configs key: [length, filepath, displayname]
GVAR(soundAttributes) set ["jam_loop", [0.4, "z\crowsEW\addons\sounds\data\jam_effect.ogg", "Jammer Loop Sound"]];
GVAR(soundAttributes) set ["jam_start", [0.9, "z\crowsEW\addons\sounds\data\jam_start.ogg", "Computer Startup Sound"]];
GVAR(soundAttributes) set ["air_raid_siren", [137, "z\crowsEW\addons\sounds\data\air_raid_siren.ogg", "Air Raid Siren (2.5min)"]];
GVAR(soundAttributes) set ["air_raid_siren_2", [123, "z\crowsEW\addons\sounds\data\air_raid_siren_2.ogg", "Air Raid Siren 2 (2min)"]];
GVAR(soundAttributes) set ["angry_mob", [12, "z\crowsEW\addons\sounds\data\angry_mob.ogg", "Angry Mob (12s)"]];
GVAR(soundAttributes) set ["bird_whistle_robin", [3, "z\crowsEW\addons\sounds\data\bird_whistle_robin.ogg", "Bird Whistle Robin (3s)"]];
GVAR(soundAttributes) set ["car_alarm", [18, "z\crowsEW\addons\sounds\data\car_alarm.ogg", "Car Alarm (12s)"]];
GVAR(soundAttributes) set ["cathedral_bells", [20, "z\crowsEW\addons\sounds\data\cathedral_bells.ogg", "Cathedral Bells (20s)"]];
GVAR(soundAttributes) set ["crow_call", [2, "z\crowsEW\addons\sounds\data\crow_call.ogg", "Crow Call (2s)"]];
GVAR(soundAttributes) set ["dinosaur_roar", [1.2, "z\crowsEW\addons\sounds\data\dinosaur_roar.ogg", "Dinosaur Roar (1.2s)"]];
GVAR(soundAttributes) set ["footsteps_boots_gravel", [11.4, "z\crowsEW\addons\sounds\data\footsteps_boots_gravel.ogg", "Footsteps Gravel (11.4s)"]];
GVAR(soundAttributes) set ["footsteps_twigs", [5.2, "z\crowsEW\addons\sounds\data\footsteps_twigs.ogg", "Footsteps Twigs (5.2s)"]];
GVAR(soundAttributes) set ["fox_cry", [1, "z\crowsEW\addons\sounds\data\fox_cry.ogg", "Fox Cry (1s)"]];
GVAR(soundAttributes) set ["heartbeat", [2, "z\crowsEW\addons\sounds\data\heartbeat.ogg", "Heartbeat (2s)"]];
GVAR(soundAttributes) set ["heavy_dinosaur_footsteps", [3, "z\crowsEW\addons\sounds\data\heavy_dinosaur_footsteps.ogg", "Heavy Dino Footsteps (3s)"]];
GVAR(soundAttributes) set ["mechanical_turn_off", [1.5, "z\crowsEW\addons\sounds\data\mechanical_turn_off.ogg", "Mechanical Turn Off (1.5s)"]];
GVAR(soundAttributes) set ["prayer_calls_turkey", [147, "z\crowsEW\addons\sounds\data\prayer_calls_turkey.ogg", "Prayer Call Turkey (2.5min)"]];
GVAR(soundAttributes) set ["red_alert_alarm", [8, "z\crowsEW\addons\sounds\data\red_alert_alarm.ogg", "Red alert Alarm (8s)"]];
GVAR(soundAttributes) set ["rooster_call", [2, "z\crowsEW\addons\sounds\data\rooster_call.ogg", "Rooster Call (2s)"]];
GVAR(soundAttributes) set ["sad_song", [69, "z\crowsEW\addons\sounds\data\sad_song.ogg", "Woman singing sad song (1.1min)"]];
GVAR(soundAttributes) set ["space_ship_radar", [8, "z\crowsEW\addons\sounds\data\space_ship_radar.ogg", "Space Ship Radar (8s)"]];
GVAR(soundAttributes) set ["t_rex_growl", [5, "z\crowsEW\addons\sounds\data\t_rex_growl.ogg", "T-REX Growl (5s)"]];
GVAR(soundAttributes) set ["t_rex_roar", [4, "z\crowsEW\addons\sounds\data\t_rex_roar.ogg", "T-REX Roar (4s)"]];
GVAR(soundAttributes) set ["this_statement_is_false", [6, "z\crowsEW\addons\sounds\data\this_statement_is_false.ogg", "(spooky) This Statement Is False (6s)"]];
GVAR(soundAttributes) set ["tripod_horn_1", [8, "z\crowsEW\addons\sounds\data\tripod_horn_1.ogg", "Tripod Horn 1 (8s)"]];
GVAR(soundAttributes) set ["tripod_horn_blast", [10, "z\crowsEW\addons\sounds\data\tripod_horn_blast.ogg", "Tripos Horn Blast (10s)"]];
GVAR(soundAttributes) set ["wilhelm_scream", [1.2, "z\crowsEW\addons\sounds\data\wilhelm_scream.ogg", "Wilhelm Scream (1.2s)"]];
GVAR(soundAttributes) set ["zombie_growling", [8, "z\crowsEW\addons\sounds\data\zombie_growling.ogg", "Zombie Growling (8s)"]];
GVAR(soundAttributes) set ["zombie_sound", [6, "z\crowsEW\addons\sounds\data\zombie_sound.ogg", "Zombie Sound (6s)"]];
GVAR(soundAttributes) set ["stuka_siren", [15.4, "z\crowsEW\addons\sounds\data\stuka_siren.ogg", "Stuka Siren Diving (15s)"]];
GVAR(soundAttributes) set ["dog_barking", [12.4, "z\crowsEW\addons\sounds\data\dog_barking.ogg", "Dog Barking (12s)"]];
GVAR(soundAttributes) set ["dog_bark_german", [19, "z\crowsEW\addons\sounds\data\dog_bark_german.ogg", "Dog, German Shepard, Barking (19s)"]];
GVAR(soundAttributes) set ["slap", [1, "z\crowsEW\addons\sounds\data\slap.ogg", "Slap (1s)"]];
GVAR(soundAttributes) set ["telephone_ringing", [11.6, "z\crowsEW\addons\sounds\data\telephone_ring_sound_effect.ogg", "Telephone Ringing (12s)"]];
GVAR(soundAttributes) set ["old_telephone_ringing", [12.8, "z\crowsEW\addons\sounds\data\old_fashioned_telephone_ringing_sound.ogg", "Old Telephone Ringing (13s)"]];
GVAR(soundAttributes) set ["chainsaw_cutting", [13.6, "z\crowsEW\addons\sounds\data\chainsaw_cutting.ogg", "Chainsaw Cutting (14s)"]];
GVAR(soundAttributes) set ["fire_sequence_init_5min", [4.5, "z\crowsEW\addons\sounds\data\fire_sequence_initiated_5min.ogg", "Fire Sequence Init. 5min (5s)"]];
GVAR(soundAttributes) set ["device_armed", [1.1, "z\crowsEW\addons\sounds\data\device_armed.ogg", "Device Armed (1s)"]];
GVAR(soundAttributes) set ["device_disarmed", [1.5, "z\crowsEW\addons\sounds\data\device_disarmed.ogg", "Device Disarmed (2s)"]];


// sound configs from voice-pack sounds
GVAR(soundAttributes) set ["sos_morse_code", [6, "z\crowsEW\addons\spectrum\data\voice\morse_code\sos_morse.ogg", "Morse code - SOS (6s)"]];
GVAR(soundAttributes) set ["what_hath_god_wrought_morse_code", [11.4, "z\crowsEW\addons\spectrum\data\voice\morse_code\what_hath_god_wrought.ogg", "Morse code - What Hath God Wrought (12s)"]];
GVAR(soundAttributes) set ["dial_up_modem", [23, "z\crowsEW\addons\spectrum\data\voice\electronic\modem_done.ogg", "Dial Up Modem (23s)"]];
GVAR(soundAttributes) set ["spaceship_alarm", [3, "z\crowsEW\addons\spectrum\data\voice\electronic\spaceship_alarm_siren.ogg", "Spaceship Alarm (3s)"]];
GVAR(soundAttributes) set ["electricity_with_buzzing", [5.5, "z\crowsEW\addons\spectrum\data\voice\electronic\electricity_with_buzzing.ogg", "Electricity With Buzzing (6s)"]];
GVAR(soundAttributes) set ["arcane_blast_hit", [2.6, "z\crowsEW\addons\spectrum\data\voice\alien_electronic\arcane_blast_hit.ogg", "Arcane Blast Hit (3s)"]];
GVAR(soundAttributes) set ["custom_reaper_horn", [3.5, "z\crowsEW\addons\spectrum\data\voice\alien_electronic\custom_reaper_horn.ogg", "Reaper Horn (4s)"]];
GVAR(soundAttributes) set ["futuristic_machine_turn_off", [2.4, "z\crowsEW\addons\spectrum\data\voice\alien_electronic\futuristic_machine_turn_off.ogg", "Futuristic Machine Turn Off (3s)"]];
GVAR(soundAttributes) set ["futuristic_machine_turn_on", [2, "z\crowsEW\addons\spectrum\data\voice\alien_electronic\futuristic_machine_turn_on.ogg", "Futuristic Machine Turn On (2s)"]];
GVAR(soundAttributes) set ["large_alien_machine_call", [6.9, "z\crowsEW\addons\spectrum\data\voice\alien_electronic\large_alien_machine_call.ogg", "Large Alien Machine Call (7s)"]];
GVAR(soundAttributes) set ["transformer_malfunction", [4.4, "z\crowsEW\addons\spectrum\data\voice\alien_electronic\transformer_malfunction.ogg", "Transformer Malfunction (5s)"]];


// Base game sounds - none yet. Might come if I add dubbing


// Create array for zeus view once. Takes minimal more memoary but removes the need to iterate static data multiple times in runtime
private _sortArr = [];
{
	// push back [key, displayname]
	_sortArr pushBack [_x, (_y select 2)];
} forEach GVAR(soundAttributes);

// sort array
// _sortArr sort true;
_sortArr = [_sortArr, [], {_x select 1}, "ASCEND"] call BIS_fnc_sortBy;

// now we gotta split it into display names and keys, which is annoying, but gotta loop it again...
GVAR(soundZeusDisplayKeys) = [];
GVAR(soundZeusDisplay) = [];
{
	GVAR(soundZeusDisplayKeys) pushBack (_x select 0);
	GVAR(soundZeusDisplay) pushBack (_x select 1);
} forEach _sortArr;

