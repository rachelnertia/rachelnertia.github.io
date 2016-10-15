---
title: Object Factory but with a Lambda
layout: post
category: Programming
tags: [ C++ ]
comments: true
---

First, a quick disclaimer: I don't know what I'm doing. What I do know is that what I'm doing *kind of works*, which at the moment is enough to keep me going.

So, the Factory Method pattern! I need it for a thing. I couldn't remember what it was so I looked it up, which led me to [this informative and well-written blog post by Guillaume Chereau](https://blog.noctua-software.com/object-factory-c++.html).

> In this post I am going to talk about a little trick that I found very useful when dealing with a lot of subclasses of a single base class. This is typically what we see in video game, where we have a base Object class that represents any kind of object in the game, and then one subclass for each type of object, like the player, enemies, etc.

You should read it! Guillaume presents this nice way to set up factory functions for subclasses of Object: inherit from the ObjectFactory base class, override the 'create' method, make the constructor register the instance with the global [std::map]() of string type names and ObjectFactory pointers, instantiate a global instance of the ObjectFactory subclass. It's a nice way of doing things, so I'm copying it, but it makes you write out so much similar-ish code that he ends up using a macro so he can just write a single line:

```cpp
// Player.cpp
REGISTER_TYPE(Player)
```

Macros, in my experience, are a liability for generating mysterious or meaningless compiler errors or difficult-to-debug code, so I don't like having to rely on macros to reduce the amount of code I need to write or improve readability, so I started thinking of different ways to do it. What I came up with is binding a callback function. In my implementation, I'm giving std::function a whirl. Here's the general idea:

```cpp
class ObjectFactory {
public:
  Factory(const std::string typeName, std::function<Object*(Entity*)> factoryFunc) {
    mFactoryFunc = factoryFunc;
    InputComponent::RegisterType(typeName, this);
  }
  Object* CreateObject() {
    return mFactoryFunc();
  }
private:
  std::function<Object*()> mFactoryFunc;
};
class Object {
// ...
static std::map<std::string, ObjectFactory*> smFactories;
// ...
bool RegisterType(const std::string typeName, ObjectFactory* factory) {
	smFactories[typeName] = typeFactory;
	return true;
}
// ...
Object* CreateObject(const std::string typeName, Object* object) {
  return smFactories[type]->CreateObject(object);
}
// ...
};
```

We don't need subclasses of ObjectFactory any more, so we don't need to write as much code. We just instantiate an ObjectFactory, providing a name and a lambda.

```cpp
// Player.cpp
static ObjectFactory PlayerFactory(
  "Player",
  []()->Object*
  {
    return new Player();
  }
);
```

It's not quite as compact as <code>REGISTER_TYPE(Player)</code>, but you gain a lot of flexibility this way without having to go to the bother of writing out a big ObjectFactory subclass. You can bind more than just lambdas to std::functions: you can bind ordinary functions, member functions, any 'callable object'. One could use an alternative to std::function, like regular old function pointers, or roll your own callback wrapper, and maybe there's a performance gain to be made there. Compared to the way Guillaume does it, it's always going to be a tradeoff between virtual method calls and a slightly different kind of pointer-following.

On the other hand, I am not likely to be using my object factory thousands of times per frame, and the overhead of the map lookup outweighs the overhead of the function call. The Object Factory pattern is not for performance-critical situations, but for flexibility and decoupling.

As a final note: I'm using a std::unordered_map instead of a regular std::map because lookup is faster with an unordered_map. Iteration over the values is slower, but that is not what I'm going to be doing more of.
