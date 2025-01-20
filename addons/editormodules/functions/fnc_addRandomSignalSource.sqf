#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_addRandomSignalSource.sqf.sqf

module to set object as Spectrum signal source

*///////////////////////////////////////////////

// Argument 0 is module logic.
_logic = param [0,objNull,[objNull]];

// Argument 1 is list of affected units (affected by value selected in the 'class Units' argument))
_units = param [1,[],[[]]];

// True when the module was activated, false when it is deactivated (i.e., synced triggers are no longer active)
_activated = param [2,true,[true]];

if (count _units < 1) exitWith {
	[QEGVAR(zeus,showHintZeus), ["STR_CROWSEW_Editormodules_addsignal_error"]] call CBA_fnc_globalEvent;
};

// Module specific behavior. Function can extract arguments from logic and use them.
if (_activated) then {
	// Attribute values are saved in module's object space under their class names
	private _freqMin = _logic getVariable ["FrequencyMin",0];
	private _freqMax = _logic getVariable ["FrequencyMax",0];
	private _rangeMin = _logic getVariable ["RangeMin",0];
	private _rangeMax = _logic getVariable ["RangeMax",0];
	private _applyToClass = _logic getVariable ["Classname",false];

	//get random value
	private _freqMid = round(((_freqMax - _freqMin)/2) + _freqMin);
	private _rangeMid = round(((_rangeMax - _rangeMin)/2) + _rangeMin);

	// get random freq and range within range 
	private _freq = floor(random[_freqMin, _freqMid, _freqMax]);
	private _range = floor(random[_rangeMin, _rangeMid, _rangeMax]);

	// call function directly as this is only executed on the server
	{
		[_x, _freq, _range, "zeus"] call EFUNC(spectrum,addBeaconServer);
	} forEach _units;
};
// Module function is executed by spawn command, so returned value is not necessary, but it is good practice.
true;
