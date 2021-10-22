#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_spectrumAttachmentLocal.sqf
Parameters: 
Return: 

Script being called by PFH to handle updates for frequencies depending on what attachment is used

*///////////////////////////////////////////////

// exit if spectrum analyzer is not equipped. 
private _tracker = GVAR(trackerUnit);
// safety check
if (isNull _tracker || !alive _tracker) then {_tracker = player};

if (!("hgun_esd_" in (handgunWeapon _tracker))) exitWith {}; 

private _muzzleAttachment = (handgunItems _tracker) select 0;

// don't reset vars and calculate if we have same attachment as last time, should make us only recalculate upon changes
if (GVAR(LastSpectrumMuzzleAttachment) == _muzzleAttachment) exitWith {};

// get default freq for antenna
private _resultArr = [_muzzleAttachment] call FUNC(getSpectrumDefaultFreq);
_resultArr params ["_minFreq", "_maxFreq", "_selectedAntenna"];

// set antenna equipped
GVAR(spectrumRangeAntenna) = _selectedAntenna;

// update 
GVAR(LastSpectrumMuzzleAttachment) = _muzzleAttachment;

// set local params
[_minFreq, _maxFreq, _muzzleAttachment] call FUNC(setSpectrumFreq);
