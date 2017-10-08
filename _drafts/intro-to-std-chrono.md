---
layout: post
category: programming
tags: [ C++ ]
comments: true
---

How many times have you tried to call a function that alleges to return a time value only to realise you don't know what units the value is in? Or that takes a time value as a parameter, but doesn't specify whether the value is expected to be in milliseconds, seconds, or hours?

```cpp
// Examples:

// What is it? I guess milliseconds? Could be microseconds!
int GetGameTime();

// deltaTime is probably in seconds?
void TakeStep(const float deltaTime);
```

Hopefully there are comments somewhere near the declaration of the function that can help straighten things out, but better solutions are possible.

This is the motivation behind types like C#'s [System.TimeSpan](https://msdn.microsoft.com/en-us/library/system.timespan).

Many C++ libraries have their own time type. For example, [SFML](https://www.sfml-dev.org/index.php) has [`sf::Time`](https://www.sfml-dev.org/documentation/2.4.2/classsf_1_1Time.php) and [`sf::Clock`](https://www.sfml-dev.org/documentation/2.4.2/classsf_1_1Clock.php). sf::Clock::getElapsedTime returns a sf::Time, and sf::Times can be compared to each other, added to and subtracted from each other, and provide their values as seconds (float), milliseconds (int32) or microseconds (int64).

Until C++11, the language didn't have a standard library time type. Enter chrono.

chrono, like many things in the standard, began life outside it and was adopted into it. **TODO: History of chrono**

chrono exists at a higher level of abstraction than sf::Time/Clock do. The library consists of three template types: clocks, time points and durations. **TODO: Basic explanation of what these are**

**TODO: User-defined literals**

You might think this is a mere quality-of-life issue, that strongly-typed time values like chrono provides are just for improving the readability of code and usability of library APIs, but here's a slide from [Bjarne Stroustrup's CppCon 2017 keynote](https://youtu.be/fX2W3nNjJIo?t=3173):

![](/images/bjarne.png)

...in which he pointed out that the failure of the [Mars Climate Orbiter](https://en.wikipedia.org/wiki/Mars_Climate_Orbiter), which crashed into the surface of the red planet in 1999, due to a software bug that would have been completely avoidable had a particular API encoded the units of measurement it used (in this case, imperial instead of metric).

This stuff matters, and can be surprisingly costly, even in games[^1]. That's what I'm going to spend the rest of this post talking about: using chrono in games.

First, let's get something out the way. You might be on the verge of springing from your seat to say that *surely* using a simple int or float is faster than something complicated and (boo, hiss) *modern* like a duration? Well, no.

Duration is a zero-cost abstraction[^2]. **TODO: Explain a bit**

**TODO: Defining your own clock? E.g. one whose epoch is the beginning of the game world, that ticks every time the world updates.**

Common idiom: the 'update method' that takes a delta time.

[^1]: Quality assurance, debugging and fixing all take time, and time is money!
[^2]: At runtime, anyway. You might incur a compile-time cost from all that template magic.
