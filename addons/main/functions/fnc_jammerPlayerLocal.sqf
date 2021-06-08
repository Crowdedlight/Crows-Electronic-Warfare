#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_tfarJammingLocal.sqf
Parameters: jamObject, radius, strength
Return: none

main script that handles the jamming whenever there is at least 1 active jammer

*///////////////////////////////////////////////
params [["_jammerObject",objNull], ["_radius",500], ["_strength", 50]];

// if on server or headless, stop execution
if (!hasInterface) exitWith {};


//TODO continue from here, we are splitting functions into own files, and changing behaviour slightly in correspondance with new setup
////////////////////////////////////////////////////////////

// get the current list, or get empty if doesn't exist. Is nessecary to avoid errors of "unknown variable"
crowsZA_tfar_jamming_list = player getVariable ["crowsZA_tfar_jamming_list", []];

// set variable on object, as that is the easiest way to ensure turning on and off is equal for everyone
_jammerObject setVariable ["crowsza_tfar_jamming_enabled", true];
_jammerObject setVariable ["crowsza_tfar_jamming_radius", _radius];
_jammerObject setVariable ["crowsza_tfar_jamming_strength", _strength];

// add actions to deactive and activate jamming
crowsza_fnc_jamming_start = 
{
	params ["_target", "_caller", "_actionId", "_arguments"];
	_target setVariable ["crowsza_tfar_jamming_enabled", true];
};
crowsza_fnc_jamming_stop = 
{
	params ["_target", "_caller", "_actionId", "_arguments"];
	_target setVariable ["crowsza_tfar_jamming_enabled", false];
};
_jammerObject addAction ["<t color=""#FFFF00"">start jamming", crowsza_fnc_jamming_start, [], 7, true, true, "", "[[position _target, _radius], _this] call BIS_fnc_inTrigger && !(_target getVariable 'crowsza_tfar_jamming_enabled')"];
_jammerObject addAction ["<t color=""#FFFF00"">stop jamming", crowsza_fnc_jamming_stop, [], 7, true, true, "", "[[position _target, _radius], _this] call BIS_fnc_inTrigger && (_target getVariable 'crowsza_tfar_jamming_enabled')"];

// function to update markers, only called for zeuses
crowsza_fnc_updateJammerMarker = 
{
	params ["_jammer", "_creating"];

	// get marker name to delete and recreate 
	private _markArea = _jammer getVariable ["crowsza_tfar_jamming_mark_area", netId _jammer];
	private _markPos = _jammer getVariable ["crowsza_tfar_jamming_mark_pos", netId _jammer];
	private _markDist = _jammer getVariable ["crowsza_tfar_jamming_radius", 0];

	// delete existing marker, unless we are creating them first time
	if (!_creating) then {
		deletemarkerLocal _markArea;
		deletemarkerLocal _markPos;
	};

	_markArea = createMarkerLocal [_markArea, position _jammer];
	_markArea setMarkerShapeLocal "ELLIPSE";
	_markArea setMarkerSizeLocal [_markDist, _markDist];
	_markArea setMarkerAlphaLocal 0.5;
	
	//Position Marker
	_markPos = createMarkerLocal [_markPos, position _jammer];
	_markPos setMarkerShapeLocal "ICON";
	_markPos setMarkerTypeLocal "mil_dot";

	// save in jam vars
	_jammer setVariable ["crowsza_tfar_jamming_mark_area", _markArea];
	_jammer setVariable ["crowsza_tfar_jamming_mark_pos", _markPos];
};
crowsza_fnc_removeJammerMarker = 
{
	params ["_jammer"];
	private _markArea = _jammer getVariable ["crowsza_tfar_jamming_mark_area", netId _jammer];
	private _markPos = _jammer getVariable ["crowsza_tfar_jamming_mark_pos", netId _jammer];
	deletemarkerLocal _markArea;
	deletemarkerLocal _markPos;
};

// add function to add jammer to array, as we also want to add marker for zeus side of where the jammer is etc. 
crowsza_fnc_addJammer = 
{
	params ["_jammer"];
	crowsZA_tfar_jamming_list pushBack _jammer;

	// update player var 
	player setVariable ["crowsZA_tfar_jamming_list", crowsZA_tfar_jamming_list];

	//TODO ADD MARKERS FOR ZEUS
	[_jammer, true] call _fnc_updateJammerMarker;
};

// if script is already running, we don't start a new loop and just exit
if (player getVariable ["crowsza_tfar_jamming_loop", false]) then {
	// always pushback the current jammer as long as its alive, the jam script loop check if active and alive, and deals with removing it. 
	[_jammerObject] call crowsza_fnc_addJammer;
	exit;
} else {
	// always pushback the current jammer as long as its alive, the jam script loop check if active and alive, and deals with removing it. 
	[_jammerObject] call crowsza_fnc_addJammer;
};

