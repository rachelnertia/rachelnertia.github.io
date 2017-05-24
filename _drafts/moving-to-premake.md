---
title: We can Premake it if we try
layout: post
category: Programming
tags: [ Premake, Lua ]
---

<img src="/images/premake-logo.png" width="50%"/>

Recently I started using [Premake](https://premake.github.io/) in my game/engine spare-time project. Premake is a tool that generates build configuration files for different build systems, such as [Visual Studio](https://www.visualstudio.com/) and [gmake](https://www.gnu.org/software/make/). It comes in the form of a [command-line tool](https://premake.github.io/download.html#v5) and some [okay](https://github.com/premake/premake-core/wiki/your-first-script) [tutorials](https://github.com/premake/premake-core/wiki/Tutorial:-Premake-example-with-GLFW-and-OpenGL) and [documentation](https://github.com/premake/premake-core/wiki) are available.

I chose to try Premake instead of a similar tool called [Cmake](https://cmake.org/). Cmake looks like it has more features and is more stable than Premake but using it requires learning a custom scripting language[^1]. Premake, on the other hand, uses Lua. I'm not some kind of Lua expert -- in fact, when I started on writing my Premake script I found I'd forgotten quite a lot about the language -- but I can [get things done]({% post_url 2015-10-05-calculus-in-lua %}).

The Premake workflow is pretty simple: you write a Lua script which specifies what files are part of your project, the include directories, library directories and linker inputs. Premake imbibes your script and spits out .vsxproj files, makefiles or whatever files your target build system uses. 

For example, I have a file named 'premake5.lua' in the root directory of my project. When I run Premake like so:

```
C:\Made\Up\Path> premake5 vs2017
```

It automatically finds the Lua file and generates a .sln file and a bunch of .vcxproj files for my target build system (vs2017 -- Visual Studio 2017). The solution is set up the way I specified, with different configurations, platforms, compiler switches and so on.

Using Premake solves a number of problems I have:

- Visual Studio's GUI for modifying build settings is impressively bad, and the format for .sln and .vcxproj files is eye-destroying XML, so if you want to enable or disable a specific compiler flag, add or remove dependencies from the project, there's a lot that can go wrong. With Premake, I make changes to one easy-to-read Lua script, run the tool, and can get straight back to the real work. 
- As a result of the above problem, changing the way my solution/project is set up is a massive pain in the butt. With Premake it's so much easier to move files around, split things apart into sub-projects, etc.
- Eventually, I will be going cross-platform with this project and try to build it with a toolchain other than Microsoft's. With Premake I don't have to set up ten different kinds of build configurations for every different build system or IDE; people working on the project on different systems can just run Premake and get going.

Even though I'm only building files for one build system and not taking advantage of the cross-platform capabilities of Premake, I still make gains in that I no longer have to think about the settings of my various solutions and projects because Premake abstracts all that specific detail away.

Using Premake, it was pretty easy to do the long-overdue work of reorganizing files in my mess of a project. I'd go into the nitty-gritty of how I moved things around and set up my Premake script, but the details aren't that interesting. I wish I'd known enough about Premake to use it from the beginning and in past projects. Oh well[^2]!

[^1]: [Jeff Preshing](http://preshing.com) has written a couple of good-looking articles on getting started with CMake: [How to Build a CMake-Based Project](http://preshing.com/20170511/how-to-build-a-cmake-based-project/) and [Learn CMake's Scripting Language in 15 Minutes](http://preshing.com/20170522/learn-cmakes-scripting-language-in-15-minutes/).
[^2]: The list of 'Tools I Wish I'd Picked Up Years Ago' is getting pretty long.