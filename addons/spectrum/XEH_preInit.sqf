#include "script_component.hpp"
#include "XEH_PREP.hpp"

ADDON = true;

// custom CBA setting to disable spectrum device code
[
    QGVAR(spectrumEnable), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX", // setting type
    "Enable Spectrum Device", // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    "Crows Electronic Warfare", // Pretty name of the category where the setting can be found. Can be stringtable entry.
    true, // data for this setting: [min, max, default, number of shown trailing decimals]
    nil, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    FUNC(spectrumEnableSettingChanged) // function that will be executed once on mission start and every time the setting is changed.
] call CBA_fnc_addSetting;

[
    QGVAR(tfarSideTrack), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX", // setting type
    ["Track Friendly with Radio Tracking", "Do you want your own side's radio transmissions to show on the spectrum device if Radio tracking is enabled?"], 
    "Crows Electronic Warfare", 
    false, 
    nil
] call CBA_fnc_addSetting;


// [target, frequency]
GVAR(beacons) = [];

// What frequency attachment is on 
GVAR(spectrumRangeAntenna) = -1;
GVAR(radioTrackingEnabled) = false;

GVAR(spectrumDeviceFrequencyRange) = [
	[30,389], 	// military antenna
	[390,500], 	// experimental antenna
	[433,440] 	// jammer 
];

// array of special units
GVAR(radioTrackingAiUnits) = [];

// Jamming variables
GVAR(isJammingDrone) = objNull;
GVAR(listeningToIcom) = false;

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

