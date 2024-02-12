# TFAR Tracking activated by script
If you want to enable/disable TFAR tracking by script, you can do it with the following code:
```cpp
["crowsEW_spectrum_toggleRadioTracking", [true]] call CBA_fnc_globalEventJIP;
```
And changing ``true`` to ``false`` will disable it again.
```cpp
["crowsEW_spectrum_toggleRadioTracking", [false]] call CBA_fnc_globalEventJIP;
```
