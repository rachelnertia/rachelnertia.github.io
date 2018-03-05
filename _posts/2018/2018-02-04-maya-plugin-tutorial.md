---
title: "Tutorial: Maya 2015 Plugin Development with Visual Studio"
layout: post
category: Programming
tags: [ Maya, C++, Visual Studio, oldblogs ]
---

*Another resurrected old post, I'm afraid. Hopefully it is still useful to somebody.*

<!--more-->

## The Simplest Possible Plugin

* Open Visual Studio. I’m using 2013, but this stuff ought to be transferable to other versions. With a bit of tweaking, anyway.
* Make a new empty project. Give it a nice, descriptive name.
* Add a new C++ source file called ‘hello_maya.cpp’
* Copy and paste this code into it: 

```cpp
#include <maya\MSimple.h>
#include <maya\MGlobal.h>
 
DeclareSimpleCommand(HelloMaya, "Rachel Crawford", "1.0";);
 
MStatus HelloMaya::doIt(const MArgList& args) {
    MGlobal::displayInfo("Hello Maya!");
    return MS::kSuccess;
}
```

* Open the project's properties.
* Open **Configuration Manager**, and set the active solution platform to **x64**.
* Under **General**:
    * Set **Target Extension** to **.mll**
    * Set **Configuration Type** to **‘Dynamic Library (.dll)’**
* Under C/C++:
    * Under **General**, in **Additional Include Directories**, put `Path\to\Maya2015\include`
    * Under **Preprocessor**, in **Preprocessor Definitions**, add `WIN32; NDEBUG; _DEBUG; _WINDOWS; NT_PLUGIN; REQUIRE_IOSTREAM; _USRDLL; MAYAPLUGIN1_EXPORTS;`
    * Under **Code Generation**, set **Runtime Library** to **‘Multi-threaded Debug DLL’**
* Under **Linker**:
    * Under **General**:
        * Set **Output File** to `$(OutDir)$(ProjectName).mll`
        * Set **Additional Library Directories** to `Path\to\Maya2015\lib`
    * Under **Input**, add these to **Additional Dependencies**: `Foundation.lib; OpenMaya.lib; OpenMayaUI.lib; OpenMayaAnim.lib; OpenMayaFX.lib; OpenMayaRender.lib; Image.lib; opengl32.lib;`
    * Under **Command Line**, in **Additional Options**, add `/export:initializePlugin /export:uninitializePlugin`

*Phew!* The hard part is over. Build your project and you should get a file called `‘$your_plugin_name.mll’`.

Now open Maya 2015. Navigate to **Window > Settings/Preferences > Plug-in Manager**. Scroll down the window to the bottom. Click **Browse** and navigate to and select your .mll file. Provided it loads correctly, it should appear in the Plug-in Manager window beneath “Other Registered Plugins”. **Check the ‘Loaded’ checkbox next to it.**

Now you should be able to just type `“HelloMaya”` into a MEL script or `maya.cmds.HelloMaya()` into a Python script and Maya will print `// Hello Maya! //` to the console.

So what does the code do? In Maya plugins, you create new commands as classes which inherit from the `MPxCommand` class. You create your class and give it a `creator` method and a `doIt` method. Then you write two functions, `initializePlugin` and `uninitializePlugin`, in which you register and unregister the new class with the Maya API. That’s a lot of busywork for a simple plugin which only adds a single custom command, though, which is why the `DeclareSimpleCommand` macro exists. It does everything except define the command’s `doIt` method, which is left up to you. The disadvantage is that it locks you in to having only one custom command in your plugin.

When you’re ready to move on, unload the plugin by un-checking ‘Load’ in the Plugin Manager. While the .mll is being used by Maya, we won’t be able to overwrite it with new versions of the plugin built by Visual Studio.

## Next Steps

Now we’ll expand on our work so far to create a good starting point for a plugin project.

Scrap the current version of `hello_maya.cpp` and bring in 3 new files: plugin_main.cpp, hello_maya.h, hello_maya.cpp. You can get the source code for these [here](https://bitbucket.org/snippets/r_crawford/b6nn). This time, instead of using the `DeclareSimpleCommand` macro we go the long way around and do all the things it does by hand.

If it builds and works, you can take a look at the code yourself and see how a budding plugin developer goes about making new commands to use in Maya. Good luck!

## Links:

- [http://www.chadvernon.com/blog/resources/maya-api-programming/your-first-plug-in/]()
- [http://www.chadvernon.com/blog/resources/maya-api-programming/introduction-to-the-maya-api/]()
- [http://www.chadvernon.com/blog/resources/maya-api-programming/introduction-to-dependency-graph-plug-ins/]()
- [http://www.chadvernon.com/blog/resources/maya-api-programming/]()