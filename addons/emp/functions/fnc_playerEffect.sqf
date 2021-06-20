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
_wave setParticleRandom [0,[0.45,0.45,0],[0.235,0.235,0],0,0.35,[0,0,0,0.1],0,0];
_wave setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d",1,0,1], "", "Billboard", 1, 0.5, [0, 0, 0], [0, 0, 0],0,12,7.9,0, [30,1000], [[1, 1, 1, 1], [1, 1, 1, 1]], [0.08], 1, 0, "", "", _empObj];
_wave setDropInterval 0.12;
// cleanup 
[_wave] spawn {private _obj = _this select 0;sleep 1;deleteVehicle _obj};

// create the boom effect
private _explosion = "#particlesource" createVehicleLocal getposatl _empObj;
_explosion setParticleCircle [0, [0, 0, 0]];
_explosion setParticleRandom [0, [0, 0, 0], [0, 0, 0], 0, 0, [0, 0, 0, 0], 0, 0];
// sphereModel for 3D explosion
_explosion setParticleParams [["\A3\data_f\koule", 1, 0, 1], "", "SpaceObject", 1,1.5,[0,0,0],[0,0,1],3,12,7.9,0,[60,1000],[[1, 1, 1, 0.1], [1, 1, 1, 0]], [1], 1, 0, "", "", _empObj];
_explosion setDropInterval 65;
// cleanup
[_explosion] spawn {private _obj = _this select 0;sleep 1;deleteVehicle _obj};

// emp colour - Set 0 brightness then turn it up as effect
private _empEffect = "#lightpoint" createVehiclelocal getposatl _empObj; 
_empEffect lightAttachObject [_empObj, [0,0,3]];
_empEffect setLightAmbient [1,1,1];  
_empEffect setLightColor [1,1,1];
_empEffect setLightBrightness 0;
_empEffect setLightDayLight true; // can be used in daytime
// set the falloff over light over distance
_empEffect setLightAttenuation [12,7,50,0,60,2500];

// turn up the brightness over time 
private _brightness = 0;
private _range_illuminated = 0;
while {_brightness < 65} do {
	_empEffect setLightBrightness _brightness;
	ADD(_brightness,2.5);
	sleep 0.1;
};
deleteVehicle _empEffect;


// todo this should only happen if within range of emp as player.


// then it triggers the white-out for the player
sleep 0.8;
cutText ["", "WHITE OUT", 0.5];
sleep 0.1;
titleCut ["", "WHITE IN", 0.5];

// play Tinitus sound
playsound "tinitus";

// blue a bit, then slightly less, then none to simulate getting hit effect
"dynamicBlur" ppEffectEnable true;   
"dynamicBlur" ppEffectAdjust [7];   
"dynamicBlur" ppEffectCommit 0.5;     
sleep 0.5;
"dynamicBlur" ppEffectAdjust [2];
"dynamicBlur" ppEffectCommit 1.5;  
sleep 6.5;
"dynamicBlur" ppEffectAdjust [0];
"dynamicBlur" ppEffectCommit 5;
sleep 8;
"dynamicBlur" ppEffectEnable false; 