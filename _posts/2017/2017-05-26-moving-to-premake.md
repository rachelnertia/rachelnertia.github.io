---
title: We can Premake it if we try
layout: post
category: Programming
tags: [ Premake, Lua ]
---

<img src="/images/premake-logo.png" width="50%"/>

[Premake](https://premake.github.io/) is a tool that generates build configuration files for different build systems, such as [Visual Studio](https://www.visualstudio.com/) and [gmake](https://www.gnu.org/software/make/). It comes in the form of a [command-line tool](https://premake.github.io/download.html#v5) and some [okay](https://github.com/premake/premake-core/wiki/your-first-script) [tutorials](https://github.com/premake/premake-core/wiki/Tutorial:-Premake-example-with-GLFW-and-OpenGL) and [documentation](https://github.com/premake/premake-core/wiki) are available. I've started using it in my spare-time game engine project.

I chose to try Premake instead of a similar tool called [CMake](https://cmake.org/) because while CMake looks like it has more features and is more stable than Premake, using it requires learning a custom scripting language[^1]. In Premake you write your build instructions in [Lua](https://www.lua.org/). I'm not some kind of Lua expert -- in fact, when I started on writing my Premake script I found I'd forgotten quite a lot about the language -- but I have enough experience with it that I can [get things done]({% post_url 2015/2015-10-05-calculus-in-lua %}).

The Premake workflow is pretty simple: you write a Lua script which specifies what files are part of your project, the include directories, library directories and linker inputs, and so on. Premake imbibes your script and spits out .vsxproj files, [makefiles](https://en.wikipedia.org/wiki/Makefile) or whatever your target build system uses. 

For example, I have a file named 'premake5.lua' in the root directory of my project. It looks a bit like [this](/extra_stuff/example_premake_script.lua). When I run Premake like so:

```
C:\Made\Up\Path> premake5 vs2017
```

It automatically finds the Lua file (because of its special name) and generates a .sln file and a bunch of .vcxproj files for my target build system (vs2017 -- Visual Studio 2017). The solution is set up the way I specified, with different configurations (Debug/Release), platforms (x86/x86-64), compiler switches and so on.

Premake solves a number of problems I have:

- Visual Studio's GUI for modifying build settings is impressively bad, and the format for .sln and .vcxproj files is eye-destroying XML, so if you want to change something there's a lot that can go wrong. With Premake, I make changes to one easy-to-read Lua script, run the tool, and can get straight back to the real work. 
- As a result of the above problem, changing the way my solution/project is set up is a massive pain in the butt. With Premake it's so much easier to move files around in folders, split things apart into sub-projects, etc.
- Eventually I will be going cross-platform with this project. With Premake I don't have to set up ten different kinds of build configurations for every different build system or IDE and I don't have to remember all the differences between the compiler and linker options on each toolchain. People working on the project on different systems can just run Premake and get going. At the moment I'm only using one build system and not taking advantage of the cross-platform capabilities of Premake, but I still make gains in that I no longer have to think about the settings of my various projects because Premake abstracts all that away.

Using Premake it was pretty easy to do the long-overdue work of reorganizing files in my mess of a project. I wish I'd known enough about Premake to use it from the beginning and in past projects. Oh well[^2]!

[^1]: [Jeff Preshing](http://preshing.com) has written a couple of good-looking articles on getting started with CMake: [How to Build a CMake-Based Project](http://preshing.com/20170511/how-to-build-a-cmake-based-project/) and [Learn CMake's Scripting Language in 15 Minutes](http://preshing.com/20170522/learn-cmakes-scripting-language-in-15-minutes/).
[^2]: The list of 'Tools I Wish I'd Picked Up Years Ago' is getting pretty long.