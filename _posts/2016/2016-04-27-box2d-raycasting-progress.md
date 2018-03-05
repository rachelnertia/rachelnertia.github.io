---
layout: post
category: Programming
title: Box2D Raycasting Engine Progress
tags: [Box2D, SFML, Raycasting, Graphics]
comments: true
---

[I've been working]({% post_url 2016/2016-04-07-box2d-raycasting-test %}) on an old-fashioned raycast-rendering system that uses Box2D's ``b2World::RayCast`` method to draw the world instead of casting rays against a grid the way *Wolfenstein 3D* does it.

Where I left off I'd just managed to get a limited generic system up and running. Every fixture (shape) in the ``b2World`` was rendered as a wall.  Nothing could be partially transparent, nothing could appear behind anything else, there was no support for differently-coloured walls, and there were no sprites. In the intervening time I've enabled these capabilities.

![](/images/b2dray/05.png "I get a lot of test-sprite mileage out of this dwarf.")

<!--more-->

## Different Types of Things

Every Box2D fixture can store a ``void`` pointer to anything the programmer wants, for example a 'GameObject' instance. Right now I'm pointing my fixtures to instances of a simple structure that tells the rendering function how to draw the fixture:

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
- **``sprite_radius``** is used when rendering sprites.

## Sprites

![](/images/b2dray/14.png)

In a *Wolfenstein 3D*-style renderer, walls and sprites are drawn in two separate passes. First, you cast a bunch of rays against your wall grid and draw the walls. As you go, you store the distance each ray travelled before it hit a wall in a kind of one-dimensional depth buffer. Then you sort the list of sprites based on how far away they are from the camera and start drawing them starting with the one furthest away. Each time you draw a column of sprite-pixels, you check whether the distance to that bit of the sprite is less than the value in the depth buffer. If it is, you draw. [Here's a better, more in-depth explanation](http://lodev.org/cgtutor/raycasting3.html).

In this new system, sprites are rendered as part of the same pass as walls, which means they can't just be stored as an array of positions. They need to be fixtures which the Box2D ray can intersect with. So what shape should they be?

In the end, each sprite is just a line segment. It begins at the left edge of the sprite and ends at the right edge, passing through the sprite's centre. It is perpendicular to the line that joins the sprite's centre to the camera's position. That is, it 'faces' the camera.

If it were possible to represent sprites as line segments here then everything would be perfect - but doing so would mean having to update them all every frame to make sure they face straight at the camera, which wouldn't play nicely with Box2D. They would also be rubbish for physics stuff.

So sprites are circles. The ray intersects the circumference of the circle and the I do some maths to project that intersection point onto the camera-facing sprite-line that the circle contains. (I won't go into the maths here.) This is where the ``sprite_radius`` member of ``UserDataTest`` comes in handy, because there's no way to know how big the intersected circle is (or indeed if it's a circle at all). Using the projection we can learn how far along the sprite-line we are, and use that value as a **U** co-ordinate to texture the line we finally draw.

It'd be nice to find a better solution; perhaps a hybrid in which sprites' physical components are circular but the part that the raycaster cares about is just a line segment, rotated every frame to face the camera.

### Distortions

When casting rays from the camera there are two ways to figure out what size the angle between each ray should be:

- Rotate the camera's forward vector.
- Skew the camera's forward vector along a 'viewing plane' vector. The viewing plane is perpendicular to the forward vector.

{% highlight cpp %}
// [-1, 1] How far across the screen from the current ray is.
// -1: far left
// +1: far right
float screenx = -1.0f + (2.0f * (i / screen_width));

// Determine ray direction...
// Rotate the camera's forward vector:
float view_angle = (PI * 0.25f);
RotateVec(camera.fwd, view_angle * screenx);
// OR skew it along the view plane:
b2Vec2 view_plane(-camera.fwd.y, camera.fwd.x);
(camera.fwd) + (screenx * view_plane)

// Determine the end point of the ray in world space:
b2Vec2 rayend = camera.pos + ray_length * raydir;
{% endhighlight %}

There are two ways to calculate the distance from the camera to each ray intersection point:

- Use the actual (or *Euclidean*) distance.
- Use the perpendicular distance.

{% highlight cpp %}
// Actual distance:
float distance = ray.Length();
// OR
// Perpendicular distance:
float distance = DotProduct(ray, camera.fwd);
{% endhighlight %}

These different modes can be combined for different results. (View Plane + Actual Distance) and (Rotated Forward Vector + Perpendicular Distance) don't look so good, which leaves us with 2 rendering modes: (View Plane + Perpendicular Distance) and (Rotated Forward Vector + Actual Distance).

Below, the images on the left were rendered with (View Plane + Perpendicular Distance), and those on the right with (Rotated Forward Vector + Actual Distance):

<img src="/images/b2dray/09.png" width="49%" style="display:inline;"/>
<img src="/images/b2dray/10.png" width="49%" style="display:inline;"/>

<img src="/images/b2dray/07.png" width="49%" style="display:inline;"/>
<img src="/images/b2dray/08.png" width="49%" style="display:inline;"/>

As you can see on the left, the first mode gives nice, straight edges on nice, straight-edged things, while on the right the second gives a fisheye effect. The first method distorts curved objects badly towards the edge of the screen if you're not looking at them dead-on while the second renders them as they should appear. Swings and roundabouts.

What's my point with all this? It affects sprite rendering. To the raycaster,  sprites are circles, so in (View Plane + Perpendicular Distance) mode, sprites get distorted if you're not facing them dead on, like this particularly bad example:

<img src="/images/b2dray/11.png" width="49%" style="display:inline;"/>
<img src="/images/b2dray/12.png" width="49%" style="display:inline;"/>

In both screenshots the camera is the same distance from the sprite. In the next image the second mode (Rotated Forward Vector + Actual Distance) is used. The sprite is still distorted, but in a less extreme way. The remaining distortion is there because the camera is WAY up close. (The sprite's pixels are taller than they are wide for a completely different reason.)

![](/images/b2dray/13.png)

The distortion of curves and sprites is less obvious when the camera is further away and the field of view is decreased, but it'd be nice to find a proper fix for it.

## Transparency / Drawing Things Behind Other Things

I thought I could just cast a ray into the world, pushing ray intersection points onto a list of some sort, and stop when the ray hit something with fully opaque. Then I'd step backwards through the list, which would be nicely sorted in order of distance from the camera, drawing intersections one by one. There are two problems with this:

1. ``b2World::RayCast`` doesn't return results (intersection points) in order of increasing distance from the start point of the ray. [It just returns intersections in any old order](http://www.iforce2d.net/b2dtut/world-querying), because optimisations.
2. Doing things this way would prevent me from supporting walls of different heights later on; a shorter, fully-opaque object in the foreground would stop us drawing another, taller one in the background.

So instead I collect *every* ray intersection point into a list, then sort that list, then draw from back to front. A new ``std::vector`` is constructed, filled, and sorted. *For every column of pixels on the screen*.

In spite of this, it runs fast... just not in debug builds.

### Debug Iterator Fun

All this ``std::vector`` manipulation causes the framerate to plummet thanks to a bunch of run-time checks which are added into the code for all Standard Container Library (SCL) containers. This extra code is absent in release builds, where ``_ITERATOR_DEBUG_LEVEL = 0`` by default ([Read](https://msdn.microsoft.com/en-us/library/aa985982(v=vs.120).aspx) [more](https://msdn.microsoft.com/en-us/library/hh697468(v=vs.120).aspx)). It's possible to ``#define`` that macro to 0 in your debug builds, but unless the same has been done for all the .libs and .dlls you're linking and running with then conflicts will occur because of different-sized iterators. Which means you need to rebuild all your external dependencies.

Yeah, screw that. Now I just have a custom configuration in Visual Studio called 'ReleaseNoOpt', which is just the release configuration but with compiler optimisations turned off (``/Od``), so I can inspect variables and all that good stuff but the program doesn't run horribly slowly. Problem solved! Maybe.

## Next Steps

I think I'm going to wait a bit before I push any changes to the [GitHub repository](https://github.com/rachelnertia/Box2D-Raycasting-Test), in the hope that I can iron out some things and maybe find a better solution for sprites. I've been planning a game using this system, so I have a big To Do list. Up top is stuff like adding support for sprites of different heights and sizes, which will definitely go into the next version of the example on GitHub. After that is things I need for the game, like animated sprites, moving things around, some kind of level-editing tool... I'll probably be writing about that stuff too as I go through it.

That's all for now, I think. This post ended up WAY longer than I expected it to be. Good grief.

UPDATE 17/05/2016: I've put this stuff on the 'experimental' branch of the GitHub repo.
