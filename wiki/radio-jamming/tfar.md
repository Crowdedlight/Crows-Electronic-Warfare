# TFAR Jamming
The TFAR jammer can be placed on any object or unit. If placed on a position, it will spawn a data-terminal with base-game animation. Any object set as TFAR jammer that is currently active will emit a 3D sound when players come close. The jammer stops automatically if the object is deleted or destroyed.

The Jamming is calculated lineary from the border of the jammer radius towards the center. A base jamming strength of 50 seems to completely disable short-range if you are 30-45% towards the center of the jammer.

Players have the option to disable/enable the jammer with scroll-wheel action menu.

Zeus will not be jammed, but won't be able to hear players transmitting inside jamming area, if that player is totally jammed. Only Zeus has a mapmarker that updates if the position of the jammer changes. Moving jammers are possible.

Putting a jammer on an object already having a jammer will override the previous jammer. Each object can only have a single jammer.

```admonish warning
A lot of antenna objects are not destructable and as such you cannot blow them up to destroy the jammer. If you want to be able to blow up the jammer with explosives or rockets make sure to use a destructable object or the default dataterminal the module can spawn.
```

It has the limitation for now that only the closest jammer to a player will play the 3D sound for that player. So if 2 jammers are within hearing of a player only one will play the sound. (Will likely be changed in the future).
The jamming is also only calculated for the closest jammer, not depending on jamming strength.

Videos:
<iframe width="560" height="315" src="https://www.youtube.com/embed/ULbeO0v3awI?si=yvQlmfJN51Awclf-" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
<iframe width="560" height="315" src="https://www.youtube.com/embed/gmb4vAHD4Ig?si=5uRbckVGDzCtiClq" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>