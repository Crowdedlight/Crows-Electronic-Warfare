#include "script_component.hpp"
#include "XEH_PREP.hpp"

ADDON = true;

// params ["_unit", "_delayBetween", "_range", "_repeat", "_aliveCondition", "_sound", "_enabled", "_delayInitial"];
GVAR(soundList) = [];

// hashmap with each sound and their playtime
GVAR(soundAttributes) = createHashMap;

// sound configs key: [length, filepath, displayname]
GVAR(soundAttributes) set ["jam_loop", [0.4, "z\crowsEW\addons\sounds\data\jam_effect.ogg", localize "STR_CROWSEW_Sounds_jam_loop"]];
GVAR(soundAttributes) set ["jam_start", [0.9, "z\crowsEW\addons\sounds\data\jam_start.ogg", localize "STR_CROWSEW_Sounds_jam_start"]];
GVAR(soundAttributes) set ["air_raid_siren", [137, "z\crowsEW\addons\sounds\data\air_raid_siren.ogg", localize "STR_CROWSEW_Sounds_air_raid_1"]];
GVAR(soundAttributes) set ["air_raid_siren_2", [123, "z\crowsEW\addons\sounds\data\air_raid_siren_2.ogg", localize "STR_CROWSEW_Sounds_air_raid_2"]];
GVAR(soundAttributes) set ["angry_mob", [12, "z\crowsEW\addons\sounds\data\angry_mob.ogg", localize "STR_CROWSEW_Sounds_angry_mob"]];
GVAR(soundAttributes) set ["bird_whistle_robin", [3, "z\crowsEW\addons\sounds\data\bird_whistle_robin.ogg", localize "STR_CROWSEW_Sounds_bird_robin"]];
GVAR(soundAttributes) set ["car_alarm", [18, "z\crowsEW\addons\sounds\data\car_alarm.ogg", localize "STR_CROWSEW_Sounds_caralarm"]];
GVAR(soundAttributes) set ["cathedral_bells", [20, "z\crowsEW\addons\sounds\data\cathedral_bells.ogg", localize "STR_CROWSEW_Sounds_church_bells"]];
GVAR(soundAttributes) set ["crow_call", [2, "z\crowsEW\addons\sounds\data\crow_call.ogg", localize "STR_CROWSEW_Sounds_crow"]];
GVAR(soundAttributes) set ["dinosaur_roar", [1.2, "z\crowsEW\addons\sounds\data\dinosaur_roar.ogg", localize "STR_CROWSEW_Sounds_dino_roar"]];
GVAR(soundAttributes) set ["footsteps_boots_gravel", [11.4, "z\crowsEW\addons\sounds\data\footsteps_boots_gravel.ogg", localize "STR_CROWSEW_Sounds_footsteps_gravel"]];
GVAR(soundAttributes) set ["footsteps_twigs", [5.2, "z\crowsEW\addons\sounds\data\footsteps_twigs.ogg", localize "STR_CROWSEW_Sounds_footsteps_twigs"]];
GVAR(soundAttributes) set ["fox_cry", [1, "z\crowsEW\addons\sounds\data\fox_cry.ogg", localize "STR_CROWSEW_Sounds_fox"]];
GVAR(soundAttributes) set ["heartbeat", [2, "z\crowsEW\addons\sounds\data\heartbeat.ogg", localize "STR_CROWSEW_Sounds_heartbeat"]];
GVAR(soundAttributes) set ["heavy_dinosaur_footsteps", [3, "z\crowsEW\addons\sounds\data\heavy_dinosaur_footsteps.ogg", localize "STR_CROWSEW_Sounds_dino_footsteps"]];
GVAR(soundAttributes) set ["mechanical_turn_off", [1.5, "z\crowsEW\addons\sounds\data\mechanical_turn_off.ogg", localize "STR_CROWSEW_Sounds_mech_turn_off"]];
GVAR(soundAttributes) set ["prayer_calls_turkey", [147, "z\crowsEW\addons\sounds\data\prayer_calls_turkey.ogg", localize "STR_CROWSEW_Sounds_prayer_call"]];
GVAR(soundAttributes) set ["red_alert_alarm", [8, "z\crowsEW\addons\sounds\data\red_alert_alarm.ogg", localize "STR_CROWSEW_Sounds_red_alert"]];
GVAR(soundAttributes) set ["rooster_call", [2, "z\crowsEW\addons\sounds\data\rooster_call.ogg", localize "STR_CROWSEW_Sounds_rooster"]];
GVAR(soundAttributes) set ["sad_song", [69, "z\crowsEW\addons\sounds\data\sad_song.ogg", localize "STR_CROWSEW_Sounds_sad_song"]];
GVAR(soundAttributes) set ["space_ship_radar", [8, "z\crowsEW\addons\sounds\data\space_ship_radar.ogg", localize "STR_CROWSEW_Sounds_spaceship_radar"]];
GVAR(soundAttributes) set ["t_rex_growl", [5, "z\crowsEW\addons\sounds\data\t_rex_growl.ogg", localize "STR_CROWSEW_Sounds_trex_growl"]];
GVAR(soundAttributes) set ["t_rex_roar", [4, "z\crowsEW\addons\sounds\data\t_rex_roar.ogg", localize "STR_CROWSEW_Sounds_trex_roar"]];
GVAR(soundAttributes) set ["this_statement_is_false", [6, "z\crowsEW\addons\sounds\data\this_statement_is_false.ogg", localize "STR_CROWSEW_Sounds_spooky_sentence"]];
GVAR(soundAttributes) set ["tripod_horn_1", [8, "z\crowsEW\addons\sounds\data\tripod_horn_1.ogg", localize "STR_CROWSEW_Sounds_tripod_horn_1"]];
GVAR(soundAttributes) set ["tripod_horn_blast", [10, "z\crowsEW\addons\sounds\data\tripod_horn_blast.ogg", localize "STR_CROWSEW_Sounds_tripod_horn_blast"]];
GVAR(soundAttributes) set ["wilhelm_scream", [1.2, "z\crowsEW\addons\sounds\data\wilhelm_scream.ogg", localize "STR_CROWSEW_Sounds_wilhelm"]];
GVAR(soundAttributes) set ["zombie_growling", [8, "z\crowsEW\addons\sounds\data\zombie_growling.ogg", localize "STR_CROWSEW_Sounds_zombie_growl"]];
GVAR(soundAttributes) set ["zombie_sound", [6, "z\crowsEW\addons\sounds\data\zombie_sound.ogg", localize "STR_CROWSEW_Sounds_zombie_sound"]];
GVAR(soundAttributes) set ["stuka_siren", [15.4, "z\crowsEW\addons\sounds\data\stuka_siren.ogg", localize "STR_CROWSEW_Sounds_stuka"]];
GVAR(soundAttributes) set ["dog_barking", [12.4, "z\crowsEW\addons\sounds\data\dog_barking.ogg", localize "STR_CROWSEW_Sounds_dog_bark"]];
GVAR(soundAttributes) set ["dog_bark_german", [19, "z\crowsEW\addons\sounds\data\dog_bark_german.ogg", localize "STR_CROWSEW_Sounds_dog_german_barking"]];
GVAR(soundAttributes) set ["slap", [1, "z\crowsEW\addons\sounds\data\slap.ogg", localize "STR_CROWSEW_Sounds_slap"]];
GVAR(soundAttributes) set ["telephone_ringing", [11.6, "z\crowsEW\addons\sounds\data\telephone_ring_sound_effect.ogg", localize "STR_CROWSEW_Sounds_telephone_ringing"]];
GVAR(soundAttributes) set ["old_telephone_ringing", [12.8, "z\crowsEW\addons\sounds\data\old_fashioned_telephone_ringing_sound.ogg", localize "STR_CROWSEW_Sounds_old_telephone_ringing"]];
GVAR(soundAttributes) set ["chainsaw_cutting", [13.6, "z\crowsEW\addons\sounds\data\chainsaw_cutting.ogg", localize "STR_CROWSEW_Sounds_chainsaw"]];
GVAR(soundAttributes) set ["fire_sequence_init_5min", [4.5, "z\crowsEW\addons\sounds\data\fire_sequence_initiated_5min.ogg", localize "STR_CROWSEW_Sounds_fire_sequence"]];
GVAR(soundAttributes) set ["device_armed", [1.1, "z\crowsEW\addons\sounds\data\device_armed.ogg", localize "STR_CROWSEW_Sounds_device_armed"]];
GVAR(soundAttributes) set ["device_disarmed", [1.5, "z\crowsEW\addons\sounds\data\device_disarmed.ogg", localize "STR_CROWSEW_Sounds_device_disarmed"]];
GVAR(soundAttributes) set ["throat_singing", [35, "z\crowsEW\addons\sounds\data\throat_singing.ogg", localize "STR_CROWSEW_Sounds_throat_singing"]];
GVAR(soundAttributes) set ["machine_open", [4, "z\crowsEW\addons\sounds\data\machine_open.ogg", localize "STR_CROWSEW_Sounds_machine_open"]];
GVAR(soundAttributes) set ["footsteps_mud", [10.5, "z\crowsEW\addons\sounds\data\footsteps_mud.ogg", localize "STR_CROWSEW_Sounds_footsteps_mud"]];
GVAR(soundAttributes) set ["spooky_background_hum", [15, "z\crowsEW\addons\sounds\data\spooky_background_hum.ogg", localize "STR_CROWSEW_Sounds_spooky_background_hum"]];
GVAR(soundAttributes) set ["foliage_rustling", [7.5, "z\crowsEW\addons\sounds\data\foliage_rustling.ogg", localize "STR_CROWSEW_Sounds_foliage_rustling"]];
GVAR(soundAttributes) set ["whisper_ghostly", [2.5, "z\crowsEW\addons\sounds\data\whisper_ghostly.ogg", localize "STR_CROWSEW_Sounds_ghostly_whisper"]];
GVAR(soundAttributes) set ["shadows_sentence", [6.5, "z\crowsEW\addons\sounds\data\shadows_sentence.ogg", localize "STR_CROWSEW_Sounds_things_shadows"]];
GVAR(soundAttributes) set ["whisper_spooky", [7.8, "z\crowsEW\addons\sounds\data\whisper_spooky.ogg", localize "STR_CROWSEW_Sounds_spooky_whisper"]];
GVAR(soundAttributes) set ["ghost_sigh", [3.2, "z\crowsEW\addons\sounds\data\ghost_sigh.ogg", localize "STR_CROWSEW_Sounds_ghost_kid_sigh"]];
GVAR(soundAttributes) set ["ghost_child", [5, "z\crowsEW\addons\sounds\data\ghost_child.ogg", localize "STR_CROWSEW_Sounds_ghost_child_noise"]];
GVAR(soundAttributes) set ["ghost_horror_noise", [11.5, "z\crowsEW\addons\sounds\data\ghost_horror_noise.ogg", localize "STR_CROWSEW_Sounds_ghost_horror_noise"]];
GVAR(soundAttributes) set ["tiger_growl", [5.3, "z\crowsEW\addons\sounds\data\tiger_growl.ogg", localize "STR_CROWSEW_Sounds_tiger_growl"]];
GVAR(soundAttributes) set ["tiger_roar", [1.8, "z\crowsEW\addons\sounds\data\tiger_roar.ogg", localize "STR_CROWSEW_Sounds_tiger_roar"]];
GVAR(soundAttributes) set ["predator_clicking_sound", [2, "z\crowsEW\addons\sounds\data\predator_clicking_sound.ogg", localize "STR_CROWSEW_Sounds_predator_clicking"]];


