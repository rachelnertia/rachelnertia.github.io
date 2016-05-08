---
title: Augmented Reality on the PlayStation Vita
layout: post
comments: true
category: Game Dev
tags: [ augmented reality, PlayStation Vita, coursework, Applied Game Technologies, Computer Games Technology, Abertay University]
---

![PlayStation Vita](/images/psvita.jpg 'It's a PlayStation Vita!')

The coursework for Applied Game Technologies[^1] lets you make more or less what you want, but what you make has to be a game and use either red-blue anaglyph [stereoscopic 3D](https://en.wikipedia.org/wiki/Stereoscopy) on PC or augmented reality on the PlayStation Vita. I chose the second option.

<!--more-->

[Augmented reality](https://en.wikipedia.org/wiki/Augmented_reality) (AR) technology renders computer-generated objects - text, characters, icons - on top of the real world so that they appear to be a part of it. It comes in many forms and there are lots of different approaches to it. The version we were taught how to use on the PS Vita makes use of the in-built camera. Each frame of the camera feed is searched for the presence of AR markers, simple shapes printed on bits of paper. Once found, the size and orientation of the marker in the image is used to generate a transformation matrix matching the marker's position and orientation relative to the camera. Then you use this transform as an 'anchor' for objects you render.

![PS Vita AR cards](/images/ps_vita_ar_cards.jpg 'Some of the default AR markers for the PS Vita.')

### What the Game is

The player is operating a police drone in a totalitarian state using an augmented reality interface. It is their job to pick out and apprehend wanted criminals from among a crowd of civilians. Before playing the game the AR markers are laid out on a flat surface. As many can be used as wanted, and more markers enables a larger playing area. Civilians are represented as small spheres and they wander about on the tabletop. Among them, one of them is the player's **target**, who they must **shoot**, but there's no way to know which it is until they begin **scanning**.

![Screenshot 1](/images/psvita_ar/01.png 'The player hasn't scanned yet.')

**Scanning** is triggered by pressing the Square button. If the target is contained inside the big green rectangle, then *every* civilian inside the rectangle turns red. The fewer there are in the rectangle, the more red they'll become. They will remain the same colour unless they are scanned again. The player must use the redness to narrow down their search for the target, scanning ever smaller and smaller groups of civilians. There is a cooldown time to prevent the player from scanning constantly.

To help the player home in on smaller groups of civilians without having to move the Vita up really close to the table (and potentially lose track of markers), the camera can be zoomed in and out[^2] using the left and right shoulder buttons.

![Screenshot 2](/images/psvita_ar/02.png 'The target was within the rectangle, so all the civilians in it have been turned ever so slightly red.')

When the player has scanned enough that they're pretty certain which civilian is the target they can **shoot** by pressing the X (Cross) button. If a civilian is beneath the crosshair in the middle of the screen when the player shoots, it is killed. If it was the target, the player is awarded points, plus a bonus if they manage to neutralize their target within 20 seconds. Shooting non-target civilians is penalized.

Once the target has been eliminated, a new one is assigned, and the game continues forever[^3].

![Screenshot 3](/images/psvita_ar/04.png 'This civilian is fully red - the player has recently scanned it and discovered that it must be the target. All they need to do now is shoot!')

### Dynamic Re-parenting

Every civilian is parented to ('belongs to') a marker. Its transformation matrix is defined in terms local to the transformation matrix of its parent marker. When a marker is 'lost' by the tracking system, either because it's been covered up by something or it's gone off-camera, all of its child civilians are re-parented to the marker nearest to them. Give or take a little jankiness (the marker-tracking software isn't perfect), the 'world' positions of civilians remain constant when they're re-parented, so you don't notice that anything's happened. This helps give the illusion that the Vita screen is a window onto a world that is larger than its dimensions. This wasn't that tricky to implement once I had figured out what I was doing - the code behind it is stupid and the maths is straightforward.

When the system has lost track of all markers the game is paused, so the player can put their Vita face-down on the table, walk away, and come back later to pick up where they left off.

### The Video

The video shows everything there is in the game, if you can make it out on the screen. Unfortunately there's no way to capture video straight from the PS Vita's screen without a bunch of hackery, so I had to get my friend David Ferguson to film over my shoulder while I played. Thanks, David!

I was going to edit and annotate/commentate the footage, but doing that stuff always takes *way* longer than you expect it to.

<iframe width="100%" height="315" src="https://www.youtube.com/embed/PoDMdOttS1Y" frameborder="0" allowfullscreen></iframe>

### Reflection

I'm pleased with how it all turned out. Around week seven of the semester Grant prompted us to take a couple hours just to do a bit of research, come up with an idea, and create a plan for executing it. I had a bunch of ideas, so I picked the one that seemed to best occupy the ground between 'easy' and 'interesting'. Next, I wrote down all the things I could think of that I'd need to do: problems to figure out, assets to make, code to write. Wherever I could, I cut ideas or relegated them to a box of 'extra features' so that the scope of the project was as contained as possible. Then I divided all the tasks over the coming 8 weeks or so, giving myself a bite-size chunk of work to do each week. It never felt like I was spending too much time on it, but I had everything completed, including the written report, well before the deadline. There were a ton of extra things I could have added to the game, like more mechanics and sound effects, but I think I left it in a good place.

I don't even own a Vita, let alone a development kit for the platform, so after I leave uni I'll never be able to run the game again. I can't even share the full source code because it's written on top of Non Disclosure Agreement-bound Sony code. So other than the video I don't really have much to *show* for this project, and that's a shame. There's the possibility I could develop the game in the future, porting what I have to a different platform (e.g. Android) and engine (e.g. Unity), though. That'd be cool.

My main take-away is that a good plan well-executed really teaches you the value of creating a feasible, straightforward plan and sticking to it. It seems like an obvious lesson, but as someone whose project plans tend to devolve and quite often end up being ignored, I never fully appreciated it until now. Crappy mental health has limited my time and energy for working on things, so it's become imperative to be as productive as I can when I can. I'm glad I'm learning how to manage myself effectively, and doing some things I'm happy with, despite the circumstances.

You can read the report I wrote for the coursework [here](/extra_stuff/agt_report.pdf).

I'm waiting on my grade now. Hopefully it's good, but who cares if it isn't - I learned stuff and had fun.

[^1]: No, it's not a very good name for a module. Especially for one on a course named 'Computer Games Technology.'
[^2]: It's not really zooming the camera, just scaling the camera feed texture as it is rendered to the screen and scaling the projection matrix.
[^3]: I didn't have time to create a win or lose state.
