#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_spectrumHudStrength.sqf
Parameters: 
Return: 

Script being called by PFH to draw text for signal strength

*///////////////////////////////////////////////

#define FADE_SHOW	0
#define FADE_HIDE	1

// Don't draw unless spectrum screen is open

// check if current weapon is hgun_esd
if (!("hgun_esd_" in (currentWeapon player))) exitWith {}; 

// check if we got dialog or another display open? 
// 602 == inventory open, 12 == map, 24 == chatbox, 160 == uavTerminal
if (!isNull (findDisplay 602) || !isNull (findDisplay 24) || !isNull (findDisplay 160) || visibleMap) exitWith {};

// draw the signal of the peak within the selection period... this is not great performance wise is it? TODO
private _sigsArray = missionNamespace getVariable ["#EM_Values", []];
private _selectedFreqMin = 	missionNamespace getVariable["#EM_SelMin",-1];
private _selectedFreqMax = 	missionNamespace getVariable["#EM_SelMax",-1];

private _freqMin = 	missionNamespace getVariable["#EM_FMin",-1];
private _freqMax = 	missionNamespace getVariable["#EM_FMax",-1];

private _senMin = 	missionNamespace getVariable["#EM_SMin",-1];
private _senMax = 	missionNamespace getVariable["#EM_SMax",-1];

private _sigs = [];

private _commit = 0.1;

// get signals from _sigsArray
// private _strongestSignalStrength = 0;
for "_i" from 1 to (count _sigsArray) step 2 do { 

    private _freq = _sigsArray select (_i - 1);
    private _strength = _sigsArray select _i;

    _sigs pushBack [_freq, _strength];

    // systemChat format["freq: %1, strength: %2", _freq, _strength];

    // if (_freq < _selectedFreqMin || _freq > _selectedFreqMax) then {
    //     continue;
    // };

    // if (_strength < _strongestSignalStrength) then {
    //     _strongestSignalStrength = _strength;
    // };
};


// get all controls of the spectrum device, then we can target the individual control of where we want to edit
// IDD of spectrum is 300

// private _idcs = [configfile >> "RscInGameUI" >> "RscWeaponSpectrumAnalyzerGeneric", 1, true] call BIS_fnc_displayControls;
// diag_log _idcs;

// private _display = uiNamespace getVariable ["RscWeaponSpectrumAnalyzerGeneric", displayNull];

// add dialog to display?
// private _text = _display ctrlCreate ["RscSpectrumSignalText", -1];
// _text ctrlSetText "Hel";
// _text ctrlSetPosition [(0.266 * 1 + 0), (0.044 * 1.05 + 0), (0.466 * 1), (0.064 * 1.05)];
// _text ctrlCommit 0;

// todo check for null


// #define IDC_RSCWEAPONSPECTRUMANALYZER_LINES			1999
// private _ctrlSpectrum = _display displayctrl 1999;

private _display = uiNamespace getVariable ["RscWeaponSpectrumAnalyzerGeneric", displayNull];
private _ctrlSpectrum = _display displayctrl 1999;
private _icons = _ctrlSpectrum getvariable ["bin_icons",[]];

(ctrlposition _ctrlSpectrum) params ["_posX","_posY","_posW","_posH"];
// diag_log _icons;
//23:14:31 [Control #5000,Control #5001,Control #5002,Control #5003,Control #5004,Control #5005,Control #5006,Control #5007,Control #5008,Control #5009,Control #5010,Control #5011,Control #5012,Control #5013,Control #5014,Control #5015,Control #5016,Control #5017,Control #5018,Control #5019,No control]

private _iconsMax = count _icons;
private _iconID = 0;

private _ctrlIconW = 0.08;
private _ctrlIconH = _ctrlIconW * 4/3;

private _highlightedStrength = 100;
private _highlightedFrequency = [];
private _segmentW = _posW / 100; //ANALYZER_LEVELS;


