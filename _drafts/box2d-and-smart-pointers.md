---
layout: post
category: programming
tags: [ C++ ]
comments: true
---

I've [written in the past]({% post_url 2016-11-12-intro-to-smart-ptrs %}) about standard-library smart pointers and how they can make management of memory allocated from the heap much easier. How useful are they when working with objects allocated from elsewhere?

[Box2D](http://box2d.org/) is a popular 2D physics engine. In it, the [`b2World`](http://www.learn-cocos2d.com/api-ref/1.0/Box2D/html/classb2_world.html) is the top-level object that represents the physics 'world'. Physics entities are represented by instances of [`b2Body`](http://www.learn-cocos2d.com/api-ref/1.0/Box2D/html/classb2_body.html), that are created like so:

```cpp
// world is a b2World*
// bodyDef is a b2BodyDef that describes the properties of the new body
b2Body* body = world->CreateBody(&bodyDef);
```

The `b2World` owns the `b2Body` and the memory it is created from, and when the world is destroyed it destroys all the bodies it contains. To remove an individual body and free its memory we call `b2World::DestroyBody(b2Body*)`.

This creates a small challenge for us when we build our game code on top. Let's say we have an `Entity` class, which has a `b2Body*`` member.

```cpp
class Entity {
  b2Body* body;
};
```

In `Entity`'s destructor we may want to do something like this:

```cpp
Entity::~Entity() {
  if (body) body->GetWorld()->DestroyBody(body);
}
```

When an `Entity` goes out of scope, it tells the `b2World` to remove its body from the world.

These are as close to unique ownership semantics as we're gonna get, so we could make `body` a `std::unique_ptr` rather than a raw pointer. Let's try it!

```cpp
std::unique_ptr<b2Body> bodyPtr = world->CreateBody(&bodyDef);
```
Unfortunately, this is no good. By default, `std::unique_ptr`'s destructor calls `delete` on its internal pointer, which isn't what we want. The `b2World` is who really owns the memory, so deleting it out from underneath it would probably cause undefined behaviour down the line, if not immediately. The memory which the `b2World` allocates bodies etc. from may be a [pool](https://en.wikipedia.org/wiki/Memory_pool) block-allocated from the heap, or might not even come from the heap, it may be on the stack, so calling `delete` on it would not go down well.

### Custom Deleters

[`std::unique_ptr`](http://en.cppreference.com/w/cpp/memory/unique_ptr) has more than one template parameter.

```cpp
template<class T, class Deleter = std::default_delete<T>> class unique_ptr;
```

The first is the type to which it points, and the second allows the user to define a *custom deleter*. A custom deleter must be a type with an operator that takes a pointer to `T`. The custom deleter lets us define what `unique_ptr`'s destructor does.

Here is a pointless example of one that just does the same as the default deleter:

```cpp
struct b2BodyDeleter {
  void operator()(b2Body* body) const {
    delete body;
  }
};

std::unique_ptr<b2Body, b2BodyDeleter> bodyPtr = world->CreateBody(&bodyDef);
```

Obviously this isn't what we need because we need to call `b2World::DestroyBody`.

### Gotcha

You might be wondering why we can't just use a regular ol' free function for this. Here's why.

```cpp
void b2BodyDeleter(b2Body* body) {
  delete body;
}

using BodyPtr = std::unique_ptr<b2Body, b2BodyDeleter> bodyPtr;
```

`BodyPtr` doesn't compile because the second template parameter we've provided is not a type. Using [decltype](http://en.cppreference.com/w/cpp/language/decltype) and a `&` we can proceed:

```cpp
using BodyPtr = std::unique_ptr<int, decltype(&b2BodyDeleter)>;
```

`decltype(&b2BodyDeleter)` gives us the type of a pointer to the `b2BodyDeleter` function. However, when we try to instantiate `BodyPtr` we hit a snag -- the class doesn't have a default constructor anymore, and must be constructed with a pointer to `b2BodyDeleter` (or any function with a matching signature, actually).

```cpp
BodyPtr body; // Doesn't compile!
BodyPtr body(world->CreateBody(&bodyDef), &b2BodyDeleter); // Does compile!
```

Unfortunately, `BodyPtr` is no longer a zero-cost abstraction as it now consists of both a pointer to a `b2Body` and a function pointer.

```cpp
static_assert(sizeof(BodyPtr) == sizeof(b2Body*)); // Fails!
```

If we instead use a functor like our original `b2BodyDeleter` then the [empty base class optimization](http://en.cppreference.com/w/cpp/language/ebo) allows `unique_ptr`'s size to equal the size of a raw pointer. When using a function pointer our smart pointer becomes *stateful*, meaning it carries additional stuff along with its underlying raw pointer. This is a bit of a [gotcha](https://en.wikipedia.org/wiki/Gotcha_(programming)), and arguably things shouldn't have to be this way (i.e. we shouldn't need to use a function pointer but instead refer to the free function some other way), but writing a functor or a lambda to avoid this isn't too much bother.

### b2BodyDeleter

So finally here's our real `b2BodyDeleter`:

```cpp
struct b2BodyDeleter {
	void operator()(b2Body* body) const {
    body->GetWorld()->DestroyBody(body);
  }
};

using BodyPtr = std::unique_ptr<b2Body, b2BodyDeleter>;

static_assert(sizeof(BodyPtr) == sizeof(b2Body*));

BodyPtr body = world->CreateBody(&bodyDef);
```

We had a choice here. Instead of accessing the `b2World` using `b2Body::GetWorld` we could store a `World*` (or `World&`) in `b2BodyDeleter`, setting it in the constructor. That doesn't really bring any advantages that I can think of, though.

Now we can swap `Entity`'s raw `b2Body` pointer for a `BodyPtr`, and we never have to worry about manually calling `b2World::DestroyBody` for the Entity's body again. The body will be removed from the world when the `Entity` goes out of scope.

There are limitations to doing things this way: an `Entity` now *must* go out of scope before the b2World does, otherwise `b2Body->GetWorld` will return a dangling pointer. We can no longer destroy the `b2World` before all the `Entity` instances who are using it unless we call `release` on each `Entity`'s `BodyPtr` before its destructor is called.

This example may seem like a bit of a strawman to you, but in my homebrew game engine switching from using raw `b2Body` pointers to smart ones has been a big improvement. It fits into my [RAII](http://en.cppreference.com/w/cpp/language/raii)-based approach to just about everything.

### Further Reading

[Fluent C++](https://www.fluentcpp.com) did a series about smart pointers recently, with a few posts dedicated to custom deleters:

- [Custom deleters](https://www.fluentcpp.com/2017/08/29/custom-deleters/)
- [How to Make Custom Deleters More Expressive](https://www.fluentcpp.com/2017/09/01/make-custom-deleters-expressive/)
- [Changing deleters during the life of a unique_ptr](https://www.fluentcpp.com/2017/09/05/changing-deleters-during-the-life-of-a-unique_ptr/)
