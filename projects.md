---
layout: page
title: Projects
---

Here is a list of basically every project I've taken the time to document somewhat on this site. Includes personal projects, collaborative efforts and uni work. 

# Professional Credits

## Rockstar Games 2016-2025

At Rockstar North in Edinburgh I was part of the Network Code team as a Network Programmer, contributing to updates for *Grand Theft Auto V* and its online mode...

![](/images/gta-online.webp)

*Red Dead Redemption II* and its multiplayer...

![](/images/red-dead-online.jpg)

And, of course, the upcoming *Grand Theft Auto VI*.

![](/images/gta-vi.webp)

I helped develop many aspects of networking across these projects, including but not limited to:

- gameplay synchronization
- sessioning
- server architecture
- communication with backend services
- platform integration

As I did so, I got to work closely with developers from other teams and departments, learning how the triple-A sausage is made in visceral, up-close detail.

It was a pretty good time 😊

# Ongoing Projects

*Things I just can't quit.*

### Magewinds

![](/images/magewinds.jpg)

A tabletop miniature skirmish wargame in which everyone is a mage. You can check it out and get all the rules on the game's [website](http://www.magewinds.com/).

# Old Projects

*Things I'm no longer touching.*

## Game Development

### Quiver (2016-2019ish)

Quiver is a cross-platform pseudo-3d game engine I was writing in my spare time in C++. It grew out of the Box2D raycasting experiment I wrote about [here]({% post_url 2016/2016-04-07-box2d-raycasting-test %}) and [here]({% post_url 2016/2016-04-27-box2d-raycasting-progress %}) and became quite a fruitful learning project. I even gave a [presentation at the local C++ meetup about it]({% post_url 2018/2018-01-10-quiver-presentation %}).

