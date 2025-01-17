#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_spectrumEnableSettingChanged.sqf
Parameters: new value
Return: none

called when spectrum device setting is changed. Can disable or enable the spectrum device. Exists so mission makers can enable/disable it, if they want to use the mod, but have custom code for the spectrum device

*///////////////////////////////////////////////
params ["_value"];

// if true, enable handlers
if (_value) then {
	{missionNamespace setVariable _x} forEach [
		["#EM_FMin",0], 					// Minimum of frequency in MHz
		["#EM_FMax",0],						// Maximum of frequency in MHz
		["#EM_SMin",-100],					// Minimum of signal value, in RSSI -100 to 0, with 0 being the strongest
		["#EM_SMax",0],						// Maximum of signal value, in RSSI
		["#EM_SelMin",140.6],				// currently selected frequency band that you scroll back and forth
		["#EM_SelMax",150.6],				// currently selected frequency band that you scroll back and forth
		["#EM_Values",[]],					// signal values in array
		["#EM_Transmit",false],				// boolean if you are transmitting, Affects the background of the graph and the icon on the device.
		["#EM_Progress",0]					// progress of transmission, between 0 and 1
	];

	// reset value so our PFH correctly sets the current frequencies for the attached antenna
	GVAR(LastSpectrumMuzzleAttachment) = "";

	// due to best practices we are gonna put the track loop in unscheduled space. 
	GVAR(PFH_beaconPlayer) = [FUNC(spectrumTrackingLocal), 0.1] call CBA_fnc_addPerFrameHandler; 
	GVAR(PFH_SpectrumAttachmentPlayer) = [FUNC(spectrumAttachmentLocal), 1] call CBA_fnc_addPerFrameHandler; 
	GVAR(PFH_SpectrumHUDPlayer) = [FUNC(spectrumHudStrength), 0] call CBA_fnc_addPerFrameHandler; 

	// Spectrum event handler for "FIRE" spectrum analyzer 
	GVAR(DEH_spectrumMouseDown) = ["MouseButtonDown", {_this call FUNC(spectrumDeviceMouseDown)}] call CBA_fnc_addDisplayHandler;
	GVAR(DEH_spectrumMouseUp) = ["MouseButtonUp", {_this call FUNC(spectrumDeviceMouseUp)}] call CBA_fnc_addDisplayHandler;

} else { 
	// else if false, disable handlers
	[GVAR(PFH_beaconPlayer)] call CBA_fnc_removePerFrameHandler;
	[GVAR(PFH_SpectrumAttachmentPlayer)] call CBA_fnc_removePerFrameHandler;
	
	["MouseButtonDown", GVAR(DEH_spectrumMouseDown)] call CBA_fnc_removeDisplayHandler;
	["MouseButtonUp", GVAR(DEH_spectrumMouseUp)] call CBA_fnc_removeDisplayHandler;

	{missionNamespace setVariable _x} forEach [
		["#EM_FMin",0], 					// Minimum of frequency in MHz
		["#EM_FMax",0],						// Maximum of frequency in MHz
		["#EM_SMin",-100],					// Minimum of signal value, in RSSI -100 to 0, with 0 being the strongest
		["#EM_SMax",0],						// Maximum of signal value, in RSSI
		["#EM_SelMin",0],				// currently selected frequency band that you scroll back and forth
		["#EM_SelMax",0],				// currently selected frequency band that you scroll back and forth
		["#EM_Values",[]],					// signal values in array
		["#EM_Transmit",false],				// boolean if you are transmitting, Affects the background of the graph and the icon on the device.
		["#EM_Progress",0]					// progress of transmission, between 0 and 1
	];
};
