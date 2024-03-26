##  Jamming Drones
Jamming of drones comes in 2 different forms.
1. using the [Spectrum Device](https://community.bistudio.com/wiki/Arma_3:_Spectrum_Device) - against individual drones
2. using an **area denial jammer** - against all drones in a specific radius

### Spectrum Device

UGV drones can be jammed with a jammer antenna. By default, all UGV vehicles will broadcast a signal between 434MHz and 440MHz. By activating the antenna on the signal with left-mouse button when there is enough signal strength the drones AI will be disabled. The signal has to be higher than -40 for jamming to be possible. As long as you keep having the jammer activated the drone will just stand still where it is and do nothing. So if you jam it and move past it, and stop the jam, the drone will continue with what it was doing before. However, if the drone already spotted you and went into combat, when you stop jamming it will still be in combat. 

```admonish info
When a drone is firing the machine gun it happens in bursts. When you apply the jamming and the AI is halted, it will still finish the round of burst fire before stopping. 
```

Video:
<iframe width="560" height="315" src="https://www.youtube.com/embed/VywVOCDEh9A?si=5_Vwq7i802DKGu72" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>


### Area denial jammer
Player controlled and autonomous drones can not operate within the effective range of the area denial jammer.
- Autonomous drones will lose their autonomous capabilities (in technical terms [disableAI "all"](https://community.bistudio.com/wiki/disableAI) is called)
  - and if being jammed for long enough will attempt to land.
- Any player that is currently controlling either the Driver or Gunner position of the drone is getting disconnected from it.

The screenshot below shows 
- the default 3D model of the area denial jammer on the left
- and the message a drone pilot will see when getting disconnected on the upper right.

![image](https://github.com/Crowdedlight/Crows-Electronic-Warfare/assets/7889925/62d3d165-e23c-4721-ab21-c6047a2bc7dc)

```admonish info
Any object can be made an area denial jammer, not just the one shown above. This can be done in both Zeus and 3den. 
```

#### Camera effect
When approaching the effective radius of an active area denial drone jammer the controlling player's camera will be incrisingly distorted (see screenshots).

![image](https://github.com/gruppe-adler/Shoot_and_Scoot.Tanoa/assets/76476468/11695009-9065-4386-9947-e441ab2c3353)

![image](https://github.com/gruppe-adler/Shoot_and_Scoot.Tanoa/assets/76476468/88962170-4999-4e16-b6f3-161f1b7bd54c)

```admonish info
The intensity of this video deterioration is dependent on 2 factors.
1. Distance between drone and jammer radius
2. Distance between drone and pilot
So the closer the pilot is to the drone the longer the video signal will be workable.
```

#### Spectral behaviour
To jam the drones the area denial jammer is working an all possible drone frequencies.
In the Spectrum Device this is visible as a very distinct spectral behaviour. Such a jammer will show a spectral peak that is "sweeping" from left to right.
![image](https://github.com/Crowdedlight/Crows-Electronic-Warfare/assets/76476468/324ce56b-e2cf-4196-a37a-f0460b16c31d)

#### How to place such a jammer
##### Zeus interface
1. Go to Modules in the right panel of the Zeus interface and search for "jam"
2. Drag the `Set Jammer` module onto the map
3. Make sure the `Jam drone signals` checkbox is checked.

![image](https://github.com/Crowdedlight/Crows-Electronic-Warfare/assets/76476468/841ccb9c-c8af-4765-8e01-2026bdd180f1)

##### 3den
1. Go to Modules in the right panel of the 3den interface and search for "jam"
2. Drag the `Set Jammer` module onto the map
3. Make sure the `Jam drone signals` checkbox is checked.

![image](https://github.com/Crowdedlight/Crows-Electronic-Warfare/assets/76476468/03531a25-4327-4656-a529-5f8c854c2a75)

4. Sync the object (3D model) you have chosen as the area denial jammer to the object you just placed on the map.

![image](https://github.com/Crowdedlight/Crows-Electronic-Warfare/assets/76476468/9c4cfe5a-3de6-4e34-bff3-ffaa01b6c5ef)

5. Once done you should see a blue line between the 3D model and the jammer module.

![image](https://github.com/Crowdedlight/Crows-Electronic-Warfare/assets/76476468/7b01696a-9269-434f-8577-d989005d4a0b)

