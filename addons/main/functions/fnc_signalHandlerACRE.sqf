#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_signalHandlerACRE.sqf
Parameters: none
Return: none

If ACRE is loaded we need to register custom function that handles applying interference to signal calculation

*///////////////////////////////////////////////

[{
    // ACRE signal processing
    private _coreSignal = _this call acre_sys_signal_fnc_getSignalCore;
    _coreSignal params ["_Px", "_maxSignal"];

    // Modify signal (eg. zero-out if in jam area)
    private _rxInterference = player getVariable["acre_receive_power", 1];
    private _txInterference = player getVariable["acre_send_power", 1];

	// naive approach? Does it work? "how well"?
	// -------
	// _Px: power as a percentage (0-1). This value is what will be used by the TeamSpeak 3 plugin to adjust the audio of the player being heard on the radio.
	// _maxStrength: The decibel signal strength value (dBm). A typical value that is heard is between 0 to about -110 (radio specific). Lower values are not heard.
	_Px = _Px * _rxInterference;
	_maxSignal = _maxSignal * _txInterference;

    // Return final signal
    [_Px, _maxSignal]
}] call acre_api_fnc_setCustomSignalFunc;
