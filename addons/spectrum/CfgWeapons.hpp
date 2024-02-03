 class CBA_Extended_EventHandlers_base;
 
 class CfgWeapons {
	class CBA_MiscItem_ItemInfo;
	class muzzle_antenna_base_01_F;
	class muzzle_antenna_01_f: muzzle_antenna_base_01_F
	{
		author = "Bohemia Interactive";
		_generalMacro = "muzzle_antenna_01_f";
		scope = PUBLIC;
		displayName = "SD Military Antenna (30-389 MHz)";
		picture = "\a3\Weapons_F_Enoch\Pistols\ESD_01\data\ui\gear_muzzle_antenna_01_ca.paa";
		model = "\a3\Weapons_F_Enoch\Pistols\ESD_01\muzzle_antenna_01_F";
		class EM
		{
			antenna = "Antenna_01";
		};
	};
	// class muzzle_antenna_02_f: muzzle_antenna_base_01_F
	// {
	// 	author = "Bohemia Interactive";
	// 	_generalMacro = "muzzle_antenna_02_f";
	// 	scope = 2;
	// 	displayName = "SD Experimental Antenna (390-500 MHz)";
	// 	picture = "\a3\Weapons_F_Enoch\Pistols\ESD_01\data\ui\gear_muzzle_antenna_02_ca.paa";
	// 	model = "\a3\Weapons_F_Enoch\Pistols\ESD_01\muzzle_antenna_02_F";
	// 	class EM
	// 	{
	// 		antenna = "Antenna_02";
	// 	};
	// };
	class muzzle_antenna_03_f: muzzle_antenna_base_01_F
	{
		author = "Bohemia Interactive";
		_generalMacro = "muzzle_antenna_03_f";
		scope = PUBLIC;
		displayName = "SD Jammer Antenna (433-440 MHz)";
		picture = "\a3\Weapons_F_Enoch\Pistols\ESD_01\data\ui\gear_muzzle_antenna_03_ca.paa";
		model = "\a3\Weapons_F_Enoch\Pistols\ESD_01\muzzle_antenna_03_F";
		class EM
		{
			antenna = "Antenna_03";
		};
	};
	// TFAR radio for listening to TFAR traffic 
	// credit to TFAR for base-class and dialog asset. Uses the TFAR dialog/model: https://github.com/michail-nikolaev/task-force-arma-3-radio/blob/master/addons/handhelds/anprc148jem/CfgWeapons.hpp
	class CBA_MiscItem;
	class CBA_MiscItem_ItemInfo;
	class crowsew_tfar_icom: CBA_MiscItem {
		author = "Crowdedlight";
		displayName = "Icom";
		descriptionShort = "Radio used together with Spectrum Device to listen to tracked TFAR signals";
		scope = PUBLIC;
		scopeCurator = PUBLIC;
		model = "\a3\Weapons_F\Ammo\mag_radio.p3d";
		picture = "\A3\Weapons_F\Data\UI\gear_item_radio_ca.paa";
		tf_prototype = 1;
		tf_range = 5000;
		tf_dialog = "anprc148jem_radio_dialog";
		tf_encryptionCode = "crowsEW_icom_code";
		tf_dialogUpdate = "call TFAR_fnc_updateSWDialogToChannel;";
		tf_subtype = "digital";
		tf_parent = "crowsew_tfar_icom";
		tf_additional_channel = 0;
		crowsEW_icom = 1;
		class ItemInfo: CBA_MiscItem_ItemInfo {
			mass = 2;
		};
	};
	TF_RADIO_IDS(crowsew_tfar_icom,Icom)

	// C-TRACK
	class crowsew_ctrack: CBA_MiscItem {
		author = "Crowdedlight";
		displayName = "C-TRACK (3km)";
		descriptionShort = "Tracking device that can be put on objects to make them trackable with spectrum device";
		scope = PUBLIC;
		scopeCurator = PUBLIC;
		model = QPATHTOF(data\c_track\c_track.p3d);
		picture = QPATHTOF(data\c_track\ctrack_picture_ca.paa);
		icon = QPATHTOF(data\c_track\ctrack_icon_ca.paa);
		class ItemInfo: CBA_MiscItem_ItemInfo {
			mass = 11; //0.5kg From formular: (_mass * 0.1 * (1/2.2046) * 100) / 100)
		};
		ACE_Attachable = "crowsew_ctrack_effect_3km";
		ace_attach_orientation[] = {0,180}; // roll, yaw
		class EventHandlers {
            class CBA_Extended_EventHandlers: CBA_Extended_EventHandlers_base {};
        };
	};
	// TODO when first iteration works, make a few versions that has different ranges. Just reuse the 3D model. Something like 0.5km, 2k, 5k ?
 };

// private _itemClassname = "crowsew_ctrack";
// diag_log (getText (configFile >> "CfgWeapons" >> _itemClassname >> "ACE_Attachable"));
// private _itemVehClass = "crowsew_ctrack";
// diag_log (getText (configFile >> "CfgAmmo" >> _itemVehClass >> "model"));
// diag_log (getText (configFile >> "CfgVehicles" >> _itemVehClass >> "model"));