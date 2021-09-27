#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_targetSparkSFX.sqf
Parameters: pos, _unit
Return: none

Creates the visual effect for people or vehicles that get equipment destroyed
Credit to ALIAS for the initial base template of the particle effect: https://www.youtube.com/user/aliascartoons/videos

*///////////////////////////////////////////////
params ["_unit"];

// only on players
if (!hasInterface) exitWith {};

// get the bounding box
private _boundBox = boundingBoxReal vehicle _unit;
private _point1 = _boundBox select 0;
private _point2 = _boundBox select 1;

// get the details of width, length and height
private _width = abs ((_point2 select 0) - (_point1 select 0));
private _length = abs ((_point2 select 1) - (_point1 select 1));
private _height = abs ((_point2 select 2) - (_point1 select 2));

// if unit set the size accordingly
if (_unit isKindOf "man") then {
	private _spark = "#particlesource" createVehicleLocal (getPos _unit);
	_spark setParticleCircle [0,[0,0,0]];
	// set dimensions to object
	_spark setParticleRandom [0.2,[_width/3,_length/3,_height],[0,0,0],0,0.001,[0,0,0,1],1,0];
	_spark setParticleParams [["\A3\data_f\blesk1",1,0,1],"","SpaceObject",1.5,0.2,[0,0,0],[0,0,0],0,10,7.9,0,[0.002,0.002],[[1,1,0.1,1],[1,1,1,1]],[0.08], 1, 0, "", "", _unit];
	_spark setDropInterval 0.05;
	[_spark] spawn {params ["_obj"];sleep 1;deleteVehicle _obj};
};

if (_unit isKindOf "LandVehicle") then {
	private _spark = "#particlesource" createVehicleLocal (getPos _unit);
	_spark setParticleCircle [_width-0.5,[0,0,0]];
	_spark setParticleRandom [0.2,[0.2,0.2,_height/2-0.5],[0,0,0],0,0.02,[0,0,0,1],1,0];
	_spark setParticleParams [["\A3\data_f\blesk1",1,0,1],"","SpaceObject",1,0.2,[0,0,0],[0,0,0],0,10,7.9,0,[0.003,0.003],[[1,1,0.1,1],[1,1,1,1]],[0.08], 1, 0, "", "", _unit];
	_spark setDropInterval 0.05;
	[_spark] spawn {params ["_obj"];sleep 1;deleteVehicle _obj};
};
