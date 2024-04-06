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
    private _rxInterference = player getVariable["acre_receive_interference", 0];

	// naive approach? Does it work? "how well"?
	// -------
	// _Px: power as a percentage (0-1). This value is what will be used by the TeamSpeak 3 plugin to adjust the audio of the player being heard on the radio.
	// _maxStrength: The decibel signal strength value (dBm). A typical value that is heard is between 0 to about -110 (radio specific). Lower values are not heard.
	// _Px = _Px * _rxInterference;
    _maxSignal = _maxSignal - _rxInterference;

    // ensure _maxSignal does not get too low
    _maxSignal = _maxSignal max -110;

    // only degrade signal if having a positive receive_interference. As negative recieve_interference means the signal is boosted
    if (_rxInterference > 0) then {
        private _percentage = _rxInterference / 110;
        _Px = _Px - _percentage;
    };

    // Return final signal
    [_Px, _maxSignal]
}] call acre_api_fnc_setCustomSignalFunc;
