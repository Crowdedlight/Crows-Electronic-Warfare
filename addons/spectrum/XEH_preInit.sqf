#include "script_component.hpp"
#include "XEH_PREP.hpp"

ADDON = true;

// [target, frequency]
GVAR(beacons) = [];

// What frequency attachment is on 
GVAR(spectrumRangeAntenna) = -1;
GVAR(radioTrackingEnabled) = false;

// array of special units
GVAR(radioTrackingAiUnits) = [];

// Jamming variables
GVAR(isJammingDrone) = objNull;

// array of voice lines - ["classname", duration];
// GVAR(voiceLinesList) = [
// 	["radiocheck", 4.5],
// 	["bolembuggy", 4.3]
// ];

// GVAR(voiceLinesWeights) = [
// 	1,
// 	1
// ];

// POLICE RADIO PACK 
GVAR(voiceLinesPoliceList) = [
	["calling_all_units_I_need_a_10_45", 6],
	["drink_in_the_car_drugs_too", 5.5],
	["give_me_a_call_on_the_dog_and_bone_its_a_10_21", 7],
	["hold_hold_hold_10_23", 3],
	["i_need_a_road_advisory_give_me_a_10_13", 6],
	["i_stopped_a_deuce_comin_out_of_somerville", 3.6],
	["im_starvin_lets_go_for_a_code_4", 7],
	["its_an_emergency_10_100", 4],
	["loud_and_clear", 2],
	["ok_your_breakin_up_there_i_got_a_10_62", 5],
	["please_hold_its_a_10_6", 3],
	["recieving_poorly", 2],
	["stop_at_the_station_its_a_10_33", 4.5],
	["theres_to_much_traffic_on_this_channel_thats_a_10_75", 6],
	["this_guys_from_medford_drinkin_beer_in_his_car_im_a_take_him_in", 8.5],
	["two_went_off_the_10_5", 2.5],
	["we_got_a_cat_up_a_tree_can_we_get_an_officer_to_look_at_it", 8],
	["we_got_too_much_static_here_let_do_a_10_27", 6],
	["we_need_it_quick_10_17_please", 6.2],
	["where_are_you", 1.1]
];

GVAR(voiceLinesPoliceWeights) = [
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1
];

// ELETRONIC ALIEN SOUNDS 
GVAR(voiceLinesAlienEletronicList) = [
	["arcane_blast_hit", 2.5],
	["custom_reaper_horn", 3.5],
	["futuristic_machine_turn_off", 2.5],
	["futuristic_machine_turn_on", 2],
	["large_alien_machine_call", 7],
	["robot_transformation_full_complete_sequence", 12],
	["spaceship_alarm_siren_5_loop", 3],
	["transformer_malfunction", 4.5]
];

GVAR(voiceLinesAlienElectronicWeights) = [
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1
];

// MORSE CODE
GVAR(voiceLinesMorseCodeList) = [
	["bci_tx_qro", 6],
	["bk_cq_inf_close_north", 12],
	["cqd", 7.5],
	["ga_hpe_hpy_nw_ob", 9],
	["qrf_req", 4.2],
	["qrz_colossus_msg_send_bird", 14.4],
	["qrz_oz9fa_qrv", 9.1],
	["sos_morse", 6],
	["unlis_ham_stn_cfm", 8.4],
	["what_hath_god_wrought", 11.4]
];

GVAR(voiceLinesMorseCodeWeights) = [
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1
];

// Consider coming each pack in combined hashmap, key -> [list, weights]. Means we don't need to hardcode when selecting...