#include "script_component.hpp"
#include "XEH_PREP.hpp"

ADDON = true;

// [target, frequency]
GVAR(beacons) = [];

// What frequency attachment is on 
GVAR(spectrumRangeAntenna) = -1;
GVAR(radioTrackingEnabled) = false;

// array of special units -- public? 
GVAR(radioTrackingAiUnits) = [];

// array of voice lines - ["classname", duration];
GVAR(voiceLinesList) = [
	["radiocheck", 4.5],
	["bolembuggy", 4.3]
];

GVAR(voiceLinesWeights) = [
	1,
	1
];

// language support, think whats the best way to support it. multiple arrays per langauge and a function that just uses the right to select random from depending on language? Or some more complex way of having bigger arrays with all options? 