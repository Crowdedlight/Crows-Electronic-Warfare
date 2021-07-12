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
