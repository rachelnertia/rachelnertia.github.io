---
title: Collections of References
layout: post
category: Programming
tags: [ C++ ]
comments: true
---

What does this code do?

```cpp
const auto it = FindByAddress(specialEntities, specialEntity);
```

In the game engine I'm working on, an Entity (or one of an Entity's components) can sometimes be in a state where it needs to have some extra processing done. Rather than having a branch in `Entity::Update`, we can just store a pointer to the Entity/Component in a container along with all the others that meet the same criteria. This is [existence-based processing](http://www.dataorienteddesign.com/dodmain/node4.html).

For example, RenderComponents can be in a state where they own a fixture (shape) in the physics world which needs to be rotated to face the camera before rendering happens (don't ask me why at the moment; it's complicated). We refer to these special RenderComponents as 'Flat Sprites', and keep track of all of them in a [`std::vector`](http://en.cppreference.com/w/cpp/container/vector) of pointers:

```cpp
std::vector<RenderComponent*> mFlatSprites;
```

It's safe to do this because RenderComponent instances are dynamically allocated and do not move around in memory.

Just before rendering, we call `RenderComponent::UpdateFlatSprite` on each of the instances pointed to by the pointers in the container, rotating their fixture to face the camera. When adding or removing a RenderComponent from the set of Flat Sprites, we can use [`std::find`](http://en.cppreference.com/w/cpp/algorithm/find) to check for whether the pointer we're trying to add or remove is already in the array:

```cpp
// flatSprite is of type RenderComponent*
const auto it = std::find(mFlatSprites.begin(), mFlatSprites.end(), flatSprite);
if (it != mFlatSprites.end())
  // the pointer was found in mFlatSprites
```

Easy! Yet, there's something a little bit smelly about all this: we're using pointers instead of references.

(In case you're unaware, [references in C++](https://www.tutorialspoint.com/cplusplus/cpp_references.htm) are just pointers with special semantics: they cannot (without coercion) point to null -- they must always point to an actual instance. They also behave syntactically like values, so you can act upon them as you would a normal instance using the `.` operator instead of the `->` operator (and dereference operator `*`) that you have to use with normal pointers.)

The problem with references is that this doesn't compile:

```cpp
std::vector<RenderComponent&> mFlatSprites;
```

This is [(partly)](http://stackoverflow.com/questions/1164266/why-are-arrays-of-references-illegal) because references **cannot be default-initialised**. That is, a reference must always be assigned a value in the place where it is initialised.

```cpp
// invalid:
SomeType& someTypeRef;
// valid:
SomeType someTypeInst;
SomeType& someTypeRef = someTypeInst;
```

But I *want* an array of references, because I want to represent the idea that elements can never be null. Fortunately, I can do this by writing a structure that 'wraps' a reference, and creating an array of that. I don't even have to write that wrapper myself, because it's already a template in the standard library: [`std::reference_wrapper`](http://en.cppreference.com/w/cpp/utility/functional/reference_wrapper).

```cpp
std::vector<std::reference_wrapper<RenderComponent>> mFlatSprites;
```

Stay with me now, because I'm closing in on the point of this post. This solution creates a new problem: what should the following code do?

```cpp
// flatSprite is of type RenderComponent&
const auto it = std::find(mFlatSprites.begin(), mFlatSprites.end(), flatSprite);
```

Should it compare the instance each element in the array refers to with that referred-to by `flatSprite`? Or should it compare the values of the underlying pointers involved -- the addresses at which the RenderComponents reside -- which is what I want?

Turns out the implementers of `std::reference_wrapper` didn't want to make that call for you, which is a good thing. The code does not compile because `bool operator==(const std::reference_wrapper<RenderComponent>, const RenderComponent&)` is undefined.

I could just write a definition for that operator myself and make it compare the addresses, but I decided not to. There may be cases down the line where I want that operator to compare the values rather than the addresses, and I want to make it explicit what I'm trying to do here. Finally we're back to that first line of code.

```cpp
const auto it = FindByAddress(specialEntities, specialEntity);
// except in this case it's actually:
const auto it = FindByAddress(mFlatSprites, flatSprite);
```

`FindByAddress` is defined like so:

```cpp
auto FindByAddress(
  const std::vector<std::reference_wrapper<RenderComponent>>& v,
  const RenderComponent& rc)
{
	for (auto it = v.begin(); it != v.end(); ++it)
	{
		const auto deref = *it;

		if (&deref.get() == &rc)
		{
			return it;
		}
	}

	return v.end();
}
```

Which we can make more generic by turning it into a template:

```cpp
template<typename T>
auto FindByAddress(
  const std::vector<std::reference_wrapper<T>>& v,
  const T& tRef)
```

In fact we could make it even more generic and not constrain it to only working with `std::vectors` by having it take two iterators, a *begin* and an *end*. Or, in the bright future, a [range](http://www.fluentcpp.com/2017/01/12/ranges-stl-to-the-next-level/). I'll leave that as an exercise for the reader.

I'll also leave as an exercise for the reader the task of pointing out mistakes I've made, or why an array of references is a bad idea, or generally letting me know what you think of the code I've shared here either on [Twitter](http://www.twitter.com/nershly) or in the comments below. Can I really refer to my cakes and eat them?

Shout out to [Elias Daler](https://twitter.com/EliasDaler/) for his recent [dev log](https://eliasdaler.github.io/re-creation-devlog-december-march/), which alerted me to the existence of reference wrappers and started all of this.
