#include "script_component.hpp"

// if server, set eventhandlers for server 
if (isServer) then {
	// event listener for adding trackable random radio chatter on units - server only
	private _randomRadioChatterTrackingId = [QGVAR(addRandomRadioTrackingChatter), FUNC(addRandomRadioTrackingChatterServer)] call CBA_fnc_addEventHandler;
	private _removeRandomRadioChatterTrackingId = [QGVAR(removeRandomRadioTrackingChatter), FUNC(removeRandomRadioTrackingChatterServer)] call CBA_fnc_addEventHandler;
};

// if not a player we don't do anything
if (!hasInterface) exitWith {}; 

// set default settings 
{ missionNamespace setVariable _x} forEach [
    ["#EM_FMin",0], 					// Minimum of frequency in MHz
	["#EM_FMax",0],						// Maximum of frequency in MHz
	["#EM_SMin",-100],					// Minimum of signal value, in RSSI -120 to 0, with 0 being the strongest
	["#EM_SMax",0],						// Maximum of signal value, in RSSI
	["#EM_SelMin",140.6],				// currently selected frequency band that you scroll back and forth
	["#EM_SelMax",150.6],				// currently selected frequency band that you scroll back and forth
	["#EM_Values",[]],					// signal values in array
	["#EM_Transmit",false],				// boolean if you are transmitting, Affects the background of the graph and the icon on the device.
	["#EM_Progress",0]					// progress of transmission, between 0 and 1
];

// register event callback, "addBeacon", as rest is local, event runs local jam function that adds to array and starts the while loop 
private _addId = [QGVAR(addBeacon), FUNC(addBeacon)] call CBA_fnc_addEventHandler;
private _removeId = [QGVAR(removeBeacon), FUNC(removeBeacon)] call CBA_fnc_addEventHandler;

// event listener to enable/disable TFAR signal sourcing
private _tfarTrackingId = [QGVAR(toggleRadioTracking), FUNC(toggleRadioTracking)] call CBA_fnc_addEventHandler;

// due to best practices we are gonna put the track loop in unscheduled space. 
// TODO, remove/add PFH based if any sources are active...
GVAR(PFH_beaconPlayer) = [FUNC(spectrumTrackingLocal), 0.2] call CBA_fnc_addPerFrameHandler; 
GVAR(PFH_SpectrumAttachmentPlayer) = [FUNC(spectrumAttachmentLocal), 1] call CBA_fnc_addPerFrameHandler; 

// Spectrum event handler for "FIRE" spectrum analyzer 
["MouseButtonDown", {_this call FUNC(spectrumDeviceMouseDown)}] call CBA_fnc_addDisplayHandler;
["MouseButtonUp", {_this call FUNC(spectrumDeviceMouseUp)}] call CBA_fnc_addDisplayHandler;

// only if zeus, add draw3D handler for radio units
if (!isNull (getAssignedCuratorLogic player)) exitWith {};

GVAR(unit_icon_drawEH) = addMissionEventHandler ["Draw3D", {
	// if zeus display is null, exit. Only drawing when zeus display is open
	if (isNull(findDisplay 312)) exitWith {};
	if (isNull _x) exitWith {};

	{
		// draw icon on relative pos 
		drawIcon3D ["", [1,0,0,1], ASLToAGL getPosASL _x, 0, 0, 0, "RadioChatter", 1, 0.05];
	} forEach GVAR(radioTrackingAiUnits);
}];