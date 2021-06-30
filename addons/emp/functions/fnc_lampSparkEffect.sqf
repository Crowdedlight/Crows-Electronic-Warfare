#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_lampSparkEffect.sqf
Parameters: _unit, delay
Return: none

makes the effect for sparks on lamps and turrets 

Credit to ALIAS for the initial base template of the particle effect: https://www.youtube.com/user/aliascartoons/videos

*///////////////////////////////////////////////
params ["_unit", "_delay"];

// only for players
if (!hasInterface) exitWith {};

// get bounding box
private _boundBox = boundingBoxReal vehicle _unit;
private _point1 = _boundBox select 0;
private _point2 = _boundBox select 1;

// max height
private _maxHeight = abs ((_point2 select 2) - (_point1 select 2));

private _spark_pos_relative = (_maxHeight/2)-0.45;

private _spark_sound = ["spark1","spark2","spark3"] call BIS_fnc_selectRandom;
private _spark_type = ["white","orange"] call BIS_fnc_selectRandom;

private _drop = 0.003+(random 0.05);
private _sparkSource = "#particlesource" createVehicleLocal (getPosATL _unit);

// general settings 
_sparkSource setParticleCircle [0, [0, 0, 0]];

// colour specific
if (_spark_type=="orange") then 
{
	_sparkSource setParticleRandom [1, [0.1, 0.1, 0.1], [0, 0, 0], 0, 0.25, [0, 0, 0, 0], 0, 0];
	_sparkSource setParticleParams [["\A3\data_f\proxies\muzzle_flash\muzzle_flash_silencer.p3d", 1, 0, 1], "", "SpaceObject", 1, 1, [0, 0,_spark_pos_relative], [0, 0, 0], 0, 15, 7.9, 0, [0.5,0.5,0.05], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 0]], [0.08], 1, 0, "", "", _unit,0,true,0.3,[[0,0,0,0]]];
	_sparkSource setDropInterval _drop;
} else	{
	_sparkSource setParticleRandom [1, [0.05, 0.05, 0.1], [5, 5, 3], 0, 0.0025, [0, 0, 0, 0], 0, 0];
	_sparkSource setParticleParams [["\A3\data_f\proxies\muzzle_flash\muzzle_flash_silencer.p3d", 1, 0, 1], "", "SpaceObject", 1, 1, [0, 0,_spark_pos_relative], [0, 0, 0], 0, 20, 7.9, 0, [0.5,0.5,0.05], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 0]], [0.08], 1, 0, "", "", _unit,0,true,0.3,[[0,0,0,0]]];
	_sparkSource setDropInterval 0.001;	
};

// sound and cleanup
_unit say3D [_spark_sound, 350];
sleep _delay;
deleteVehicle _sparkSource;
