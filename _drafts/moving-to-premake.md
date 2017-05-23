---
title: We can Premake it if we try
layout: post
category: Programming
tags: [ Premake, Lua ]
---

Recently I started using [Premake](https://premake.github.io/) in my game/engine spare-time project. Premake is a tool that generates build configuration files for different build systems, such as Visual Studio and gmake. 

The Premake workflow is pretty simple: you write a Lua script which specifies what files are part of your project, the include directories, library directories and linker inputs. Premake imbibes your script and spits out .vsxproj files, makefiles or whatever files your target build system uses. 

For example, I have a file named 'premake5.lua' in the root directory of my project. When I run Premake like so:

```
C:/Dev/Quarrel/ premake5 vs2017
```

It automatically finds the Lua file and generates a .sln file and a bunch of .vcxproj files for my target build system (vs2017). The solution is set up the way I specified, with different configurations, platforms, compiler switches and so on.

Using Premake solves a number of problems I have:

- Visual Studio's GUI for modifying build settings is impressively bad, and the format for .sln and .vcxproj files is eye-destroying XML, so if you want to enable or disable a specific compiler flag, add or remove dependencies from the project, there's a lot that can go wrong. With Premake, I make changes to one easy-to-read Lua script, run the tool, and can get straight back to the real work. 
- As a result of the above problem, changing the way my solution/project is set up is a massive pain in the butt. With Premake it's so much easier to move files around, split things apart into sub-projects, etc.
- Eventually, I will be going cross-platform with this project and try to build it with a toolchain other than Microsoft's. With Premake I don't have to set up ten different kinds of build configurations for every different build system or IDE; people working on the project on different systems can just run Premake and get going.

I no longer have to think about the settings of my various Visual Studio solutions and projects because Premake abstracts it away.

I'd go into the nitty-gritty of how I moved my project over, but the details aren't that interesting.

At the end of all this, I have 3 projects in my solution/workspace:

- Box2D, a static library
- QuarrelLib, a static library, which contains all the engine code
- Quarrel, an executable

At the very least, Premake made it pretty easy to reorganize things, and for that I am pleased.

