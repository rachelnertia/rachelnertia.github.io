---
title: Object Factory but with a Lambda
layout: post
category: Programming
tags: [ C++ ]
comments: true
---

First, a quick disclaimer: I don't know what I'm doing. What I do know is that what I'm doing *kind of works*, which at the moment is enough to keep me going.

I'm going for a component system with my current side project[^1], which is where your Entity class is kind of just an empty bundle of pointers to Components of different kinds. The Entity itself is stateless and behaviourless; all of the state and behaviour belongs to the Components.

The Unity engine's GameObject is a pretty good example of what I'm talking about. A Unity GameObject is just a container pointers to components of all different kinds, like a MeshRenderer and a RigidBody and a Script. Together, these components define the state and behaviour of the GameObject, while the GameObject exists only to collect and connect these components together and to own a Transform which gives it a position and rotation in the world.

In my little prototype C++ game engine, an Entity is just:

- A pointer to a PhysicsComponent, which connects the Entity to the physics engine,
- A pointer to a RenderComponent, which defines how the Entity is to be drawn,
- And a pointer to an InputComponent, which defines how the object behaves.

The first two need to be non-null (at the moment), while the third is optional. Every object has a physical form of some sort and a visual form of some sort, but it might not have any actual behaviour worth defining.

This is what the Component base class looks like:

```cpp
class Component {
public:
  Component(Entity* entity) : mEntity(entity) {}
  Entity* GetEntity() { return mEntity; }
private:
  Entity* mEntity = nullptr;
};
```

Components need to point back to the Entity that owns them.

When I want to create an Entity with behaviour, I create a class that inherits from InputComponent, which is pure virtual. Maybe it's called "Player". I write some code which defines what that InputComponent does to add behaviour to the Entity it's attached to. I instantiate this class and point it at an Entity. Easy.

Then I write another InputComponent subclass. And another. And another. Keeping track of all these InputComponents becomes a chore. And of course, I want to be able to serialize and deserialize levels, which means serializing and deserializing Entities, which means serializing and deserializing InputComponents.

Maybe the deserialization code just ifs on the type string, like this:

```cpp
// Heck yeah, nlohmann::json! (I devoted an entire blog post to it, go check it out.)
nlohmann::json inputComponentJson = entityJson["InputComponent"];
if (inputComponentJson["Type"] == "Player") {
  // Instantiate Player. Go through the rest of the fields in inputComponentJson
  // and fill out the Player's members. Maybe doing that part is handled
  // by a method of Player.
} else if (inputComponentJson["Type"] == "Dragon") {
  // Instantiate a Dragon...
}
```

This kinda sucks! The deserialization code needs to know about all the possible types of InputComponent at compile time. What if we want to define new types of InputComponent in a scripting language, or just as part of a dynamically-loaded C++ library. Either way, the new types will be loaded in at runtime, so this code won't recognise them at all.

Which means I want *introspection*. Each InputComponent type needs to come with a set of knowledge about what it's called (a string), and how to instantiate it (a 'factory'). This sort of thing is built into many languages (e.g. C#), but not C++, because it's kind of a slow thing to just have switched on by default.

So, factories! I couldn't remember what the factory pattern was, so I looked it up. This [blog post by Guillaume Chereau](https://blog.noctua-software.com/object-factory-c++.html) is good.

> In this post I am going to talk about a little trick that I found very useful when dealing with a lot of subclasses of a single base class. This is typically what we see in video game, where we have a base Object class that represents any kind of object in the game, and then one subclass for each type of object, like the player, enemies, etc.

Okay. I'm finally getting to the actual part of this post that I sat down to write before I felt obligated to explain why I was talking about what I was talking about.

Guillaume presents this way to set up factory functions for subclasses: inherit from ObjectFactory, override the 'create' method, make the constructor register the instance with the global std::map of string type names and ObjectFactory pointers, instantiate a global instance of the ObjectFactory subclass. It's nice, so I'm copying it, but it makes you write out so much similar-ish code that he ends up using a macro so he can just write a single line:

```cpp
// Player.cpp
REGISTER_TYPE(Player)
```

So I'm changing it in my implementation, because macros are not good and I hate them. I have many reasons to feel this way! Fortunately, we live in the future now, and we have lambdas, and std::function, and we can *do it right* nowadays.

Here's my implementation:

```cpp
class InputComponent:
public:
class Factory {
public:
  Factory(const std::string typeName, std::function<InputComponent*(Entity*)> factoryFunc) {
    mFactoryFunc = factoryFunc;
    InputComponent::RegisterType(typeName, this);
  }
  InputComponent* CreateInputComponent(Entity* entity) {
    return mFactoryFunc(entity);
  }
private:
  std::function<InputComponent*(Entity*)> mFactoryFunc;
};
// ...
static std::map<std::string, Factory*> smFactories;
// ...
bool RegisterType(const std::string typeName, Factory* typeFactory) {
	if (smFactories.find(typeName) != smFactories.end()) {
		// Key already exists. User needs to call UnregisterType or something.
		return false;
	}

	smFactories[typeName] = typeFactory;

	return true;
}
// ...
InputComponent* Create(const std::string type, Entity* entity) {
  return smFactories[type]->CreateInputComponent(entity);
}
// ...
```

We don't need subclasses of Factory any more. We just instantiate a Factory, providing a name and a lambda.

```cpp
// Player.cpp
static InputComponent::Factory PlayerFactory(
  "Player",
  [](Entity* entity)->InputComponent*
  {
    return new Player(entity);
  }
);
```

Getting a list of the names of all the registered types is straightforward, too:

```cpp
unsigned InputComponent::GetTypeNames(std::vector<const char*>& v) {
  for (auto& kvp : smFactories) {
    v.push_back(kvp.first.c_str());
  }
  return v.size();
}
```

[^1]: I feel a bit weird about calling things 'side projects' but I guess it's accurate for as long as my 'main' project is what I'm developing at my day job.