You can check out the source code at the [GitHub repository](https://github.com/rachelnertia/Quiver).

I was making a game using Quiver, called Quarrel, which has its own [repository](https://github.com/rachelnertia/Quarrel).

### Interstellar Soirée (Global Game Jam 2016)

<img style="width: 100%" src="/images/interstellar_soiree_01.png">

Space diplomacy. Jam theme: 'Ritual'. Made with Dziek Dyes-Bolt (programmer), Tone Persson, Callum Fowler (artists), Chris D'Arcy (audio).

- Unity, C#
- Platform: Windows
- Xbox 360 controller required
- [Blog post]({% post_url 2016/2016-02-02-global-game-jam %})
- [Global Game Jam page](http://globalgamejam.org/2016/games/interstellar-soir%C3%A9e)

### Nomad (unfinished prototype) (2015)

<img style="float:right; width:280px;" src="/images/nomad_01.gif">

Space exploration with an unconventional movement system. 

- Unity, C#
- Platforms: Windows, Mac (and Linux?)
- [Blog post]({% post_url 2016/2016-01-10-nomad-prototype %})
- Download on [itch.io](http://inertia.itch.io/nomad)

<br>

### Flappy Word (October - December 2015)

<img style="float: right;" src="/images/flappy_word_v1_0.gif">

Typing-based *Flappy Bird* clone

- Unity using C#
- Platforms: Windows, Web, Mac, Linux(?)
- Download/Play on [itch.io](http://inertia.itch.io/flappy-word)
- [Blog posts tagged 'Flappy Word'](/tag_index#Flappy Word)
- [Full source](/files/flappy_word_src.zip)

<br>

### AMPS (January - August 2015)

<iframe width="100%" height="315" src="https://www.youtube.com/embed/Uqf9pG_wa70" frameborder="0" allowfullscreen></iframe>

Neon musical platformer in which objects in the world move to the beat of the music.

- 3rd year group project gone big. The full story is too long to recite here.
- 8 months of development
- 7 team members: 3 programmers, 2 sound designers, 1 level designer, 1 artist
- Contributed to engine, gameplay and audio-handling code; implemented synchronisation of game objects with the music, which can be sped up and slowed down; managed the audio asset pipeline.
- Demoed to the public for 4 days at our own booth at the Dare Indie Showcase.
- C++, Sony's [PhyreEngine](http://develop.scee.net/research-technology/phyreengine/)
- Platforms: Windows (requires DirectX 11), PS4
- Visit the [itch.io page](http://pack-of-wolves.itch.io/amps) for more information and to download.

### Spirit Shift (August 2014)

<iframe width="100%" height="315" src="https://www.youtube.com/embed/g1h_YVwMcj0" frameborder="0" allowfullscreen></iframe>

Endless runner with world-shifting mechanic.

- A team effort made in 72 hours for Ludum Dare 30 (theme: *Connected Worlds*). [Connor Halford](http://www.codetrip.weebly.com) and myself took the role of programmers while [Tobias Cook](http://tobiascook.tumblr.com/) and [Cameron Moore](http://www.illucam.com/) made the art.
- Engine: [Game Maker](http://www.yoyogames.com/studio)
- Platform: Windows
- [Ludum Dare page](http://ludumdare.com/compo/ludum-dare-30/?action=preview&uid=39966)
- [itch.io page](http://rhythmlynx.itch.io/spirit-shift)

### Other Games

- **Applied Games Technology coursework (2016)** 
  - Augmented reality PlayStation Vita game in which you must surveil a crowd of pedestrians to find and eliminate a target. 
  - [Blog post]({% post_url 2016/2016-05-08-augmented-reality-ps-vita %}).

## Graphics Programming

### Water (2014)

<iframe width="100%" height="315" src="https://www.youtube.com/embed/lz3jgA7NtzI" frameborder="0" allowfullscreen></iframe>

- DirectX 11, C++
- Part 1 of my Graphics Programming with Shaders coursework ([Download](/files/uni-coursework/graphics-programming-with-shaders.zip))
- Water plane is tessellated. Waves formed by manipulating vertices in the domain shader. Normal map used to add some noisiness to the surface.
- Water reflects the skybox cubemap
- Bonus: full-screen pixelation effect (the easiest full-screen effect to write!)

### Compute Shader Voxel Space (2014)

<iframe width="100%" height="315" src="https://www.youtube.com/embed/u0yw8IjxA6Q" frameborder="0" allowfullscreen></iframe>

More deets in the video description. Also [this](https://www.youtube.com/watch?v=c27ULJLitV8).

- DirectX 11, C++
- Part 2 of my Graphics Programming with Shaders coursework ([Download](/files/uni-coursework/graphics-programming-with-shaders.zip))
- Compute shader port of the 'voxel space' rendering algorithm implementation on display at [Simulation Corner](http://simulationcorner.net/index.php?page=comanche)

This went on to form the basis of my fourth-year Honours project, of which, unfortunately, I seem to have lost all records. (It was a stressful time.)

## Other Programming

### Warcry Card Creator (2019)

![](/images/warcry-card-creator-example.png)

A little web tool for making custom fighter cards for Warcry, a skirmish game from Games Workshop. You can [try it out](http://rachelnertia.github.io/warcry-card-creator) and view the [source](https://github.com/rachelnertia/warcry-card-creator), but know that it has since been forked and vastly improved upon by the Warcry community, and you can find the most up-to-date version of it [here](https://barrysheppard.github.io/warcry-card-creator/index.html).

### Procedural Walker (2015)

<iframe width="100%" height="315" src="https://www.youtube.com/embed/v0bhCky_jpM" frameborder="0" allowfullscreen></iframe>

More notes in the video description.

- Autodesk Maya. Plugin written using the C++ API, which I learned by myself because it wasn't covered in the module. A sprinkling of Python and MEL.
- Made for the Scripting and Dynamics coursework

### Leg Auto-Rigger (2014)

- Autodesk Maya. Python script.
- Chose to build this for my Tech Art coursework
- [Demo video](https://www.youtube.com/watch?v=7Fw2v4L9av4)