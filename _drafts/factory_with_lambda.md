---
title: Object Factory but with a Lambda
layout: post
category: Programming
tags: [ C++ ]
comments: true
---

The Factory Method pattern! I need it for a thing. I needed to use it but I needed an example, and my search led me to [this informative and well-written blog post by Guillaume Chereau](https://blog.noctua-software.com/object-factory-c++.html). You should read it!

> In this post I am going to talk about a little trick that I found very useful when dealing with a lot of subclasses of a single base class. This is typically what we see in video game, where we have a base Object class that represents any kind of object in the game, and then one subclass for each type of object, like the player, enemies, etc.

Guillaume presents this nice way to set up factory functions for subclasses of Object: inherit from an ObjectFactory base class, override the 'create object' method, make the constructor register the instance with the global [std::map](http://en.cppreference.com/w/cpp/container/map) of string type names and ObjectFactory pointers, instantiate a global instance of the ObjectFactory subclass. It's a nice way of doing things, but it makes you write out so much similar-ish code that he ends up using a macro so he can just write a single line:

```cpp
// Player.cpp
REGISTER_TYPE(Player)
```

Macros, in my experience, are a liability for generating mysterious compiler errors and difficult-to-debug code. I don't like having to rely on them to reduce code duplication or improve readability, so I started thinking of different ways to do it. What I came up with is basically binding a callback function. In my implementation, I'm giving [std::function](http://en.cppreference.com/w/cpp/utility/functional/function) a whirl. Here's the general idea:

```cpp
class ObjectFactory {
public:
  Factory(const std::string typeName,
          std::function<Object*(Entity*)> factoryFunc)
  {
    mFactoryFunc = factoryFunc;
    Object::RegisterType(typeName, this);
  }
  Object* CreateObject() {
    return mFactoryFunc();
  }
private:
  std::function<Object*()> mFactoryFunc;
};

class Object {
static std::map<std::string, ObjectFactory*> smFactories;
public:
bool RegisterType(const std::string typeName, ObjectFactory* factory)
{
  smFactories[typeName] = typeFactory;
  return true;
}
Object* CreateObject(const std::string typeName, Object* object) {
  return smFactories[type]->CreateObject(object);
}
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

It's not quite as compact as <code>REGISTER_TYPE(Player)</code>, but you gain a lot of flexibility this way without having to go to the bother of writing out a big ObjectFactory subclass when you want to do something a bit different. Or compromise morally by using macros. You can bind more than just lambdas to std::functions: you can bind ordinary functions, member functions, any callable target.

One could use an alternative to std::function, as there are tradeoffs to consider, but this works for me, for now. I'm not likely to be using my object factory thousands of times per frame, and I bet the map lookup time outweighs the overhead of the function object call. The Object Factory pattern is not meant to be used in performance-critical situations, but for situations where flexibility and decoupling are desired. At any rate, in this instance it's a tradeoff between virtual method calls and a slightly different kind of pointer-following. It's always gonna suck.

As a final note: I'm actually using a [std::unordered_map](http://en.cppreference.com/w/cpp/container/unordered_map) instead of a regular std::map because apparently lookup by key is faster with an unordered_map. Iteration over the values is slower, but that's not what I'm going to be doing more of.
