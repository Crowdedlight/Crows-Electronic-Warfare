#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_playerEffect.sqf
Parameters: empObj
Return: none

plays the visual effect for the emp.
Credit to ALIAS for the initial base template of the particle effect: https://www.youtube.com/user/aliascartoons/videos

*///////////////////////////////////////////////
params ["_empObj", "_range"];

// only for players 
if (!hasInterface) exitWith {};

// cam shake
enableCamShake true;
addCamShake [2,10,24]; // shaking in 10s, see how it works?

// first it makes the EMP effect explosion 
// create particle source on object pos 
private _wave = "#particlesource" createVehicleLocal getposatl _empObj;
// create in circel with radius
_wave setParticleCircle [0,[0,0,0]];;
// randomize effect paramters and set particle effect 
_wave setParticleRandom [0,[0.20,0.20,0],[0.170,0.170,0],0,0.20,[0,0,0,0.1],0,0];
_wave setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d",1,0,1], "", "Billboard", 1, 0.65, [0, 0, 0], [0, 0, 0],0,10,7.9,0, [30,(_range*1.2)], [[1, 1, 1, 1], [1, 1, 1, 1]], [0.08], 1, 0, "", "", _empObj];
_wave setDropInterval 0.1;
// cleanup 
[_wave] spawn {params ["_obj"];sleep 1;deleteVehicle _obj};

// create the boom effect
private _explosion = "#particlesource" createVehicleLocal getposatl _empObj;
_explosion setParticleCircle [0, [0, 0, 0]];
_explosion setParticleRandom [0, [0, 0, 0], [0, 0, 0], 0, 0, [0, 0, 0, 0], 0, 0];
// sphereModel for 3D explosion
_explosion setParticleParams [["\A3\data_f\koule", 1, 0, 1], "", "SpaceObject", 1.1,1,[0,0,0],[0,0,1],4,10,7.9,0,[50,(_range*1.2)],[[0.34, 0.72, 1, 0.1],[0.40, 0.72, 1, 0]], [1], 1, 0, "", "", _empObj];
_explosion setDropInterval 50;
// cleanup
[_explosion] spawn {params ["_obj"];sleep 1;deleteVehicle _obj};

// emp colour - Set 0 brightness then turn it up as effect
private _empEffect = "#lightpoint" createVehiclelocal getposatl _empObj; 
_empEffect lightAttachObject [_empObj, [0,0,3]];
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
	sleep 0.02;
};
deleteVehicle _empEffect;

// player whiteout should only happen if within range of emp.
if ((player distance _empObj) > _range) exitWith {};

// then it triggers the white-out for the player
cutText ["", "WHITE OUT", 0.5];
sleep 0.1;
titleCut ["", "WHITE IN", 0.5];

// play tinnitus sound
playsound "tinnitus";

// blue a bit, then slightly less, then none to simulate getting hit effect
"dynamicBlur" ppEffectEnable true;   
"dynamicBlur" ppEffectAdjust [7];   
"dynamicBlur" ppEffectCommit 0.5;     
sleep 0.5;
"dynamicBlur" ppEffectAdjust [1.5];
"dynamicBlur" ppEffectCommit 1.5;  
sleep 5;
"dynamicBlur" ppEffectAdjust [0];
"dynamicBlur" ppEffectCommit 5;
sleep 3;
"dynamicBlur" ppEffectEnable false; 

// effect testing 
// [_this, 1000] spawn {
// params ["_empObj", "_range"];

// private _wave = "#particlesource" createVehicleLocal getposatl _empObj;
// _wave setParticleCircle [0,[0,0,0]];;
// _wave setParticleRandom [0,[0.20,0.20,0],[0.170,0.170,0],0,0.20,[0,0,0,0.1],0,0];
// _wave setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d",1,0,1], "", "Billboard", 1, 0.65, [0, 0, 0], [0, 0, 0],0,10,7.9,0, [30,(_range*1.2)], [[1, 1, 1, 1], [1, 1, 1, 1]], [0.08], 1, 0, "", "", _empObj];
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
// [_explosion] spawn {params ["_obj"];sleep 1;deleteVehicle _obj};

// private _empEffect = "#lightpoint" createVehiclelocal getposatl _empObj; 
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
// 	sleep 0.02;
// };
// deleteVehicle _empEffect;
// cutText ["", "WHITE OUT", 0.5];
// sleep 0.1;
// titleCut ["", "WHITE IN", 0.5];
// playsound "tinnitus";
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