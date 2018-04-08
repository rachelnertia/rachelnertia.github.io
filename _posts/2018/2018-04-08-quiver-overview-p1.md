---
title: "Quiver Overview: Entity Components"
layout: post
category: Game Dev
tags: [ Quiver, Quarrel, C++ ]
---

This post is the first in a series (hopefully) about the way Quiver, my homebrew game engine, currently works. Today I'll be talking about the different kinds of components an entity (game object) can be made up of. Note that I'll also be referring to something called 'Quarrel', which is a game I'm developing using the engine. All the code and assets for both Quiver and Quarrel are up on GitHub, so please feel free to [nose around](https://github.com/rachelnertia/Quiver).

Quiver makes use of the **Component** pattern, which is described well in [*Game Programming Patterns*](http://gameprogrammingpatterns.com/component.html). A quick summary would be: *instead of having a monolithic entity class, the entity class is just a container for instances of different 'component' classes*. The component classes implement the logic and store state for different domains, like graphics and physics. If you proceed down the Entity-Component path you might end up in the territory of what's known as the Entity-Component-System paradigm, in which Entities are made up of Components which interface with/are controlled by Systems. Eventually, the Entity [doesn't exist at all](http://www.dataorienteddesign.com/dodmain/node5.html#SECTION00540000000000000000) -- you just have IDs. However far you go, the motivation is the same: to use composition over inheritance, and design in a more data-oriented and multithreading-friendly way.

Quiver exists somewhere on the spectrum between the monolithic entity paradigm and the full-blown ECS paradigm. The Entity class owns a handful of instances of different Component classes, which are each responsible for representing the Entity in different domains, communicating with different game subsystems, and giving the Entity some state or behaviour.

Here is Quiver's Entity class, with everything but the member variables trimmed out:

```cpp
class Entity final {
	World& mWorld;
	
	EntityId mId;

	std::unique_ptr<PhysicsComponent> mPhysicsComponent;
	std::unique_ptr<RenderComponent>  mRenderComponent;	
	std::unique_ptr<AudioComponent>   mAudioComponent;
	std::unique_ptr<CustomComponent>  mCustomComponent;
};
```

It stores a reference to the World it is a part of. The World class represents a 'room' or 'level'. It owns all the Entities, who are addressable using an EntityId. The Entity also knows its own ID. Then it has owning pointers to its components, accessible to others in raw pointer form through getter methods. None of the Components are mandatory apart from the PhysicsComponent (which I am planning to make optional). All of them inherit from the Component class, which looks like this:

```cpp
class Component {
public:
	explicit Component(Entity& entity) : mEntity(entity) {}

	virtual ~Component() {}

	Entity& GetEntity() const { return mEntity; }

private:
	Entity& mEntity;
};
``` 

So all Components store a reference to the Entity they're a part of. If a RenderComponent wants to talk to the PhysicsComponent it does so like this:

```cpp
PhysicsComponent* physics = GetEntity().GetPhysics();
```

The *Game Programming Patterns* chapter describes a bunch of other ways that entity components can communicate with each other, but simply allowing them to call methods on each other is good enough for now, and far, far easier than implementing e.g. some kind of event system.

### Physics Component

This one owns and manages the Entity's physical body. If you want to push the Entity around, or change what things it collides with, you talk to its PhysicsComponent.

### Render Component

This one is responsible for updating the Entity's visual representation. Its API contains methods for changing the Entity's colour, texture, and talking to the animation system. I might rename it to 'GraphicsComponent'.

### Audio Component

This one is a bit of a stub at the moment as I haven't had a reason to develop it much, but as you'd expect it manages any sounds the Entity might be making. For example: enemies in Quarrel make a noise when they shoot, so the AudioComponent does that.

### Custom Component

This is where the engine code allows game programmers to inject behaviour into Entities. Want an Entity to move around on its own? Write a class that inherits from CustomComponent, override the OnStep method to make it do what you want, then attach an instance of your new class to the Entity as its CustomComponent. I want to make it possible to have more than one CustomComponent on an Entity at once, but I'm managing to work around the restriction at the moment in Quarrel so there's no rush.

And that's it for this quick introduction. I'll probably go into more detail on each Component type in future blog posts, but for now you at least have a basic understanding of what a game object looks like in Quiver.