---
layout: post
title: Warcry Card Creator
category: Programming
tags: [ Web Development, Warhammer, Warcry ] 
comments: true
---

I have been working on a little tool for making fighter cards for Warcry, GW's new skirmish game (wot is very good). Using a template, you can set how many wounds your fighter has, how far they can move, the stats of their weapons, etc. 

[Check it out!](http://rachelnertia.github.io/warcry-card-creator)

Here is an example card I made for Grashrak:

![](/images/warcry-card-creator-example.png)

There's still a bit of work to do.

1. The page saves its state after every change so it can restore it if you close the page and come back, but this functionality is incomplete. For one thing, it doesn't restore user-provided images. For a second, it would be good to have save slots the user can name.
2. The page is *ugly*. Even if I don't manage to make a pretty background or find a better typeface or whatever, I'd like the interface to be clearly broken up into sections.
3. Pageview tracking? I think I should already have this but I'm not sure.

Working on this I've learned a fair bit about front-end web programming. I grew my familiarity with JavaScript, picked up some JQuery, touched a little Bootstrap. Hosting is handled by GitHub Pages the same way this website is, using Jekyll to build the final HTML from templates.

It was pretty well received [on Twitter](https://twitter.com/nershly/status/1194248277807566848). Once it's a bit prettier I'll find other places to share it.

I hope to round out the feature set by the end of the year and start working on other tools and neat things. Now that I know how to make little web applications, my head is full of ideas for things to try.