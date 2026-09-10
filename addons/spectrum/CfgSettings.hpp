
class CfgSettings {
    class CBA {
        class Versioning {
            class PREFIX {
                class dependencies {
                    //Warnings for LAMBS version being too low
                    LAMBS[] = {"lambs_main", {3,6,1,502}, "isClass (configFile >> 'CfgPatches' >> 'lambs_main')"};
             // TODO: add proper version here ^^^
                };
            };
        };
    };
};
