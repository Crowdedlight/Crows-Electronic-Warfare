# Get Started
If you are interested in helping contribute to this addon here is a small rundown of how to use hemtt and get started

# Structure
The mod is structured where each folder under ``addons`` is a "component". When building the mod it means that each folder will be its own ``.pbo``. I have tried to structure the mod so it logically is split between functionalty like so:

- editormodules => all the modules available in the eden editor
- emp => handles the EMP and its functionality
- main => is the jammers (radio/drone) and satcom boosters
- sounds => has the functionality for the ``playSound`` and ``addSound`` modules, that allow to play sound effects
- spectrum => has all the spectrum device handling
- zeus => Has all the zeus modules. Just like the editormodules it acts as an interface for zeus, to use the functionality of the other pbos. 

For features like the radio/drone jammers and spectrum devices it runs with a "server authority" archetecture. So the server will always have the latest truth of data, and all clients will ask or get updates pushed from the server. That means that if a zeus is adding a new jammer, the communication would be:
Zeus module -> ask server to make new jammer -> server creates jammer and pushes updates out to all clients -> zeus and everyone receives the update from the server. 
So the Zeus client actually does not know the new jammer they asked to make, until they receive the update from the server containing the new jammer. 

# Building
The addon uses hemtt to build. (<3 to Brett for making hemtt!)  
So start off by downloading hemtt, either downloading the binary for you platform here: https://github.com/BrettMayson/HEMTT/releases, or if on windows, you can use win-get to install it globally.   
## Binary
If you downloaded the binary place it in your path, or simply just copy paste it into the root of this github repo and run ``./hemtt.exe build``
## winget
Install with ``winget install hemtt`` and run: ``hemtt build`` 

# Launching game with filepatching
Launching the mod with filepatching means that you do not need to close the game, then rebuild the mod and launch it again for changes to appear. But you can just simply restart the mission ingame, and the changes will appear. 

```admonish warning
Some changes like config changes, or new files require a game-restart to be registered. But changes in known sqf files will work. 
```

Hemtt (<3) makes it easy to launch the game with filepatching. It is actually just a single command. HOWEVER due to using CBA caching, a few things are needed in the mod before it will work. 

1. To enable filepatching to work in a addon, you need to uncomment a line in the ``script_component.hpp`` to disable the caching mode

As an example, if I wanted to work on the ``spectrum`` part, then I would change ``addons/spectrum/script_component.hpp`` from:
```cpp
// #define DISABLE_COMPILE_CACHE
```
to 
```cpp
#define DISABLE_COMPILE_CACHE
```

That means that it will not cache anything under the ``spectrum`` folder. As it stands right now you need to make this change on each "pbo" folder you wish to work in. 

```admonish info
When commiting a pull-request, make sure it is commited out again, so the caching is applied for the released version. 
```

2. To then launch the game with filepatching we use the ``hemtt launch`` command. This mod have a few launch options available depending on the need:

- "default" => default debug launch with TFAR, Advanced Developer Tools and intercept and arma-debug-engine. (Might not always work). Handy if you want to debug or profile stuff
- "nodebug" => What i typically use, same as default, just without debug engine and intercept.
- "acre" => For testing features with ACRE, same as nodebug, just with ACRE instead of TFAR

The launch command will launch your game directly into the test-mission that is setup to easily and quick be able to test multiple features in this mod. 

# Macros
This mod uses the CBA/ACE3 macros, which can be confusing if you are not used to it. The most used macros are likely ``GVAR``, ``EGVAR``, ``QGVAR``, ``FUNC``, ``EFUNC``. They make it easy to ensure correct naming are used for public/global variables and they all contain both the tag and component.   

So using ``GVAR(myvar)`` in the ``spectrum``component would get translated to ``crowsew_spectrum_myvar``. Where ``crowsew`` is this mods tag, and ``spectrum`` is the component you are in. 

There is then the versions ``EGVAR(component,myvar)``, which takes 2 arguments. So if I am in the ``spectrum`` component, but need to reference a global variable from the ``main`` component, I could do: ``EGVAR(main,myvar)`` which would be translated to: ``crowsew_main_myvar``.   

``QGVAR()`` is used if you need to get the variable in quotes, so as a string instead of a variable. Typically used for ``setVariable``/``getVariable`` or CBA Events naming.   
``QGVAR(myvar)`` inside the ``spectrum`` component would translate to ``"crowsew_spectrum_myvar"``. 

``FUNC`` is the same as ``GVAR`` just for functions. So ``FUNC(helloworld)`` in the ``spectrum`` component would translate to ``crowsew_spectrum_fnc_helloworld``.

There is a bunch of other macros available. You can read about them on ACEs wiki here: https://ace3.acemod.org/wiki/development/coding-guidelines#2-macro-usage 

# Adding new functions
To add a new function in a component, you make the new file in the component choices ``functions`` folder. Each function requires to have this start:
```cpp
#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: <insert author>
			   
File: fnc_<filename>.sqf
Parameters: 
Return: 

<short description>

*///////////////////////////////////////////////
```
Make sure to fill out author, filename, and a short description

Before the function will work ingame, you need to add it to the ``XEH_PREP.hpp`` file under the component you added it. If I added a file called ``fnc_halloworld.sqf`` under ``spectrum`` component then I would need to add this to the ``XEH_PREP.hpp`` file:
```cpp
PREP(halloworld);
```

Then ingame or from another script, you could call your function with:
```cpp
// calling from same component
[] call FUNC(halloworld);

// from another component
[] call EFUNC(spectrum,halloworld);
```

# XEH Eventhandlers
Each component have a bunch of XEH eventhandler files, that is used for various purposes. You can read a bit more about the XEH eventhandlers here: https://github.com/CBATeam/CBA_A3/wiki/Advanced-XEH and https://community.bistudio.com/wiki/Initialisation_Order 

But in general its used as this:

**XEH_postInit**
Will run after init has been called on the individual player/unit. Typically used for:
- Starting Per-Frame-Handlers
- Adding eventhandlers
- Call any events required on initialization

**XEH_preInit**
This is called before init on player/unit/object. Typically used for:
- CBA addon settings
- CBA Keybind settings
- Initializing gvars needed during execution

By having CBA settings and keybinds here, they will also be available for players to change from the main-menu. If you had them in ``postInit`` instead, it would require to in a server or playing in editor for the settings to appear. 

**XEH_PreStart**
To my understanding this would be run while players are still in the lobby, and before they actually spawn in the game. I am not really using this. 

# CBA Functions/Events
The mod uses a bunch of CBA functions and events. You can check what they do at: https://cbateam.github.io/CBA_A3/docs/index/Functions.html 

The CBA Events is a great way to do communication across clients and server. It is easier to work with than ``remoteExec`` and should perform better. You need to register eventhandlers on the clients you want to handle events, and then you can raise events for everyone, the server, or a specific player as required. 


# Git flow
This mod uses a fairly standard gitflow. New branches for features or bugfixes with PR's against ``main``. Main will always have the latest develop version, with the latest released version being a tag on ``main``. 

Before making a PR make sure you have done a ``git pull --rebase origin main`` to ensure you are working off the latest changes on main. 