#include "script_component.hpp"
#include "XEH_PREP.hpp"

ADDON = true;

// custom CBA setting to disable spectrum device code
[
    QGVAR(spectrumEnable), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX", // setting type
    localize "STR_CROWSEW_Spectrum_settings_enable_device_name", // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    "Crows Electronic Warfare", // Pretty name of the category where the setting can be found. Can be stringtable entry.
    true, // data for this setting: [min, max, default, number of shown trailing decimals]
    nil, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    FUNC(spectrumEnableSettingChanged) // function that will be executed once on mission start and every time the setting is changed.
] call CBA_fnc_addSetting;

[
    QGVAR(tfarSideTrack), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX", // setting type
    [localize "STR_CROWSEW_Spectrum_settings_radio_track_name", localize "STR_CROWSEW_Spectrum_settings_radio_track_tooltip"], 
    "Crows Electronic Warfare", 
    false, 
    nil
] call CBA_fnc_addSetting;

[
    QGVAR(selfTracking), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX", // setting type
    [localize "STR_CROWSEW_Spectrum_settings_self_tracking", localize "STR_CROWSEW_Spectrum_settings_self_tracking_tooltip"], 
    "Crows Electronic Warfare",
    false,	// bool, disabled by default to stay with current behaviour
    nil
] call CBA_fnc_addSetting;

[
    QGVAR(UAVterminalUserVisibleInSpectrum), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX", // setting type
    [localize "STR_CROWSEW_Spectrum_settings_uav_terminal_user_visible_in_spectrum", localize "STR_CROWSEW_Spectrum_settings_uav_terminal_user_visible_in_spectrum_tooltip"], 
    "Crows Electronic Warfare",
    false,	// bool, disabled by default to stay with current behaviour
    nil
] call CBA_fnc_addSetting;

[
    QGVAR(minJamSigStrength), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "SLIDER", // setting type
    [localize "STR_CROWSEW_Spectrum_settings_min_jam_strength", localize "STR_CROWSEW_Spectrum_settings_min_jam_strength_tooltip"], 
    ["Crows Electronic Warfare"],
    [-100, 0, -40, 0],	// [_min, _max, _default, _trailingDecimals, _isPercentage]
    nil
] call CBA_fnc_addSetting;

// Default jammable classes
[
    QGVAR(defaultClassForJammingSignal), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "EDITBOX", // setting type
    [localize "STR_CROWSEW_Spectrum_settings_default_jammable_drones", localize "STR_CROWSEW_Spectrum_settings_default_jammable_drones_tooltip"], 
    ["Crows Electronic Warfare", localize "STR_CROWSEW_Spectrum_settings_jamming"],
    "UGV_01_base_F,UGV_02_Base_F,UAV_01_base_F,UAV_02_base_F,UAV_03_base_F,UAV_04_base_F,UAV_05_Base_F,UAV_06_base_F,HMG_01_A_base_F,GMG_01_A_base_F,Static_Designator_01_base_F,Static_Designator_02_base_F,GX_DRONE40_UAV_BASE,GX_BLACKHORNET_UAV_BASE,GX_HONEYBADGER_UGV_BASE,GX_RQ11B_UAV_BASE,GX_MQ8B_UAV_BASE,ARMAFPV_Crocus_AT_Base,ua_drone_base_F", // all drones & UGV by default
    true, // is global, gotta be equal for all
	FUNC(jammableDronesInit),
	true // need mission restart - Required as I can't remove the existing class eventhandlers made on init
] call CBA_fnc_addSetting;

// Default signal ranges for jammable classes
[
    QGVAR(defaultRangesForJammingSignal), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "EDITBOX", // setting type
    [localize "STR_CROWSEW_Spectrum_settings_default_signal_range_for_jammable_drones", localize "STR_CROWSEW_Spectrum_settings_default_signal_range_for_jammable_drones_tooltip"], 
    ["Crows Electronic Warfare", localize "STR_CROWSEW_Spectrum_settings_jamming"],
    "298,299,301,3002,3003,3004,3005,306,307,308,309,310,311,312,313,314,3015,316,317", // all drones & UGV shall have a range of 3km by default
    true, // is global, gotta be equal for all
	nil,  // no associated script because this is only a companion parameter to defaultClassForJammingSignal which will already trigger a script
	true // need mission restart - Required as I can't remove the existing class eventhandlers made on init
] call CBA_fnc_addSetting;

// _unit, _frequency, _scanRange, _type
GVAR(beacons) = [];

// What frequency attachment is on 
GVAR(spectrumRangeAntenna) = -1;
GVAR(radioTrackingEnabled) = false;

