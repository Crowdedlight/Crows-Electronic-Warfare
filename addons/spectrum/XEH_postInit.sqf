#include "script_component.hpp"

// if server, set eventhandlers for server 
if (isServer) then {
	// event listener for adding trackable random radio chatter on units - server only
	private _randomRadioChatterTrackingId = [QGVAR(addRandomRadioTrackingChatter), FUNC(addRandomRadioTrackingChatterServer)] call CBA_fnc_addEventHandler;
	private _removeRandomRadioChatterTrackingId = [QGVAR(removeRandomRadioTrackingChatter), FUNC(removeRandomRadioTrackingChatterServer)] call CBA_fnc_addEventHandler;
};

// if not a player we don't do anything
if (!hasInterface) exitWith {}; 

// spectrum device handlers and default settings are set in "spectrumEnableSettingChanged" to allow for disable/enable of device
//  The add beacon code and zeus modules are still active, as the disable can be set individually. And as long as the local handlers are disabled, they can't interferer.

// register event callback, "addBeacon", as rest is local, event runs local jam function that adds to array and starts the while loop 
private _addId = [QGVAR(addBeacon), FUNC(addBeacon)] call CBA_fnc_addEventHandler;
private _removeId = [QGVAR(removeBeacon), FUNC(removeBeacon)] call CBA_fnc_addEventHandler;

// event listener to enable/disable TFAR signal sourcing
private _tfarTrackingId = [QGVAR(toggleRadioTracking), FUNC(toggleRadioTracking)] call CBA_fnc_addEventHandler;