// start main loop and set variable on player that its started
player setVariable ["crowsza_tfar_jamming_loop", true];
while {count crowsZA_tfar_jamming_list > 0} do {

	// check all jammers if alive, and remove those that arent. Do this first, to ensure the destruction or deactivation always works
	private _jamRemoveList = [];
	{
		// if object not alive, add to deletion list 
		if (_x == objNull || !alive _x) then {
			_jamRemoveList pushBack _x;

			// remove marker from map, if zeus 
			if (!isNull (getAssignedCuratorLogic player)) then {
				[_x] call crowsza_fnc_removeJammerMarker;
			};
		};
	} forEach crowsZA_tfar_jamming_list;

	// update list of alive jammers
	crowsZA_tfar_jamming_list = crowsZA_tfar_jamming_list - _jamRemoveList;

	//IF ZEUS, DON'T JAM...update markers, sleep and skip.
	if (!isNull (getAssignedCuratorLogic player)) then {
		// update markers 
		{
			[_x, false] call crowsza_fnc_updateJammerMarker;
		} forEach crowsZA_tfar_jamming_list;
	
		// sleep 3.0; TODO uncomment, currently commented out for testing purpose
		// continue;
	};

	// find nearest jammer within range
	private _nearestJammer = objNull;
	private _distJammer = -1;
	private _distRad = -1;
	{
		// if disabled, skip the jammer 
		private _jammingEnabled = _x getVariable ["crowsza_tfar_jamming_enabled", false];
		if (!_jammingEnabled) then {continue};

		// get current dist 
		private _dist = player distance _x;

		// get set radius - If something has gone wrong setting the variable it returns -1, and the jammer won't work then
		private _rad = _x getVariable ["crowsza_tfar_jamming_radius", -1];

		// if distance to object is bigger than radius of jammer, continue 
		if (_dist > _rad) then {continue;};

		// we are now within jammer area, if this jammer is closer than previous jammers, we save it
		if (_distJammer == -1 || _distJammer > _dist) then {
			_distJammer = _dist;
			_distRad = _rad;
			_nearestJammer = _x;
		};
	} forEach crowsZA_tfar_jamming_list;

	// if no jammer are within range, go sleep and repeat
	if (_nearestJammer == objNull) then {
		// reset values of TFAR, if they are degraded
		private _playerRX = player getVariable ["tf_receivingDistanceMultiplicator", 1];
		private _playerTX = player getVariable ["tf_sendingDistanceMultiplicator", 1];

		// rx degraded if above 1
		if (_playerRX > 1) then {
			player setVariable ["tf_receivingDistanceMultiplicator", 1];
		};
		// tx degraded if below 1
		if (_playerTX < 1) then {
			player setVariable ["tf_sendingDistanceMultiplicator", 1];
		};

		sleep 3.0; //3s
		continue; //skip jamming calcs
	};

	// we now got distance, and nearest jammer, time to calculate jamming
	private _distPercent = _distJammer / _distRad;
	private _jamStrength = _nearestJammer getVariable ["crowsza_tfar_jamming_strength", 0];
    private _rxInterference = 1;
	private _txInterference = 1;

	// for now staying with linear degradation of signal. Might make it a tad better for players than the sudden commms -> no comms exponential has
	private _rxInterference = _jamStrength - (_distPercent * _jamStrength) + 1; // recieving interference. above 1 to have any effect.
	private _txInterference = 1 / _rxInterference; //transmitting interference, below 1 to have any effect.

	// Set the TF receiving and sending distance multipliers
    player setVariable ["tf_receivingDistanceMultiplicator", _rxInterference];
	player setVariable ["tf_sendingDistanceMultiplicator", _txInterference];

	//TODO check how satcom sets the variables, are they just plainly overriding whatever I set, or are they boosting it by 4? Its fine if they are immune, but wanna know
	// they hard set the multiplier which is fine for within range, but it seems their "else" clause might break jamming, as even if you are further away they set the strength to 1, and as such overwrite our "jamming" settings
	// https://github.com/Grezvany13/ILBE-Assault-Pack-Rewrite/blob/master/y/tfw_radios/addons/rf3080/scripts/fn_distanceMultiplicator.sqf#L24 

	//Debugging loaned for now from "Jam Radios script for TFAR created by Asherion and Rebel"
	if (true) then {	
		systemChat format ["Distance: %1, Percent: %2, Interference: %3, Send Interference: %4", _distJammer,  100 * _distPercent, _rxInterference, _txInterference];
		systemChat format ["Active Jammers: %1, Closest Jammer: %2",crowsZA_tfar_jamming_list, _nearestJammer];
		//copyToClipboard (str(Format ["Distance: %1, Percent: %2, Interference: %3", _dist,  100 * _distPercent, _interference]));
	};

	// sleep 3s, should be more than enough to adjust every 5s. 
	sleep 3.0;
};

// stopping main loop 
player setVariable ["crowsza_tfar_jamming_loop", false];

// when exiting script if no jammers are active, reset tfar multipliers
player setVariable ["tf_receivingDistanceMultiplicator", 1];
player setVariable ["tf_sendingDistanceMultiplicator", 1];


//Always want it attached to an object, to be able to stop it again by destorying or removing said object. Zeus can always remove damage from the object if they want to not make it destroyable

//when placing, give option to select: side to jam, radius from object, jamming strength (distance from center where no radio can be used), jamming function, (Linear, or exponential etc), satcom override?

//add option to only jam particular side, although not sure how that handles radios you pick up from enemies. Edge case perhabs. FUTURE, requires base jam to work with multiple jammers before adding side selection to each jammer


// notes - https://forums.bohemia.net/forums/topic/203810-release-radio-jamming-script-for-task-force-radio/