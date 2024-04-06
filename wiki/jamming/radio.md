## Radio jamming
The mod currently supports jamming radios for TFAR and ACRE2. 

### Spectral behaviour
To jam the radios the area denial jammer is working an all possible radio frequencies.
In the Spectrum Device this is visible as a very distinct spectral behaviour. Such a jammer will show a spectral peak that is "sweeping" from left to right.
![image](https://github.com/Crowdedlight/Crows-Electronic-Warfare/assets/76476468/324ce56b-e2cf-4196-a37a-f0460b16c31d)

### Multiple Jammer Effect
The jamming is only calculated for the closest jammer, so being within range of multiple jammers will not compound the jamming effect. It will always apply the strongest (closest) jamming effect you are within range of.  

### Videos
```admonish info
Note that these videos are from an earlier version and thus likely outdated
```
<iframe width="560" height="315" src="https://www.youtube.com/embed/ULbeO0v3awI?si=yvQlmfJN51Awclf-" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
<iframe width="560" height="315" src="https://www.youtube.com/embed/gmb4vAHD4Ig?si=5uRbckVGDzCtiClq" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

### ACRE Jamming
In acre the jammer will lower the signal strength dBm for received signals the further into the `falloff` area you are. It is a more simple method and real life calculations. Improvements are welcome.  