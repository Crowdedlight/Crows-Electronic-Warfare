#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_refreshSoundArray.sqf.sqf

Rebuilds the arrays for zeus for the sounds in our sound-hashmap. Called when loaded or if sounds has been added dynamically

*///////////////////////////////////////////////

// Create array for zeus view once. Takes minimal more memoary but removes the need to iterate static data multiple times in runtime
private _sortArr = [];
{
	// push back [key, displayname]
	_sortArr pushBack [_x, (_y select 2)];
} forEach GVAR(soundAttributes);

// sort array
// _sortArr sort true;
_sortArr = [_sortArr, [], {_x select 1}, "ASCEND"] call BIS_fnc_sortBy;

// now we gotta split it into display names and keys, which is annoying, but gotta loop it again...
GVAR(soundZeusDisplayKeys) = [];
GVAR(soundZeusDisplay) = [];
{
	GVAR(soundZeusDisplayKeys) pushBack (_x select 0);
	GVAR(soundZeusDisplay) pushBack (_x select 1);
} forEach _sortArr;