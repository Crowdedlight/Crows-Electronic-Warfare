class CBA_Extended_EventHandlers_base;

class CfgVehicles {
    class Thing;
    class ThingX;

    // The object that gets attached in ace, this way we can show and run the functions needed?
    class crowsew_ctrack_effect: ThingX {
        scope = HIDDEN;
        displayName = "C-TRACK";
        model = QPATHTOF(data\c_track\c_track.p3d);
        vehicleClass = "";

        class EventHandlers {
            class CBA_Extended_EventHandlers: CBA_Extended_EventHandlers_base {};
        };
    };
    class crowsew_ctrack_effect_3km : crowsew_ctrack_effect {
        range = 3000;
    };

    class crowsew_cmotionObj: ThingX {
        scope = HIDDEN;
        displayName = "C-MOTION";
        model = QPATHTOF(data\c_track\c_track.p3d);
        vehicleClass = "";

        class EventHandlers {
            class CBA_Extended_EventHandlers: CBA_Extended_EventHandlers_base {};
        };
    };


    class Man;
    class CAManBase: Man
    {
        class ACE_SelfActions
        {
            class ACE_Equipment
            {
                class crowsew_placeCmotion
                {
                    displayName="Place C-MOTION";
                    condition="'crowsew_cmotion' in (items ACE_player)";
                    exceptions[]=
                    {
                        "onMap",
                        "isHandcuffed",
                        "isSurrendering",
                        "isSwimming",
                        "isOnLadder"
                    };

                    statement=QUOTE(call FUNC(cmotionDialog););
                    icon=QPATHTOF(data\c_motion\cmotion_icon_ca.paa);
                    showDisabled=0;
                    // priority=2.5;
                };
            };
        };
    };
};

