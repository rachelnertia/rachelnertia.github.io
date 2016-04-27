---
layout: post
category: Programming
title: Box2D Raycasting Engine Progress
tags: [Box2D, SFML, Raycasting, Graphics]
comments: true
---

I've been working on an old-fashioned raycast-rendering system that uses Box2D's ``b2World::RayCast`` method to draw the world instead of casting rays against a grid the way *Wolfenstein 3D* does it.

[Where I left off]({% post_url 2016-04-07-box2d-raycasting-test %}) I'd just managed to get a limited generic system up and running. Every fixture (shape) in the ``b2World`` was rendered as a wall.  Nothing could be partially transparent. Nothing could appear behind anything else. There was no support for differently-coloured walls or sprites (flat objects which always face the camera).

In the intervening time I've made gains. Check this out:

![](/images/b2dray/05.png)

Pictured: differently-coloured walls, including a partially-transparent one, and a sprite. Here's a Box2D debug-draw of the world (although the camera, the white un-filled circle, isn't in quite the same position):

![](/images/b2dray/06.png)

## Different Types of Things

Every Box2D fixture stores a void pointer to anything the programmer wants, like a 'GameObject' instance or something. Right now I'm pointing to instances of this struct which needs a better name:

{% highlight cpp %}
struct UserDataTest {
	enum class Type {
		Wall,
		Sprite
	} type;
	sf::Color color = sf::Color::White;
	sf::Texture* texture = nullptr;
	float sprite_radius = 1.0f;
};
{% endhighlight %}

- **``type``** is used to branch the rendering algorithm. Are we rendering a wall or a sprite?
- **``color``** is, uh, the colour. I did some translating there, from American to British English. It tells the renderer what colour the thing (wall or sprite) should be. Can have alpha < 100%.
- **``texture``** is only used for sprites. I don't know how to texture the walls yet and thus far thinking about it has just made my head hurt.
- **``sprite_radius``** is used when rendering sprites, which we'll get to pretty soon.

## Sprites

It's never easy. It's always confusing. Doing things a new way means more confusion and less easiness.

In a *Wolfenstein 3D*-style renderer, walls and sprites are drawn in two separate passes. First, you cast a bunch of rays against your wall grid and draw the walls. As you go, you store the distance each ray travelled before it hit a wall in a kind of one-dimensional depth buffer. Then you sort the list of sprites based on how far away they are from the camera and start drawing them starting with the one furthest away. Sprites are correctly occluded by walls thanks to the depth buffer - each time you draw a column of sprite-pixels, you check whether the distance to that bit of the sprite is less than the value in the depth buffer. [Here's a better, more in-depth explanation](http://lodev.org/cgtutor/raycasting3.html).

Here, sprites are rendered as part of the same pass as walls, which means they can't just be stored as an array of positions. They need to be fixtures which the Box2D ray can intersect with. So what shape should they be?

![](/images/b2dray/diagram01.png)

### Distortions



## Transparency / Drawing Things Behind Other Things

I thought I could just cast a ray into the world, pushing ray intersection points onto a list of some sort, and stop when the ray hit something with fully opaque. Then I'd step through the intersections, which would be nicely sorted in order of distance from the camera, and draw them. There are two problems with this:

1. ``b2World::RayCast`` doesn't return results (intersection points) in order of increasing distance from the start point of the ray. [It just returns intersections in any old order](http://www.iforce2d.net/b2dtut/world-querying).
2. Doing things this way prevents us from supporting walls of different heights later on; a shorter, fully-opaque object in the foreground would stop us drawing another, taller one in the background.

So instead we collect *every* ray intersection point into a list, then sort that list, then draw from back to front. A new ``std::vector`` is constructed, filled, and sorted. *For every column of pixels on the screen*.

That's okay, though! It runs super fast... just not in debug builds.

### Debug Iterator Fun

All this ``std::vector`` manipulation causes the framerate to plummet in debug builds thanks to a bunch of run-time checks which are added into the code for all Standard Container Library (SCL) containers. This extra code, which checks for  is absent in release builds, where ``_ITERATOR_DEBUG_LEVEL = 0`` by default ([Read](https://msdn.microsoft.com/en-us/library/aa985982(v=vs.120).aspx) [more](https://msdn.microsoft.com/en-us/library/hh697468(v=vs.120).aspx)). It's possible to ``#define`` that macro to 0 in your debug builds, but unless the same has been done for all the .libs and .dlls you're linking and running with then conflicts will occur because off different-size iterators, so you need to rebuild all those external dependencies so they don't have debug-iterator code in them any more.

Yeah, screw that. Now I just have a custom configuration in Visual Studio called 'ReleaseNoOpt', which is just the release configuration but with compiler optimisations turned off (``/Od``), so I can inspect variables and all that good stuff but the program doesn't run horribly slowly. Problem solved!

## Next Steps
