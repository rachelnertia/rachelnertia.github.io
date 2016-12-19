---
title: Picking Easy Arguments
layout: post
category: Programming
tags: [ C++ ]
comments: true
---

We've all been there. We learn about a new-ish C++ feature, we consider using it, weighing our optimism against our awareness of the "*use all the features!*" trope that exists around C++, of the development hell stories about programmers writing inheritance chains 10 levels deep, with multiple inheritance, with both complexity and simplicity obscured by so many macros and templates you cannot understand anything about the intent of the code (and nor can the debugger). We back away nervously. Maybe another time, we say, and retreat back into the darkness -- it may be dark, but better the devil you know.

The argument to adopt recently-added C++ features is often quite difficult. This is often the way it ought to be. Other times, however, the argument can be won in less than a minute.

### Variadic Templates ###

Fuck [varargs](http://en.cppreference.com/w/cpp/utility/variadic). They're crap.

I have good news for you: after you learn about variadic templates, you'll never need to grudgingly `#include <cstdarg>` again.
