---
layout: post
title: Flappy Word v1 Feedback
comments: true
---

People seem to like *Flappy Word*. According to one person it is "officially more addicting than Flappy Bird!" 

Is that good?

##Technical Issues

The game runs, but not as well as it ought to.

It takes an annoyingly long time to start up. With no loading screen it seems like nothing is happening, so I need to look into ways to both improve the load time and implement a loading screen if possible.

On some computers it didn't work at all. The issue was usually reported as something to do with the browser not being able to allocate enough memory to hold the game, but I haven't sat down at one of the offending computers to see the error for myself. 

I'll start by looking at storage usage. The folder containing the v1 WebGL release build of *Flappy Word* is **32.3 MB**. That's a lot considering how simple this game is. In 1990 the capacity of a normal desktop computer's hard drive was about **40 MB** ([source](http://royal.pingdom.com/2010/02/18/amazing-facts-and-figures-about-the-evolution-of-hard-disk-drives/)). Consumer-available RAM units didn't break the 40 MB barrier until around 2000 ([source](http://www.jcmit.com/memoryprice.htm)).

Where's all this data coming from?

![]({{site.baseurl}}/images/flappy_word_v1_data_01.png)

The Compressed folder just contains tiny versions of the files in the Release folder, but since the game still loads and runs just fine if I delete them it's not clear if they're used at all.

![]({{site.baseurl}}/images/flappy_word_v1_data_02.png)

Within the Release folder the biggest file by a long way is **build.js**, which I believe contains engine code, game logic code, and so on all compiled into JavaScript. No text file should be this large. [Sublime Text](http://www.sublimetext.com/) can't seem to open it. Notepad struggles. [Notepad++](https://notepad-plus-plus.org/) craps itself when you try to scroll down through the wall of whitespace-less code.

I guess that if I were to simply write this game in JavaScript the all the source files put together would amount to a tiny fraction of this 20 MB monolith. It might take a bit longer to make because I'm not exactly experienced in JS, but this is not a complicated game and it doesn't need a heavyweight engine like Unity backing it up. I don't think I can control the size of the builds.js file that Unity creates, but I'll certainly look into it.

![]({{site.baseurl}}/images/flappy_word_v1_data_03.png)

So what's in the asset-containing file, **builds.data**? It accounts for almost 20% of the folder size, and in this case I actually can control how much space it takes up.

I've changed the game a little bit since v1, but if I launch Unity, rebuild the game and look at the editor log I get to look at a breakdown of the assets which the game uses. Unused assets are stripped out of the build.

<code>
1.1 mb	 17.1% Assets/Resources/dictionary.txt<br>
717.7 kb	 11.1% Assets/COURBD.TTF<br>
52.5 kb	 0.8% Assets/Blast-SoundBible.com-2068539061.wav<br>
25.3 kb	 0.4% Resources/unity_builtin_extra<br>
24.8 kb	 0.4% Assets/Typewriter SFX/Stereo/Tab 1.wav<br>
6.4 kb	 0.1% Assets/Typewriter SFX/Stereo/Key 04.wav<br>
...
</code>

The biggest space-hog by a long way is the dictionary, but even then 1.1 MB isn't much to worry about. There are probably smarter ways to handle the dictionary file that I haven't had time to figure out yet. Currently the entire thing is loaded into memory for fast access and to sort it by word length, which my gut tells me is better than doing a bunch of file reading operations every time I need to get a new word.

My next question is how much the game actually takes up in memory. If I run it in the Unity editor and look at the profiler, I get this: 

![]({{site.baseurl}}/images/flappy_word_v1_data_04.png)

**472 MB**. It seems like a large amount of space, but this is running unoptimized in the editor, after all. How much memory is it using when it runs in the browser? Chrome's task manager says the tab with Flappy Word running in it sits at around **230 MB** or so, meaning the game uses less memory in release than it does in the editor, as you'd expect. I haven't found a way to see the game's exact memory usage in the browser yet. Still, looking back at our RAM-capacity-over-time stats... it's a lot.

Another technical issue others have reported and that I've seen for myself is a certain amount of input lag or choppiness in framerate from time to time. I think this might just be Unity's WebGL player's fault. There might be ways I can improve it.

Anyway. That's all very interesting and the biggest problems seem outside my control. What about the actual game?

##The Actual Game

* The first negative that came up was people not realising what they were supposed to do. Coupled with the fact that the game didn't have focus by default so their keyboard input did nothing until they clicked on it, this made for a pretty confusing first impression. I can solve this pretty easily just by putting in a tutorial prompt right at the beginning.
* People seemed to like the little boost you get with each letter typed because it "adds complexity without adding new interactions", as one person said. I chucked it in when I thought of it at the last minute and found it made every keypress mechanically meaningful, which I like, so I'm glad others like it. I think the strength of the boost, a long with a lot of other parameters, needs tweaking.
* The ramp from short words to allowing longer ones feels about right.
* The typewriter sounds were a good call.
* People seem to be into the idea of a typing game which isn't just about typing fast (like *Typing of the Dead*).
* Profanity is good. Because the game starts off with only short words and most rude words are short, the ratio of rude words is abnormally high at the beginning. "In the last ~15 minutes I've had 'penis' twice and 'phalli' once." I played the game last night and literally the first word that came up was 'anus'.

So that's where *Flappy Word* is at the moment.

![]({{site.baseurl}}/images/connor_enabling.png)