// If changing values, remember to update tool-tips in CfgWeapons. Rest of code should update based on values here automatically
// Frequencies for antennas. Format: StartFreq, EndFreq, Span
GVAR(spectrumDeviceFrequencyRange) = [
	[30, 513, (513-30)], 		// military antenna - Radio
	[520, 1090, (1090-520)], 	// experimental antenna - Script/Zeus/C-Trackers
	[433, 445, (445-433)] 		// jammer - Drones
];

// array of special units
GVAR(radioTrackingAiUnits) = [];

// Jamming variables
GVAR(isJammingDrone) = objNull;
GVAR(listeningToIcom) = false;

// POLICE RADIO PACK 
GVAR(voiceLinesPoliceList) = [
	["crowsEW_calling_all_units_I_need_a_10_45", 6],
	["crowsEW_drink_in_the_car_drugs_too", 5.5],
	["crowsEW_give_me_a_call_on_the_dog_and_bone_its_a_10_21", 7],
	["crowsEW_hold_hold_hold_10_23", 3],
	["crowsEW_i_need_a_road_advisory_give_me_a_10_13", 6],
	["crowsEW_i_stopped_a_deuce_comin_out_of_somerville", 3.6],
	["crowsEW_im_starvin_lets_go_for_a_code_4", 7],
	["crowsEW_its_an_emergency_10_100", 4],
	["crowsEW_loud_and_clear", 2],
	["crowsEW_ok_your_breakin_up_there_i_got_a_10_62", 5],
	["crowsEW_please_hold_its_a_10_6", 3],
	["crowsEW_recieving_poorly", 2],
	["crowsEW_stop_at_the_station_its_a_10_33", 4.5],
	["crowsEW_theres_to_much_traffic_on_this_channel_thats_a_10_75", 6],
	["crowsEW_this_guys_from_medford_drinkin_beer_in_his_car_im_a_take_him_in", 8.5],
	["crowsEW_two_went_off_the_10_5", 2.5],
	["crowsEW_we_got_a_cat_up_a_tree_can_we_get_an_officer_to_look_at_it", 8],
	["crowsEW_we_got_too_much_static_here_let_do_a_10_27", 6],
	["crowsEW_we_need_it_quick_10_17_please", 6.2],
	["crowsEW_where_are_you", 1.1]
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

// ELECTRONIC ALIEN SOUNDS 
GVAR(voiceLinesAlienElectronicList) = [
	["crowsEW_arcane_blast_hit", 2.5],
	["crowsEW_custom_reaper_horn", 3.5],
	["crowsEW_futuristic_machine_turn_off", 2.5],
	["crowsEW_futuristic_machine_turn_on", 2],
	["crowsEW_large_alien_machine_call", 7],
	["crowsEW_robot_transformation_full_complete_sequence", 12],
	["crowsEW_spaceship_alarm_siren_5_loop", 3],
	["crowsEW_transformer_malfunction", 4.5]
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

// ELECTRONIC SOUNDS 
GVAR(voiceLinesElectronicList) = [
	["crowsEW_alarm", 2],
	["crowsEW_beep", 2.5],
	["crowsEW_electricity_with_buzzing", 5.4],
	["crowsEW_modem_done", 22.8],
	["crowsEW_shoot_beam_loop", 5],
	["crowsEW_spaceship_alarm_siren", 2.8]
];

GVAR(voiceLinesElectronicWeights) = [
	1,
	1,
	1,
	1,
	1,
	1
];

// MORSE CODE
GVAR(voiceLinesMorseCodeList) = [
	["crowsEW_bci_tx_qro", 6],
	["crowsEW_bk_cq_inf_close_north", 12],
	["crowsEW_cqd", 7.5],
	["crowsEW_ga_hpe_hpy_nw_ob", 9],
	["crowsEW_qrf_req", 4.2],
	["crowsEW_qrz_colossus_msg_send_bird", 14.4],
	["crowsEW_qrz_oz9fa_qrv", 9.1],
	["crowsEW_sos_morse", 6],
	["crowsEW_unlis_ham_stn_cfm", 8.4],
	["crowsEW_what_hath_god_wrought", 11.4]
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

// BRITISH
GVAR(voiceLinesBritishList) = [
	["crowsEW_ah_fuck_i_stepped_in_something", 2.6],
	["crowsEW_baseplate_this_is_hammer_two_four_we_have_visual_on_the_target_eta_sixty_seconds", 5],
	["crowsEW_do_you_think_the_lt_hates_me", 3.5],
	["crowsEW_fan_out_three_meter_spread", 2.3],
	["crowsEW_Hammer_two_four_we_got_tangos_on_the_second_floor", 3.5],
	["crowsEW_hq_this_is_xray_nothing_to_report_on_our_parol_over", 5.6],
	["crowsEW_kirk97_kirk97_slasher03_say_when_ready_to_copy_8_digit_grid", 7.2],
	["crowsEW_stop_lagging_behind_karl", 2],
	["crowsEW_yeah", 1]
];

GVAR(voiceLinesBritishWeights) = [
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

// each pack in combined hashmap, key -> [list, weights, displayname]
GVAR(voiceLinePacks) = createHashMap;
// add packs
GVAR(voiceLinePacks) set ["british", 			[GVAR(voiceLinesBritishList), GVAR(voiceLinesBritishWeights), localize "STR_CROWSEW_Spectrum_voiceline_british"]];
GVAR(voiceLinePacks) set ["morsecode", 			[GVAR(voiceLinesMorseCodeList), GVAR(voiceLinesMorseCodeWeights), localize "STR_CROWSEW_Spectrum_voiceline_morse"]];
GVAR(voiceLinePacks) set ["electronic", 		[GVAR(voiceLinesElectronicList), GVAR(voiceLinesElectronicWeights), localize "STR_CROWSEW_Spectrum_voiceline_electronic"]];
GVAR(voiceLinePacks) set ["alienElectronic", 	[GVAR(voiceLinesAlienElectronicList), GVAR(voiceLinesAlienElectronicWeights), localize "STR_CROWSEW_Spectrum_voiceline_alien_electronic"]];
GVAR(voiceLinePacks) set ["police", 			[GVAR(voiceLinesPoliceList), GVAR(voiceLinesPoliceWeights), localize "STR_CROWSEW_Spectrum_voiceline_police_radio"]];


// Spectrum autoline settings
GVAR(spectrumAutolineColours) = ["ColorBlack", "ColorGrey", "ColorRed", "ColorBrown", "ColorOrange", "ColorYellow", "ColorKhaki", "ColorGreen", "ColorBlue", "ColorPink", "ColorWhite", "ColorWEST", "ColorEAST", "ColorGUER", "ColorCIV"]; // Must only contain colours from CfgMarkerColors

// Alternatively, this could be done programmatically (see below), to account for custom colours
// However, this would mess with the "default" colours (and potentially the display names)
// So sticking with the hard-coded list of base-game colours for now

// private _colourCount = 0;
// {
// 	GVAR(spectrumAutolineColours) pushBack (configName _x);
// 	_autolineColourIndexes pushBack _colourCount;
// 	_colourCount = _colourCount + 1;
// } forEach configProperties [configFile >> "CfgMarkerColors"];

private _autolineColourIndexes = [];
for "_i" from 0 to count GVAR(spectrumAutolineColours) -1 do {
	_autolineColourIndexes pushBack _i;
};
private _autolineColourLabels = GVAR(spectrumAutolineColours) apply { _x select [5] }; // Strip "Color" prefix from labels

[
    QGVAR(spectrumAutoline), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX", // setting type
    [localize "STR_CROWSEW_Spectrum_settings_autoline_enable", [localize "STR_CROWSEW_Spectrum_settings_autoline_enable_tooltip", "<br/>", endl] call CBA_fnc_replace],
    ["Crows Electronic Warfare", localize "STR_CROWSEW_Spectrum_settings_autoline_catageory"],
    true,
    nil
] call CBA_fnc_addSetting;


[
    QGVAR(spectrumAutolineLength), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "SLIDER", // setting type
    [localize "STR_CROWSEW_Spectrum_settings_autoline_length", localize "STR_CROWSEW_Spectrum_settings_autoline_length_tooltip"], 
    ["Crows Electronic Warfare", localize "STR_CROWSEW_Spectrum_settings_autoline_catageory"],
    [200, 15000, 6000, 0],
    nil
] call CBA_fnc_addSetting;

[
    QGVAR(spectrumAutolineColor1), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "LIST", // setting type
    [localize "STR_CROWSEW_Spectrum_settings_autoline_color1", localize "STR_CROWSEW_Spectrum_settings_autoline_color1_tooltip"],
    ["Crows Electronic Warfare", localize "STR_CROWSEW_Spectrum_settings_autoline_catageory"],
    [_autolineColourIndexes, _autolineColourLabels, 2],
    nil
] call CBA_fnc_addSetting;

[
    QGVAR(spectrumAutolineColor2), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "LIST", // setting type
    [localize "STR_CROWSEW_Spectrum_settings_autoline_color2", localize "STR_CROWSEW_Spectrum_settings_autoline_color2_tooltip"],
    ["Crows Electronic Warfare", localize "STR_CROWSEW_Spectrum_settings_autoline_catageory"],
    [_autolineColourIndexes, _autolineColourLabels, 7],
    nil
] call CBA_fnc_addSetting;

[
    QGVAR(spectrumAutolineColor3), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "LIST", // setting type
    [localize "STR_CROWSEW_Spectrum_settings_autoline_color3", localize "STR_CROWSEW_Spectrum_settings_autoline_color3_tooltip"],
    ["Crows Electronic Warfare", localize "STR_CROWSEW_Spectrum_settings_autoline_catageory"],
    [_autolineColourIndexes, _autolineColourLabels, 8],
    nil
] call CBA_fnc_addSetting;

[
    QGVAR(spectrumAutolineColor4), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "LIST", // setting type
    [localize "STR_CROWSEW_Spectrum_settings_autoline_color4", localize "STR_CROWSEW_Spectrum_settings_autoline_color4_tooltip"],
    ["Crows Electronic Warfare", localize "STR_CROWSEW_Spectrum_settings_autoline_catageory"],
    [_autolineColourIndexes, _autolineColourLabels, 5],
    nil
] call CBA_fnc_addSetting;

[
    QGVAR(spectrumAutolineNoise), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "SLIDER", // setting type
    [localize "STR_CROWSEW_Spectrum_settings_autoline_deviation", [localize "STR_CROWSEW_Spectrum_settings_autoline_deviation_tooltip", "<br/>", endl] call CBA_fnc_replace],  
    ["Crows Electronic Warfare", localize "STR_CROWSEW_Spectrum_settings_autoline_catageory"],
    [0, 100, 0, 0],
    nil
] call CBA_fnc_addSetting;


// register CBA keybinding to auto-draw lines on map for spectrum device
GVAR(spectrumAutolineC1Keybind) = [
    ["Crows Electronic Warfare", "Spectrum"],
    "spectrum_autoline_c1", 
    [localize "STR_CROWSEW_Spectrum_keybinds_autoline_color1", [localize "STR_CROWSEW_Spectrum_keybinds_autoline_tooltip", "<br/>", endl] call CBA_fnc_replace], 
    { [GVAR(spectrumAutolineColor1)] call FUNC(drawSpectrumLine); }, 
    "", 
    [DIK_SPACE, [false, false, false]], // [DIK code, [Shift?, Ctrl?, Alt?]]
    false
] call CBA_fnc_addKeybind;

GVAR(spectrumAutolineC2Keybind) = [
    ["Crows Electronic Warfare", "Spectrum"],
    "spectrum_autoline_c2", 
    [localize "STR_CROWSEW_Spectrum_keybinds_autoline_color2", [localize "STR_CROWSEW_Spectrum_keybinds_autoline_tooltip", "<br/>", endl] call CBA_fnc_replace], 
    { [GVAR(spectrumAutolineColor2)] call FUNC(drawSpectrumLine); }, 
    "", 
    [DIK_SPACE, [false, true, false]], // [DIK code, [Shift?, Ctrl?, Alt?]]
    false
] call CBA_fnc_addKeybind;

GVAR(spectrumAutolineC3Keybind) = [
    ["Crows Electronic Warfare", "Spectrum"],
    "spectrum_autoline_c3", 
    [localize "STR_CROWSEW_Spectrum_keybinds_autoline_color3", [localize "STR_CROWSEW_Spectrum_keybinds_autoline_tooltip", "<br/>", endl] call CBA_fnc_replace],
    { [GVAR(spectrumAutolineColor3)] call FUNC(drawSpectrumLine); }, 
    "", 
    [DIK_SPACE, [true, false, false]], // [DIK code, [Shift?, Ctrl?, Alt?]]
    false
] call CBA_fnc_addKeybind;

GVAR(spectrumAutolineC4Keybind) = [
    ["Crows Electronic Warfare", "Spectrum"],
    "spectrum_autoline_c4", 
    [localize "STR_CROWSEW_Spectrum_keybinds_autoline_color4", [localize "STR_CROWSEW_Spectrum_keybinds_autoline_tooltip", "<br/>", endl] call CBA_fnc_replace],
    { [GVAR(spectrumAutolineColor4)] call FUNC(drawSpectrumLine); }, 
    "", 
    [DIK_SPACE, [false, false, true]], // [DIK code, [Shift?, Ctrl?, Alt?]]
    false
] call CBA_fnc_addKeybind;
