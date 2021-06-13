#include "script_component.hpp"

// if not a player we don't do anything
if (!hasInterface) exitWith {}; 

// set default settings 
{ missionNamespace setVariable _x} forEach [
    ["#EM_FMin",390], 					// Minimum of frequency in MHz
	["#EM_FMax",500],					// Maximum of frequency in MHz
	["#EM_SMin",-100],					// Minimum of signal value, in RSSI -120 to 0, with 0 being the strongest
	["#EM_SMax",0],						// Maximum of signal value, in RSSI
	["#EM_SelMin",141.6],				// currently selected frequency band that you scroll back and forth
	["#EM_SelMax",142.6],				// currently selected frequency band that you scroll back and forth
	["#EM_Values",[]],					// signal values in array
	["#EM_Transmit",false],				// boolean if you are transmitting, Affects the background of the graph and the icon on the device.
	["#EM_Progress",0]					// progress of transmission, between 0 and 1
];

// register event callback, "addBeacon", as rest is local, event runs local jam function that adds to array and starts the while loop 
private _addId = [QGVAR(addBeacon), FUNC(addBeacon)] call CBA_fnc_addEventHandler;
private _removeId = [QGVAR(removeBeacon), FUNC(removeBeacon)] call CBA_fnc_addEventHandler;

// due to best practices we are gonna put the track loop in unscheduled space. 
// TODO, remove/add PFH based if any sources are active... 
GVAR(PFH_beaconPlayer) = [FUNC(spectrumTrackingLocal) , 0.5] call CBA_fnc_addPerFrameHandler; 