#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_addCustomSounds.sqf
Parameters: _newSounds: Array of type: [key, length, filepath, displayname]
Return: none

Called upon event, adds the sound to the list of active sounds

*///////////////////////////////////////////////

params [["_newSounds", [], [[]]]];

{
	// sound configs key: [length, filepath, displayname]
	_x params [["_key", "", [""]], ["_length", 0, [0]], ["_filepath", "", [""]], ["_displayname", "", [""]]];

	// continue if key, length or filepath is default values/incorrect
	if (_key == "" || _length == 0 || _filepath == "") then {
		
		// We errored, log it 
		diag_log format ["CrowsEW:fnc_addCustomSounds.sqf: _key, _length or _filepath is empty or 0 for: [%1,%2,%3,%4]", _key, _length, _filepath, _displayname]; 
		
		continue;
		};

	// otherwise we add it to the array
	GVAR(soundAttributes) set [_key, [_length, _filepath, _displayname]];	

} forEach _newSounds;

// refresh the sound array for zeus
[] call FUNC(refreshSoundArray); 
