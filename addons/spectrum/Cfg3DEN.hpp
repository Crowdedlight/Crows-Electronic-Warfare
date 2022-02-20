// WORK IN PROGRESS - IDEA was to add options to objects and units to make them spawn with a signal source. 

// Include Eden Editor UI macros
// For attributes, you'll be interested in these:
// ATTRIBUTE_TITLE_W - title width
// ATTRIBUTE_CONTENT_W - content width
#include "\a3\3DEN\UI\macros.inc"

//inherit base-class
class ctrlSliderH;

class Cfg3DEN
{
	// Configuration of all objects
	class Object
	{
		// Categories collapsible in "Edit Attributes" window
		class AttributeCategories
		{
			// Category class, can be anything
			class Spectrum Signal
			{
				displayName = "Spectrum Signal Init"; // Category name visible in Edit Attributes window
				collapsed = 1; // When 1, the category is collapsed by default
				class Attributes
				{
					class Default; // Empty template with pre-defined width and single line height
					class Title: Default
					{
						class Controls
						{
							class Title;
						};
					}; // Two-column template with title on the left and space for content on the right
					class TitleWide: Default
					{
						class Controls
						{
							class Title;
						};
					}; // Template with full-width single line title and space for content below it

					// Your attribute class
					class SpectrumSignalControl: Title
					{
						// Expression called when the control is loaded, used to apply the value. It is not called when multiple entities are edited at once due to the fact that _value would not be available then. See the note underneath this code block
						// Passed params are: _this - controlsGroup, _value - saved value, _config - Path to attribute config e.g.:bin\config.bin/Cfg3DEN/Object/AttributeCategories/CATEGORY/Attributes/ATTRIBUTE
						attributeLoad = "(_this controlsGroupCtrl 123) ctrlSetText _value#1; (_this controlsGroupCtrl 124) ctrlSetText _value#2;";
						// Expression called when attributes window is closed and changes confirmed. Used to save the value.
						// Passed param: _this - control
						attributeSave = QUOTE([QGVAR(addBeacon), [_this, ctrlText (_this controlsGroupCtrl 123), ctrlText (_this controlsGroupCtrl 124), "zeus"]] call CBA_fnc_globalEventJIP;[ctrlText (_this controlsGroupCtrl 123), ctrlText (_this controlsGroupCtrl 124)]);
						// List of controls, structure is the same as with any other controls group
						class Controls: Controls
						{
							onLoad = "_control = _this select 0;";
							class Title: Title{
								ctrlText = "Frequency";
							}; // Inherit existing title control. Text of any control with class Title will be changed to attribute displayName
							class frequency: ctrlSliderH
							{
								idc = 123;
								x = ATTRIBUTE_TITLE_W * GRID_W;
								w = ATTRIBUTE_CONTENT_W * GRID_W;
								h = SIZE_M * GRID_H;
							};
							class Title: Title{
								ctrlText = "Range";
							};
							class range: ctrlSliderH
							{
								idc = 124;
								x = ATTRIBUTE_TITLE_W * GRID_W;
								w = ATTRIBUTE_CONTENT_W * GRID_W;
								h = SIZE_M * GRID_H;
							};
						};
					};
				};
			};
		};
	};
};