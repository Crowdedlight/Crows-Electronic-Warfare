#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_getListZenOwnersSelection.sqf
Parameters: _selection
Return: none

Zeus dialog to add sound to object

*///////////////////////////////////////////////
params [["_selection", []]];

private _selectArray = [];
//find selection check what array is not empty or if all are empty 
//dialog returns: [[WEST],[],[],0]] or [[CIV],[C Alpha 1-1],[PZA],0]

//If SIDE is selected
if (count (_selection select 0) > 0) then
{
	//units works both with group and sides
	{
		_selectArray append (units _x);
	} forEach (_selection select 0);
};
//if GROUP is selected
if (count (_selection select 1) > 0) then
{
	//units works both with group and sides
	{
		_selectArray append (units _x);
	} forEach (_selection select 1);
};
//if Players is selected
if (count (_selection select 2) > 0) then
{
	//get array of players, should just be able to pass _selection on
	_selectArray append (_selection select 2);
};

// remove duplicates
_selectArray = _selectArray arrayIntersect _selectArray;

_selectArray