#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight

File: fnc_playerEffect.sqf
Parameters: empObj
Return: none

plays the visual effect for the emp.
Credit to ALIAS for the initial base template of the particle effect: https://www.youtube.com/user/aliascartoons/videos

*///////////////////////////////////////////////
params ["_pos", "_range"];

private _player = [] call CBA_fnc_currentUnit;

// only for players
if (!hasInterface) exitWith {};

// emp sound and shake, but only if close enough
if ((_player distance _pos) < (_range*2)) then {
	playSound "crowsew_emp_blast";

	// cam shake
	enableCamShake true;
	addCamShake [6,5,24]; // shaking in 5s
};

// first it makes the EMP effect explosion
// create particle source on object pos
private _wave = "#particlesource" createVehicleLocal _pos;
// create in circel with radius
_wave setParticleCircle [0,[0,0,0]];;
// randomize effect paramters and set particle effect
_wave setParticleRandom [0,[0.20,0.20,0],[0.170,0.170,0],0,0.20,[0,0,0,0.1],0,0];
_wave setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d",1,0,1], "", "Billboard", 1, 0.8, [0, 0, 0], [0, 0, 0],0,10,7.9,0, [30,(_range*1.2)], [[1, 1, 1, 1], [1, 1, 1, 1]], [0.08], 1, 0, "", "", _wave];
_wave setDropInterval 0.1;
// cleanup
[_wave] spawn {params ["_obj"];sleep 1;deleteVehicle _obj};

// create the boom effect
private _explosion = "#particlesource" createVehicleLocal _pos;
_explosion setParticleCircle [0, [0, 0, 0]];
_explosion setParticleRandom [0, [0, 0, 0], [0, 0, 0], 0, 0, [0, 0, 0, 0], 0, 0];
// sphereModel for 3D explosion
_explosion setParticleParams [["\A3\data_f\koule", 1, 0, 1], "", "SpaceObject", 1.1,1,[0,0,0],[0,0,1],4,10,7.9,0,[50,(_range*1.2)],[[0.34, 0.72, 1, 0.1],[0.40, 0.72, 1, 0]], [1], 1, 0, "", "", _explosion];
_explosion setDropInterval 50;
// cleanup
[_explosion] spawn {params ["_obj"];sleep 1.1;deleteVehicle _obj};

// emp colour - Set 0 brightness then turn it up as effect
private _empEffect = "#lightpoint" createVehicleLocal _pos;
_empEffect setLightAmbient [0.34,0.72,1];
_empEffect setLightColor [0.34,0.72,1];
_empEffect setLightBrightness 0;
_empEffect setLightDayLight true; // can be used in daytime
// set the falloff over light over distance
_empEffect setLightAttenuation [15,8,50,0,200,2000];

// turn up the brightness over time
private _brightness = 0;
while {_brightness < 50} do {
	_empEffect setLightBrightness _brightness;
	_brightness = _brightness + 2;
	sleep 0.05;
};
sleep 0.1;
deleteVehicle _empEffect;

// player whiteout should only happen if within range of emp. If Zeus, we don't get blur effect and whiteout
if ((_player distance _pos) > _range || !isNull (getAssignedCuratorLogic _player)) exitWith {};

// get vehicle if unit is in vehicle, to check if vehicle or unit is immune to EMP
private _vehicle = vehicle _player;
// we check both vehicle and player, in the case player is not in vehicle, the player is just checked twice, thats fine.
if ((_vehicle getVariable [QGVAR(immuneEMP), false]) || (_player getVariable [QGVAR(immuneEMP), false])) exitWith {};

// then it triggers the white-out for the player
cutText ["", "WHITE OUT", 0.5];
sleep 0.1;
titleCut ["", "WHITE IN", 0.5];

// play tinnitus sound
playSound "crowsew_tinnitus";

// blue a bit, then slightly less, then none to simulate getting hit effect
"dynamicBlur" ppEffectEnable true;
"dynamicBlur" ppEffectAdjust [6];
"dynamicBlur" ppEffectCommit 0.5;
sleep 0.5;
"dynamicBlur" ppEffectAdjust [1.2];
"dynamicBlur" ppEffectCommit 1;
sleep 5;
"dynamicBlur" ppEffectAdjust [0];
"dynamicBlur" ppEffectCommit 5;
sleep 3;
"dynamicBlur" ppEffectEnable false;

// effect testing
// [_this, 500] spawn {
// params ["_empObj", "_range"];
// playSound "emp_blast";

// enableCamShake true;
// addCamShake [6,5,24];

// private _wave = "#particlesource" createVehicleLocal getposatl _empObj;
// _wave setParticleCircle [0,[0,0,0]];;
// _wave setParticleRandom [0,[0.20,0.20,0],[0.170,0.170,0],0,0.20,[0,0,0,0.1],0,0];
// _wave setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d",1,0,1], "", "Billboard", 1, 0.8, [0, 0, 0], [0, 0, 0],0,10,7.9,0, [30,(_range*1.2)], [[1, 1, 1, 1], [1, 1, 1, 1]], [0.08], 1, 0, "", "", _empObj];
// _wave setDropInterval 0.1;
// [_wave] spawn {params ["_obj"];sleep 1;deleteVehicle _obj};

// private _explosion = "#particlesource" createVehicleLocal getposatl _empObj;
// _explosion setParticleCircle [0, [0, 0, 0]];
// _explosion setParticleRandom [0, [0, 0, 0], [0, 0, 0], 0, 0, [0, 0, 0, 0], 0, 0];
// _explosion setParticleParams [
// 	["\A3\data_f\koule", 1, 0, 1],
// 	 "",
// 	  "SpaceObject",
// 	   1,
// 	   1.1,
// 	   [0,0,0],
// 	   [0,0,1]
// 	   ,4
// 	   ,10
// 	   ,7.9
// 	   ,0
// 	   ,[50,(_range*1.2)]
// 	   ,[[0.34, 0.72, 1, 0.1],[0.40, 0.72, 0.75, 0]],
// 	   [1],
// 	   1,
// 	   0,
// 	   "",
// 	   "",
// 	   _empObj];
// _explosion setDropInterval 50;
// [_explosion] spawn {params ["_obj"];sleep 1.1;deleteVehicle _obj};

// private _empEffect = "#lightpoint" createVehicleLocal getposatl _empObj;
// _empEffect lightAttachObject [_empObj, [0,0,3]];
// _empEffect setLightAmbient [0.34,0.72,1];
// _empEffect setLightColor [0.34,0.72,1];
// _empEffect setLightBrightness 0;
// _empEffect setLightDayLight true;
// _empEffect setLightAttenuation [15,8,50,0,200,2000];
// private _brightness = 0;
// while {_brightness < 50} do {
// 	_empEffect setLightBrightness _brightness;
// 	_brightness = _brightness + 2;
// 	sleep 0.05;
// };
// sleep 0.1;
// deleteVehicle _empEffect;

// cutText ["", "WHITE OUT", 0.5];
// sleep 0.1;
// titleCut ["", "WHITE IN", 0.5];
// playSound "tinnitus";
// "dynamicBlur" ppEffectEnable true;
// "dynamicBlur" ppEffectAdjust [7];
// "dynamicBlur" ppEffectCommit 0.5;
// sleep 0.5;
// "dynamicBlur" ppEffectAdjust [1.5];
// "dynamicBlur" ppEffectCommit 1.5;
// sleep 5.5;
// "dynamicBlur" ppEffectAdjust [0];
// "dynamicBlur" ppEffectCommit 5;
// sleep 5;
// "dynamicBlur" ppEffectEnable false;
// }