// ELETRONIC SOUNDS 
GVAR(voiceLinesEletronicList) = [
	["alarm", 2],
	["beep", 2.5],
	["electricity_with_buzzing", 5.4],
	["modem_done", 22.8],
	["shoot_beam_loop", 5],
	["spaceship_alarm_siren", 2.8]
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

// BRITISH
GVAR(voiceLinesBritishList) = [
	["ah_fuck_i_stepped_in_something", 2.6],
	["baseplate_this_is_hammer_two_four_we_have_visual_on_the_target_eta_sixty_seconds", 5],
	["do_you_think_the_lt_hates_me", 3.5],
	["fan_out_three_meter_spread", 2.3],
	["Hammer_two_four_we_got_tangos_on_the_second_floor", 3.5],
	["hq_this_is_xray_nothing_to_report_on_our_parol_over", 5.6],
	["kirk97_kirk97_slasher03_say_when_ready_to_copy_8_digit_grid", 7.2],
	["stop_lagging_behind_karl", 2],
	["yeah", 1]
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
GVAR(voiceLinePacks) set ["british", 			[GVAR(voiceLinesBritishList), GVAR(voiceLinesBritishWeights), "British"]];
GVAR(voiceLinePacks) set ["morsecode", 			[GVAR(voiceLinesMorseCodeList), GVAR(voiceLinesMorseCodeWeights), "Morse Code"]];
GVAR(voiceLinePacks) set ["electronic", 		[GVAR(voiceLinesEletronicList), GVAR(voiceLinesElectronicWeights), "Electronic"]];
GVAR(voiceLinePacks) set ["alienElectronic", 	[GVAR(voiceLinesAlienEletronicList), GVAR(voiceLinesAlienElectronicWeights), "Alien Electronic"]];
GVAR(voiceLinePacks) set ["police", 			[GVAR(voiceLinesPoliceList), GVAR(voiceLinesPoliceWeights), "Police Radio"]];


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
    ["Spectrum Autoline", "Allow players to automatically draw map lines from their position in the direction they're facing, when aiming the Spectrum Device."+endl+"Player must have a GPS equipped."],
    ["Crows Electronic Warfare", "Spectrum Autoline"],
    true,
    nil
] call CBA_fnc_addSetting;


[
    QGVAR(spectrumAutolineLength), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "SLIDER", // setting type
    ["Spectrum Autoline Length", "How long should the drawn autoline be, in meters."], 
    ["Crows Electronic Warfare", "Spectrum Autoline"],
    [200, 15000, 6000, 0],
    nil
] call CBA_fnc_addSetting;

[
    QGVAR(spectrumAutolineColor1), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "LIST", // setting type
    ["Spectrum Autoline Colour 1", "Colour that should be associated with autoline hotkey 1."],
    ["Crows Electronic Warfare", "Spectrum Autoline"],
    [_autolineColourIndexes, _autolineColourLabels, 2],
    nil
] call CBA_fnc_addSetting;

[
    QGVAR(spectrumAutolineColor2), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "LIST", // setting type
    ["Spectrum Autoline Colour 2", "Colour that should be associated with autoline hotkey 2."],
    ["Crows Electronic Warfare", "Spectrum Autoline"],
    [_autolineColourIndexes, _autolineColourLabels, 7],
    nil
] call CBA_fnc_addSetting;

[
    QGVAR(spectrumAutolineColor3), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "LIST", // setting type
    ["Spectrum Autoline Colour 3", "Colour that should be associated with autoline hotkey 3."],
    ["Crows Electronic Warfare", "Spectrum Autoline"],
    [_autolineColourIndexes, _autolineColourLabels, 8],
    nil
] call CBA_fnc_addSetting;

[
    QGVAR(spectrumAutolineColor4), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "LIST", // setting type
    ["Spectrum Autoline Colour 4", "Colour that should be associated with autoline hotkey 4."],
    ["Crows Electronic Warfare", "Spectrum Autoline"],
    [_autolineColourIndexes, _autolineColourLabels, 5],
    nil
] call CBA_fnc_addSetting;

[
    QGVAR(spectrumAutolineNoise), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "SLIDER", // setting type
    ["Spectrum Autoline Start Deviation", "How much the start of the autoline should differ from the player's actual position, in meters."+endl+"0 is perfectly accurate; 100 is (up to) a 100m deviation."], 
    ["Crows Electronic Warfare", "Spectrum Autoline"],
    [0, 100, 0, 0],
    nil
] call CBA_fnc_addSetting;


// register CBA keybinding to auto-draw lines on map for spectrum device
GVAR(spectrumAutolineC1Keybind) = [
    ["Crows Electronic Warfare", "Spectrum"],
    "spectrum_autoline_c1", 
    ["Spectrum Autoline (Colour 1)", "Draw a line on the map from the player's position, in the direction they're facing, when aiming with the Spectrum Device."+endl+"Player must have a GPS equipped."], 
    { [GVAR(spectrumAutolineColor1)] call FUNC(drawSpectrumLine); }, 
    "", 
    [DIK_SPACE, [false, false, false]], // [DIK code, [Shift?, Ctrl?, Alt?]]
    false
] call CBA_fnc_addKeybind;

GVAR(spectrumAutolineC2Keybind) = [
    ["Crows Electronic Warfare", "Spectrum"],
    "spectrum_autoline_c2", 
    ["Spectrum Autoline (Colour 2)", "Draw a line on the map from the player's position, in the direction they're facing, when aiming with the Spectrum Device."+endl+"Player must have a GPS equipped."], 
    { [GVAR(spectrumAutolineColor2)] call FUNC(drawSpectrumLine); }, 
    "", 
    [DIK_SPACE, [false, true, false]], // [DIK code, [Shift?, Ctrl?, Alt?]]
    false
] call CBA_fnc_addKeybind;

GVAR(spectrumAutolineC3Keybind) = [
    ["Crows Electronic Warfare", "Spectrum"],
    "spectrum_autoline_c3", 
    ["Spectrum Autoline (Colour 3)", "Draw a line on the map from the player's position, in the direction they're facing, when aiming with the Spectrum Device."+endl+"Player must have a GPS equipped."], 
    { [GVAR(spectrumAutolineColor3)] call FUNC(drawSpectrumLine); }, 
    "", 
    [DIK_SPACE, [true, false, false]], // [DIK code, [Shift?, Ctrl?, Alt?]]
    false
] call CBA_fnc_addKeybind;

GVAR(spectrumAutolineC4Keybind) = [
    ["Crows Electronic Warfare", "Spectrum"],
    "spectrum_autoline_c4", 
    ["Spectrum Autoline (Colour 4)", "Draw a line on the map from the player's position, in the direction they're facing, when aiming with the Spectrum Device."+endl+"Player must have a GPS equipped."], 
    { [GVAR(spectrumAutolineColor4)] call FUNC(drawSpectrumLine); }, 
    "", 
    [DIK_SPACE, [false, false, true]], // [DIK code, [Shift?, Ctrl?, Alt?]]
    false
] call CBA_fnc_addKeybind;
