#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_unitRemoveItems.sqf
Parameters: _unit
Return: none

Removes electronic items from unit

*///////////////////////////////////////////////
params ["_unit", "_scopeMode", "_binoMode"];

///////////// changed to get unit loadout, and then remove items we find that is in the slots and inherits from base classes
private _loadout = getUnitLoadout _unit;
private _mainWep = _loadout select 0;
private _secWep = _loadout select 1;
private _pistol = _loadout select 2;
private _itemsBino = _loadout select 8;
private _itemsAssigned = _loadout select 9;

// main weapon pointer
private _pointer = _mainWep select 2;
_unit removePrimaryWeaponItem _pointer;

// handgun pointer
_pointer = _pistol select 2;
_unit removeHandgunItem _pointer;

// remove if spectrum analyzer is equipped, we can't "stop it" from working on a per-analyzer basis
private _handgun = handgunWeapon _unit;
if (("hgun_esd_" in _handgun)) then {
    _unit removeWeaponGlobal _handgun;
}; 

// if scopemode is 0, we don't remove, if its 1 or 2, we remove and/or replace
if (_scopeMode != 0) then {
    // main-gun SCOPE - Remove if we got intergrated NV / Thermal scopes
    private _scope = _mainWep select 3;
    // get the configs for the scope to check for thermal or NVG. This way we don't have to hardcode list of items
    private _opticsModes = ("true" configClasses (ConfigFile >> "CfgWeapons" >> _scope >> "ItemInfo" >> "OpticsModes")) apply {
        private _visionMode = getArray (_x >> "visionMode");
        [
            "NVG" in _visionMode, //Integrated NVG
            "Ti" in _visionMode //Integrated Thermal
        ]
    };
    // check all vision modes and if NVG or TI intergrated we replace it, as we can't turn off only the TI/NVG
    {
        _x params ["_integratedNVG", "_integratedTi"];
        if (_integratedNVG || _integratedTi) then {
            // remove scope, and replace by aim-point
            _unit removePrimaryWeaponItem _scope;

            // if option is set, replace with base-game item aimpoint scope
            if (_scopeMode == 1) then {_unit addWeaponItem [(_mainWep select 0), "optic_Aco", true];};
        };
    } forEach _opticsModes;
};

// BINO - replace if chosen with basegame binoculars. As pretty much all other items would be electronic
if (_binoMode != 0) then {
    _unit unlinkItem (_itemsBino select 0);
    _unit removeItems (_itemsBino select 0);
    
    // add base game binoculars - if chosen 
    if (_binoMode == 1) then {_unit linkItem "Binocular";};
};

// ASSIGNED ITEMS - Also remove same variants in inventory, but doesn't check for parent type
// GPS
_unit unlinkItem (_itemsAssigned select 1);
_unit removeItems (_itemsAssigned select 1);
// watch - replace with analog, just because ;-) 
_unit unlinkItem (_itemsAssigned select 4);
_unit removeItems (_itemsAssigned select 4);
_unit linkItem "itemWatch";
// Night Vision Goggles - Remove 
_unit unlinkItem (_itemsAssigned select 5);
_unit removeItems (_itemsAssigned select 5);

// remove if electronic helmet
if (headgear _unit in GVAR(electronicHelmets)) then {removeHeadgear _unit};

// remove if launcher is electronic
if (secondaryWeapon _unit in GVAR(electronicLaunchers)) then {_unit removeWeaponGlobal (secondaryWeapon _unit)};

// some items for backpack we should remove too 
{
	_unit removeItems _x;
} forEach ["TFAR_microdagr","MineDetector", "ACE_ATragMX", "ACE_Cellphone", "ACE_DAGR","ACE_HuntIR_monitor","ACE_Kestrel4500","ACE_Flashlight_KSF1","ACE_Flashlight_XL50",
			"ACE_M26_Clacker","ACE_Clacker","ACE_IR_Strobe_Item","ACE_Flashlight_MX991","ACE_DeadManSwitch","ACE_microDAGR","itc_land_tablet_fdc","itc_land_tablet_rover","UMI_Land_Camcorder_F",
			"UMI_Land_Camera_F","UMI_Land_MobilePhone_F","UMI_Land_Tablet_F"];

// TFAR disable SW radios
private _arr = (_unit call TFAR_fnc_radiosList);
{
    [_x, false] call TFAR_fnc_radioOn; //beta-specific functionality. 
} forEach _arr;

// TFAR disable LR radios
private _lrList = (_unit call TFAR_fnc_lrRadiosList);
{
	[_x, false] call TFAR_fnc_radioOn; //beta-specific functionality. 
} forEach _lrList;


// TODO future, disable ACRE radios... Should check if ACRE is loaded and then disable
