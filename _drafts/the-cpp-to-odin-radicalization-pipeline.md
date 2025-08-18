---
title: The C++ to Odin Radicalization Pipeline
layout: post
category: Programming
---

Odin is a new procedural programming language.

It has syntax that reminds me of Pascal, the first programming language I learned.

It's for writing the sort of applications you could write in C/C++, but without some of the things that can make C/C++ code frustrating. Many user-friendly features take their place.

Here are some things I've learned about Odin so far:

A package is just a directory.

A lot of popular packages are just bundled with the compiler. These packages include Box2D and raylib. Out the box, I had everything I needed to write test programs with 2D physics, a window and simple graphics.

Types larger than 16 bytes are automatically passed by immutable reference (the equivalent of `const&` in C++) when used as function parameters. This is a sensible default. 
