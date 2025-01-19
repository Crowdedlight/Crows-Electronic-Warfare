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

private _commit = 0.1;

// get display that is the spectrum gui display
private _display = uiNamespace getVariable ["RscWeaponSpectrumAnalyzerGeneric", displayNull];
// get the control for the display. This is the IDC as basegame use
private _ctrlSpectrum = _display displayCtrl 1999;
// get the icon controls
private _icons = _ctrlSpectrum getVariable ["bin_icons",[]];
// get the spectrum gui position and size
(ctrlPosition _ctrlSpectrum) params ["_posX","_posY","_posW","_posH"];

// get max icons available. I think the gui has a maximum of less than 20.
private _iconsMax = count _icons;
private _iconID = 0;

// size variables to fit the icon, same size as in contact
private _ctrlIconW = 0.08;
private _ctrlIconH = _ctrlIconW * 4/3;

// segment width, where we divide the gui width up into 100 sections. Same approach as in contact
private _segmentW = _posW / 100;

// vars to get the strongest signal within the selection, to highlight. Our strength is from -120 to 0, with 0 being strongest
private _highlightedStrength = -1000;
private _highlightedFrequency = [];


// go through all signals, as they are in combined array we step 2 and lookback
for "_i" from 1 to (count _sigsArray) step 2 do {
    // get variables
    private _freq = _sigsArray select (_i - 1);
    private _strength = _sigsArray select _i;

    // var to check if focused
    private _isFocused = false;

    if (_iconID > _iconsMax - 1) then {continue;};

    // transform frequency into 0 to 100, to get the horizontal position based on the 100 segments
    private _valueID = round linearConversion [_freqMin,_freqMax,_freq,0,100];
    
    // transform the strength from dBm into 0-1, so it can be used to set the y-pos of the icon 
    private _valueStrength = linearConversion [_senMin,_senMax,_strength,0,1];

    // sanity check segment position is within range, as we do not force clipping
    if (_valueID >= 0 && _valueID <= 100) then {
        // check if stronger signal and within focus selection
        if (_strength > _highlightedStrength && {_freq >= _selectedFreqMin && _freq <= _selectedFreqMax}) then {
			_highlightedStrength = _strength;
            // save the vars needed to display text
			_highlightedFrequency = [_valueID, _valueStrength, _strength, _freq];
			_isFocused = true;
		};

        // get control for the icon
        private _ctrlIcon = _icons # _iconID;

        // calculate x/y pos. Based on id in the segment and height offset from the gui height. Almost same calculations as in Contact
        private _iconPos = [
            (_valueID) * _segmentW - (_ctrlIconW / 2),
            (_posH * (1 - (_valueStrength)) - _ctrlIconH * 1.35) max -(_ctrlIconH / 2) max ([0,0.05] select _isFocused),
            _ctrlIconW,
            _ctrlIconH
        ];

        // hide/show, 0 == showing
        if (ctrlFade _ctrlIcon > 0) then {
            _ctrlIcon ctrlSetPosition _iconPos;
            _ctrlIcon ctrlCommit 0;
            _ctrlIcon ctrlSetFade FADE_SHOW;
        };
        _ctrlIcon ctrlSetPosition _iconPos;
        _ctrlIcon ctrlCommit _commit;
        // increment icon ID to use different icon control per signal
        _iconID = _iconID + 1;
    };
};

//--- Focused signal
// get gui controls for focused signal label and name. We are not using "antenna" option here, but it does exist in gui
(_ctrlSpectrum getVariable ["bin_focusedTexts",[]]) params ["_ctrlFocusedFrequency","_ctrlFocusedNameFrequency"];
// set defaults for hiding text
private _fadeFrequency = FADE_HIDE;
private _fadeNameFrequency = FADE_HIDE;
private _fadeCommit = 0.1;

// check if we got a focused signal
if (_highlightedFrequency isNotEqualTo []) then {

	_highlightedFrequency params ["_valueID","_valueStrength", "_strength", "_freq"];
	
    // we got a signal, update fade value
    _fadeNameFrequency = FADE_SHOW;
	_fadeFrequency = FADE_SHOW;

    // set text
	_ctrlFocusedFrequency ctrlSetText format["\n %1 dBm", _strength toFixed 1];
	_ctrlFocusedNameFrequency ctrlSetText format["%1 MHz", _freq toFixed 1];

    // calculate y position of text
    private _textPosY = (_posH * (1 - (_valueStrength)) - 0.07 - _ctrlIconH) max 0;

	// Get desired width, final position and set it for each text
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

	} forEach [_ctrlFocusedFrequency,_ctrlFocusedNameFrequency];

	// _fadeIn = _valueID != (_ctrlFocusedFrequency getvariable ["id",-1]);
	// if (_fadeIn) then {
	// 	_ctrlFocusedFrequency setvariable ["id",_valueID];
	// 	_fadeCommit = 0;
	// 	_fadeNameFrequency = FADE_SHOW;
	// };
} else {
    // we got no focused signal, so hide text with longer fade and no text
    _fadeFrequency = FADE_HIDE;
    _fadeNameFrequency = FADE_HIDE;
    _fadeCommit = 1;
    _ctrlFocusedFrequency ctrlSetText "";
	_ctrlFocusedNameFrequency ctrlSetText "";
};

// apply focused signal values
_ctrlFocusedFrequency ctrlSetFade _fadeFrequency;
_ctrlFocusedFrequency ctrlCommit _fadeCommit;
_ctrlFocusedNameFrequency ctrlSetFade _fadeNameFrequency;
_ctrlFocusedNameFrequency ctrlCommit _fadeCommit;

//--- Hide unused icons
for "_j" from _iconID to _iconsMax do {
	private _ctrlIcon = _icons # _j;
	_ctrlIcon ctrlSetFade 1;
	_ctrlIcon ctrlCommit 0; //_commit
};

