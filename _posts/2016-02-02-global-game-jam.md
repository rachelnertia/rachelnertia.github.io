---
layout: post
comments: true
title: Shaking Hands with Aliens - Global Game Jam 2016 at Abertay
category: GameDev
tags: [game jams, Global Game Jam, Interstellar Soirée, Unity]
---

![](/images/ggj_logo.jpg)

This weekend I took part in Global Game Jam for the first time. 

[Global Game Jam](http://globalgamejam.org/) is an annual happening where people gather at specific locations all over the world and make games. It's not like [Ludum Dare](http://http://ludumdare.com/compo/) where you can work from home - instead the emphasis is very much on being in a shared space, meeting and working with new people. [Abertay University was host](http://globalgamejam.org/2016/jam-sites/abertay-university) to a throng of jammers, a crowd consisting of students, teachers, local industry and many other sorts of people.

<!--more-->

The atmosphere was fantastic: full of energy, positivity and productivity, with everyone looking out for each other. There's a bit of 'crunch culture' inherent in game jams and while [some jams and jam locations end up creating quite toxic environments](http://www.thetreehouse.website/five-of-the-reasons-i-decided-not-to-participate-in-global-game-jam-this-year/), the organisers and everyone at Abertay seemed to be on board with the real purpose of game jams: the process, not the product. Game jams are about practicing your skills, learning new ones, working with people and making things that don't quite work. Above all, they're about **having fun**. 

![](/images/ggj16_03.jpg)

I didn't have a pre-formed team when I pitched up on Friday but luckily I fell in with [Dziek Dyes-Bolt](https://twitter.com/DziekDB), a fellow programmer and 4th-year CGT, [Callum Fowlie](https://twitter.com/Fentlegen) and [Tone Persson](https://twitter.com/TonePersson), 4th-year artists both, and [Chris D'Arcy](https://soundcloud.com/dercii/sets/global-game-jam-2016), who contributed audio to multiple projects. I hadn't worked with any of them before but it seemed to me like we cooperated pretty well.

The theme was 'Ritual', so somehow we decided to make a game about shaking hands with aliens. All the aliens have different handshaking protocols you have to learn so as not to cause offense, because they'll blow up the Earth if you do, and your only help is an unhelpfully-verbose book entitled 'The Handshaker's Guide to the Galaxy'. In the end it played a bit like [Keep Talking and Nobody Explodes](http://www.keeptalkinggame.com/), with one player thumbing through the Guide and the other holding the controller.

<img style="float: right; width: 30%" src="/images/ggj16_02.jpg">

The game 'generates' aliens by matching together a body, a hand and a head. Each body part has specific rules attached to it; for example the head dictates which direction your hand should approach the alien's from. We only made 3 bodies, 3 heads and 4 hands, but even these small numbers create quite a wide number of possible aliens (36, to be exact!). I wanted to find a way to generate the text which would go in the Guide, as it would let us change and add rules without needing to manually rewrite the document, but didn't have enough time. In the end Tone and Callum got to write the Guide, and seemed to have a lot of fun writing it.

Me and Dziek finally had something playable by the end of Sunday morning and we were able to submit the game before the end of the jam at 3pm. People came over to try it out and watching them be initially confounded before learning the game and eventually succeeding was immensely satisfying.

![](/images/interstellar_soiree_01.png "First contact")

[You can download the game, including the full Unity project, from its page on the Global Game Jam website](http://globalgamejam.org/2016/games/interstellar-soir%C3%A9e) (Windows only; Xbox 360 controller required). Be warned, though: there is one accidental mistake in the Guide, and in the version we demoed immediately after the jam we increased the time limit to 35 seconds to make it easier. Hopefully we'll add more functionality and polish (and maybe even aliens!) in the weeks ahead and release a post-jam version of the game[^1]. 

In the meantime if you'd like to play Interstellar Soirée in its present form the best way is to ask me! I'm planning on demoing it at [Game Development Society](https://www.facebook.com/groups/AbertayGDS/) on Thursday, so if you're there you can give it a shot.

[Check out the other games made at Abertay this weekend](http://globalgamejam.org/2016/jam-sites/abertay-university/games) - in the time I spent wandering around trying to get a look at them all after 3pm on Sunday I barely got to see a quarter of them. So many games!

I want to thank Dziek for being a rad coding buddy, Tone and Callum for being amazing artists making amazing art, Chris for his audio skills and everyone else involved in the jam, especially [Ryan](https://twitter.com/Loakers) for creating an awesome creative space to work in!

[Here's a Storify of the weekend.](https://storify.com/Loakers/global-game-jam-2016-at-abertay-univeristy)

![](/images/ggj16_01.jpg "Natalie Clayton let me crash at hers both nights, which meant I didn't have to trudge back and forth all the way to my place twice in the freezing cold, but also meant I didn't change clothes all weekend ~")

'Jam' doesn't look like a real word to me any more.

[^1]: If you feel like taking a look at our code: go easy on us. Jam code, particularly when it's collaborative, is always going to be messy like a bowl of spaghetti. When it's me and Dziek writing it, even more so.