// sound configs from voice-pack sounds
GVAR(soundAttributes) set ["sos_morse_code", [6, "z\crowsEW\addons\spectrum\data\voice\morse_code\sos_morse.ogg", localize "STR_CROWSEW_Sounds_voicepacks_morse"]];
GVAR(soundAttributes) set ["what_hath_god_wrought_morse_code", [11.4, "z\crowsEW\addons\spectrum\data\voice\morse_code\what_hath_god_wrought.ogg", localize "STR_CROWSEW_Sounds_voicepacks_morse_first"]];
GVAR(soundAttributes) set ["dial_up_modem", [23, "z\crowsEW\addons\spectrum\data\voice\electronic\modem_done.ogg", localize "STR_CROWSEW_Sounds_voicepacks_dial_up"]];
GVAR(soundAttributes) set ["spaceship_alarm", [3, "z\crowsEW\addons\spectrum\data\voice\electronic\spaceship_alarm_siren.ogg", localize "STR_CROWSEW_Sounds_voicepacks_spaceship_alarm"]];
GVAR(soundAttributes) set ["electricity_with_buzzing", [5.5, "z\crowsEW\addons\spectrum\data\voice\electronic\electricity_with_buzzing.ogg", localize "STR_CROWSEW_Sounds_voicepacks_electricity_buzzing"]];
GVAR(soundAttributes) set ["arcane_blast_hit", [2.6, "z\crowsEW\addons\spectrum\data\voice\alien_electronic\arcane_blast_hit.ogg", localize "STR_CROWSEW_Sounds_voicepacks_arcane_blast"]];
GVAR(soundAttributes) set ["custom_reaper_horn", [3.5, "z\crowsEW\addons\spectrum\data\voice\alien_electronic\custom_reaper_horn.ogg", localize "STR_CROWSEW_Sounds_voicepacks_reaper_horn"]];
GVAR(soundAttributes) set ["futuristic_machine_turn_off", [2.4, "z\crowsEW\addons\spectrum\data\voice\alien_electronic\futuristic_machine_turn_off.ogg", localize "STR_CROWSEW_Sounds_voicepacks_machine_off"]];
GVAR(soundAttributes) set ["futuristic_machine_turn_on", [2, "z\crowsEW\addons\spectrum\data\voice\alien_electronic\futuristic_machine_turn_on.ogg", localize "STR_CROWSEW_Sounds_voicepacks_machine_on"]];
GVAR(soundAttributes) set ["large_alien_machine_call", [6.9, "z\crowsEW\addons\spectrum\data\voice\alien_electronic\large_alien_machine_call.ogg", localize "STR_CROWSEW_Sounds_voicepacks_large_machine_call"]];
GVAR(soundAttributes) set ["transformer_malfunction", [4.4, "z\crowsEW\addons\spectrum\data\voice\alien_electronic\transformer_malfunction.ogg", localize "STR_CROWSEW_Sounds_voicepacks_transformer_malfunction"]];


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

