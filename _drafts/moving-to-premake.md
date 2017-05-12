---
title: We can Premake it if we try
layout: post
category: Programming
tags: [ Premake, Lua ]
---

Recently I started using [Premake](https://premake.github.io/) in my game/engine spare-time project. Premake is a tool that generates build configuration files for different build systems, such as Visual Studio and gmake. The workflow is pretty simple: you write a Lua script which specifies what files are part of your project, the include directories, library directories and linker inputs. Then Premake reads your script and spits out .vsxproj files, makefiles or whatever files your target build system uses. 

Using it solves a number of problems I have:

- Visual Studio's .sln and .vcxproj are eye-destroying XML, and the GUI for modifying build settings for different projects is impressively bad, so if you want to enable or disable a specific compiler flag, add or remove dependencies from the project, there's a lot that can go wrong. With Premake, I make changes to one easy-to-read Lua script, run the tool, and can get straight back to the real work.
- As a result, changing the way my project is set up is a massive pain in the butt. With Premake it's so much easier to move files around, split things apart into sub-projects, etc.
- Eventually, I will be going cross-platform with this project and try to build it with a toolchain other than Microsoft's. With Premake I don't have to set up ten different kinds of build configurations for every different build system or IDE.  

I no longer have to think about the settings of my various Visual Studio solutions and projects because Premake abstracts it away.

At the end of all this, I have 3 projects in my solution/workspace:

- Box2D, a static library
- QuarrelLib, a static library, which contains all the engine code
- Quarrel, an executable

At the very least, Premake made it pretty easy to reorganize things, and for that I am pleased.