{
    _x params ["_freq", "_strength"];

    if (_iconID > _iconsMax - 1) then {continue;};

    // private _params = _frequencyData param [_foreachindex,[]];
    // private _fAvg = GET_FREQUENCY_DATA_AVG(_params);


    private _valueID = round linearConversion [_freqMin,_freqMax,_freq,0,100];   //ANALYZER_LEVELS];
    private _valueStrength = linearConversion [_senMin,_senMax,_strength,0,1];   //ANALYZER_LEVELS];

    if (_valueID >= 0 && _valueID <= 100) then {
        // check if focused
        private _isFocused = false;
        if (_strength < _highlightedStrength && {_freq >= _selectedFreqMin && _freq <= _selectedFreqMax}) then {
			_highlightedStrength = _strength;
			_highlightedFrequency = [_valueID, _valueStrength, _strength, _freq];
			_isFocused = true;
		};

        private _ctrlIcon = _icons # _iconID;

        private _iconPos = [
            (_valueID) * _segmentW - (_ctrlIconW / 2),
            // (_posH * (1 - (_valuesGhost # _valueID)) - _ctrlIconH * 1.25) max -(_ctrlIconH / 2) max ([0,0.05] select _isFocused),
            (_posH * (1 - (_valueStrength)) - _ctrlIconH * 1.35) max -(_ctrlIconH / 2) max ([0,0.05] select _isFocused),
            _ctrlIconW,
            _ctrlIconH
        ];
        // systemChat format ["posX: %1, posY: %2, iconX: %3, iconY: %4, SegmentW: %5, ValueID: %6, Strength: %7", _posX, _posY, _iconPos#0, _iconPos#1, _segmentW, _valueID, _strength];

        // private _iconPos = [_posX, _posY, _ctrlIconW, _ctrlIconH];

        if (ctrlfade _ctrlIcon > 0) then {
            _ctrlIcon ctrlsetposition _iconPos;
            _ctrlIcon ctrlcommit 0;
            _ctrlIcon ctrlSetFade FADE_SHOW;
        };
        _ctrlIcon ctrlsetposition _iconPos;
        _ctrlIcon ctrlcommit _commit;
        _iconID = _iconID + 1;
    };
} forEach _sigs;

//--- Highlighted signal

(_ctrlSpectrum getvariable ["bin_focusedTexts",[]]) params ["_ctrlFocusedFrequency","_ctrlFocusedNameFrequency"];
private _fadeFrequency = FADE_HIDE;
private _fadeNameFrequency = FADE_HIDE;
private _fadeCommit = 0.1;
if !(_highlightedFrequency isequalto []) then {

	_highlightedFrequency params ["_valueID","_valueStrength", "_strength", "_freq"];
	

    // set text for focused signals
    // _ctrlFocusedNameAntenna ctrlsettext (toupper _antennaName);

	// private _frameTime = 1 / diag_fps;
	// _fadeNameFrequency = ctrlfade _ctrlFocusedNameFrequency;
	// _fadeNameAntenna = ctrlfade _ctrlFocusedNameAntenna;

	// _fadeNameAntenna = (_fadeNameAntenna + _frameTime) min 1;//FADE_HIDE;
	// _fadeNameFrequency = linearconversion [0.75,1,_fadeNameAntenna,1,0,true];
	// private _fadeStatus = (_fadeNameFrequency + _frameTime) min 1;
	// _fadeNameFrequency = linearconversion [0.5,1,_fadeStatus,1,0,true];
	// _fadeFrequency = linearconversion [0.5,1,_fadeStatus,1,0,true];
    systemChat "Showing text";
    _fadeNameFrequency = FADE_SHOW;
	_fadeFrequency = FADE_SHOW;

    // systemChat format["frametime: %1, fadeStatus: %2, fadeFreq: %3", _frameTime, _fadeStatus, _fadeFrequency];

	_ctrlFocusedFrequency ctrlsettext format["\n %1 dBm", _strength toFixed 1];
	_ctrlFocusedNameFrequency ctrlsettext format["%1 MHz", _freq toFixed 1];

    private _textPosY = (_posH * (1 - (_valueStrength)) - 0.07 - _ctrlIconH) max 0;

	//--- Get desired width
	{
		private _width = ctrlTextWidth _x;
		private _textPos = [
			(_valueID * _segmentW - _width / 2), // max 0 min (_posW - _width),
			_textPosY,
			_width,
			ctrlTextHeight _x
		];
		_x ctrlSetPosition _textPos;
		_x ctrlCommit 0; //_xCommit

	} foreach [_ctrlFocusedFrequency,_ctrlFocusedNameFrequency];

	// _fadeIn = _valueID != (_ctrlFocusedFrequency getvariable ["id",-1]);
	// if (_fadeIn) then {
	// 	_ctrlFocusedFrequency setvariable ["id",_valueID];
	// 	_fadeCommit = 0;
	// 	_fadeNameFrequency = FADE_SHOW;
	// };
} else {
	// _ctrlFocusedFrequency setvariable ["id",-1];
    _fadeFrequency = FADE_SHOW;
    _fadeNameFrequency = FADE_HIDE;
    _fadeCommit = 0.5;
    _ctrlFocusedFrequency ctrlsettext "";
	_ctrlFocusedNameFrequency ctrlsettext "";
};

// systemChat format["fadefreq: %1, iconID: %2", _fadeFrequency, _iconID];

_ctrlFocusedFrequency ctrlsetfade _fadeFrequency;
_ctrlFocusedFrequency ctrlcommit _fadeCommit;
_ctrlFocusedNameFrequency ctrlsetfade _fadeNameFrequency;
_ctrlFocusedNameFrequency ctrlcommit _fadeCommit;

//--- Hide unused icons
for "_j" from _iconID to _iconsMax do {
	private _ctrlIcon = _icons # _j;
	_ctrlIcon ctrlsetfade 1;
	_ctrlIcon ctrlcommit 0; //_commit
};

