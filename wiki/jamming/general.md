# Jammers
The jammer has the ability to jam drones or jam radio communication. The individual features are described in the subsections, while settings or features they have in common is described in this section.  
The jammer can be placed on any object or unit. If placed on a position, it will spawn a data-terminal with base-game animation. Any object set as a jammer that is currently active will emit a 3D sound when players come close. Zeus can remove the sound with the `remove sound` module if wanted. It has the limitation that only the closest jammer to a player will play the 3D sound for that player. So if 2 jammers are within hearing of a player only one will play the sound

The jammer stops automatically if the object is deleted or destroyed.  
Players have the option to disable/enable the jammer with scroll-wheel action menu.

## How to set the effect radius
Both the radio and drone jammer have the same way they calculate and apply the jamming effect. The area jammer has two settings that describes two different radii: The `falloff` and `effective` radius. The `effective` radius describes the radius from the jammer object that radios or drones will be 100% jammed and completely unusuable. For drones any player operators will get disconnected, while for AI they will be halted.  
The `falloff` radius determines a radius describing the area from the edge of the `effective` radius and outwards. In this area the jamming effect will be applied linear with 0% jamming at the outer border, 50% jamming effect halfway towards the edge of `effectove` radius, and 100% jamming when reaching the `effective` radius.  

```admonish info
Due to difference in radio power, range and antenna gains, some radios like short-range might get fully jammed before reaching the `effective` radius, while stronger long-range radios won't be jammed until getting all the way there 
```

This should make it more clear and easier to apply for mission makers to get the behaviour they want. A screenshot showing it visually can be seen here:
![jammer_radius](https://github.com/Crowdedlight/Crows-Electronic-Warfare/assets/7889925/80534fc6-2d28-4646-bc9e-e82b5d4f6fc1)


## Zeus Immunity and Map Markers
Zeus will not be radio jammed, but might not be able to hear TFAR players transmitting inside jamming area, if that player is totally jammed. 
Zeus has two mapmarkers for each jammer. Outer one shows the `falloff` radius, and the inner one shows the `effective` radius. Thus zeus can see the position of all jammers and their area of effect. The markers will update if jammer is moved. If the jammer is active the `falloff`marker will be yellow and the `effective` radius will be red. 

## How to place such a jammer

```admonish info
Putting a jammer on an object already having a jammer will override the previous jammer. Each object can only have a single jammer.
```

```admonish warning
A lot of antenna objects are not destructable and as such you cannot blow them up to destroy the jammer. If you want to be able to blow up the jammer with explosives or rockets make sure to use a destructable object or the default dataterminal the module can spawn.
```

### Zeus interface
1. Go to Modules in the right panel of the Zeus interface and search for "jam"
2. Drag the `Set Jammer` module onto the map
3. Select the checkboxes for what you want to jam

![zeus-jammer-module](https://github.com/Crowdedlight/Crows-Electronic-Warfare/assets/7889925/ab501a15-83b4-4423-aa1c-04dfd2de367b)

### 3den
1. Go to Modules in the right panel of the 3den interface and search for "jam"
2. Drag the `Set Jammer` module onto the map
3. Select the checkboxes for what you want to jam

![image](https://github.com/Crowdedlight/Crows-Electronic-Warfare/assets/7889925/75bfb2f7-d3d8-4593-9748-cf67f0dffbe9)

4. Sync the object (3D model) you have chosen as the area denial jammer to the object you just placed on the map.

![image](https://github.com/Crowdedlight/Crows-Electronic-Warfare/assets/76476468/9c4cfe5a-3de6-4e34-bff3-ffaa01b6c5ef)

5. Once done you should see a blue line between the 3D model and the jammer module.

![image](https://github.com/Crowdedlight/Crows-Electronic-Warfare/assets/76476468/7b01696a-9269-434f-8577-d989005d4a0b)


## Zeus Context Actions - Toggle Jammer on/off

Zeus can toggle the jammer on and off with the ZEN right-click menu. If done on a jammer you will se a `jammer` option and in that a `Toggle On/Off` option. This makes it easy and quick for zeus to enable or disable jammers. 
![image](https://github.com/Crowdedlight/Crows-Electronic-Warfare/assets/7889925/1c0e9939-c7d5-45d0-b02f-c8c018ab6794)
