---
title: Easy Arguments
layout: post
category: Programming
tags: [ C++ ]
comments: true
---

We've all been there. We learn about a new-ish C++ feature, we consider using it, we weigh our optimism against our wariness of falling into the "use *all* the features!" trap. We remember the sad times when we or others were a little too eager and back away nervously. Maybe another time, we say, retreating into the darkness -- it may be dark, but it's darkness you're familiar with.

The argument to adopt new-ish C++ features can be quite difficult, and for good reason. Sometimes the argument practically wins itself, though, in one simple, concise example. This post is about my current favourite.

<!--more-->

### Variadic Functions ###

C-style [varargs](http://en.cppreference.com/w/cpp/utility/variadic) are awkward to work with and unsafe in many ways, such as being completely typeless. Let's say you have a function that needs to branch based on the types of the arguments it's given. The classic example is some kind of `printf`: you pass a string, followed by a set of arguments to be formatted into that string. Without type introspection, it is necessary to find some other way to specify the types of the arguments. In the classic `printf`, this information is encoded by the programmer into the string argument.

```cpp
printf("One is %d and %s is 2", 1, "two");
// outputs: One is 1 and two is 2
```

This is not safe. If we mixed up our `%d` and `%s` there then we would probably crash the program. Some compilers feature enabled-by-default extensions that will warn/error you if they see this happening, but they are not obliged to.

So let's write a function that knows about the types of its varargs. First, we need some kind of wrapper that goes around values and stores information about their type:

```cpp
struct Arg
{
  enum class Type
  {
    Int,
    Float,
    Double,
    String
  };

  Arg(const int value) : m_Type(Type::Int), m_IntValue(value){};
  Arg(const float value) : m_Type(Type::Float), m_FloatValue(value){};
  Arg(const double value) : m_Type(Type::Double), m_DoubleValue(value){};
  Arg(const char* value) : m_Type(Type::String), m_StringValue(value){};

  Type m_Type;

  union {
    int m_IntValue;
    float m_FloatValue;
    double m_DoubleValue;
    const char* m_StringValue;
  };
};
```

We have some function that takes an array of Arg, and iterates through them, branching on each based on their m_Type.

```cpp
void DoThingsWithArgs(int numArgs, Arg* args) {
  // ...
}
```

But we don't want to force the user to build their own array of Args every time they want to use this function. We want the array-building to be handled automatically. Fortunately, this is quite straightforward.

```cpp
template <typename T0, typename T1, typename T3>
void DoThingsWithArgs(T0 a, T1 b, T2 c) {
  // none of the constructors for Arg have been marked
  // as explicit, so we can get away with this syntax
  Arg argArray[] = { a, b, c };
  // we put the non-template DoThingsWithArgs inside
  // a new namespace 'internal' to avoid confusion
  internal::DoThingsWithArgs(3, argArray);
}
```

What's going on here? We're using an initialiser list to construct an array of Args. As long as a constructor for Arg exists that can take type T0, T1 or T3, this will compile. If the user attempts to pass some type that isn't handled by Arg (e.g. a pointer to `int`) then compilation will fail. Type safety!

But we have a problem. We need to write one overload of `DoThingsWithArgs` for every possible number of arguments.

That is an infinite number of overloads.

```cpp
// one arg
template <typename T0>
void DoThingsWithArgs(T0 a) {
  Arg argArray[] = { a };
  internal::DoThingsWithArgs(1, argArray);
}
// two arg
template <typename T0>
void DoThingsWithArgs(T0 a, T1 b) {
  Arg argArray[] = { a, b };
  internal::DoThingsWithArgs(2, argArray);
}
// etc...
```

It doesn't have to be this way. Enter **variadic templates**!

```cpp
template <typename... Args>
void DoThingsWithArgs(Args... args) {
  Arg argArray[] = { args... };
  internal::DoThingsWithArgs(sizeof...(Args), argArray);
}
```

Here, `typename... Args` lets us specify an arbitrary number of types to a template. The list of types will be referred to as `Args`. We unroll this '[parameter pack](http://en.cppreference.com/w/cpp/language/parameter_pack)' to form the argument list of the function using `Args... args`.

Inside the function, writing `args...` evaluates to the list of actual arguments. For example, if we called `DoThingsWithArgs` like so:

```cpp
DoThingsWithArgs(1, 0.5, "hello");
```

`args...` would evaluate to:

```cpp
Arg argArray[] = { 1, 0.5, "hello" };
```

Finally, `sizeof...(Args)` returns the size of the parameter pack, and therefore the size of `argArray`.

This is all pretty neat, huh? And also hard to argue with. Once your toolchain has fully migrated to C++11, updating old code to use parameter packs instead of heavily-overloaded function templates should be a total no-brainer.

I hope you've found this blog post informative. If there's anything unclear or odd about it, let me know in the comments or on Twitter. Can you think of other good examples of new language features that old code should be upgraded to use?

Oh, and happy holidays!
