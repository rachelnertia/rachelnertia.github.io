---
title: "C++ Smart Pointers: They're Quite Good"
layout: post
category: Programming
---

The concept of the smart pointer is not particularly new, having probably existed for as long as `malloc` and `free` have been inspiring programmers to invent increasingly elaborate garbage collection systems instead of manually managing the heap memory they use. In fact it's quite easy to implement some form of smart pointer without realizing you're replicating the pattern. You write a class which wraps up a pointer to a dynamically-allocated block of memory. Maybe it prevents other parts of the codebase coming in and pointing that pointer at something else without freeing the memory. Maybe it calls `delete` on the pointer in the class' destructor. *Voila*. You've written a 'smart' pointer: an abstraction which automates resource management.

If this is all a bit alien to you, you might be fairly new to the C++ and still getting used to how pointers and manual resource management work in general. You also might not be up to speed on how the language standard has evolved in recent years. One nice evolution, one that I've only recently started taking advantage of myself, is that in modern C++ smart pointer class templates are available in the standard library.

`std::unique_ptr` helps with exclusive-ownership resource management. `std::unique_ptr<int> p(new int)` makes wrapper around a pointer to a dynamically-allocated `int`. Nobody else can point to that `int`, and certainly nobody else can delete it out from underneath `p`[^1]. When `p` goes out of scope and its destructor is called, it deallocates the `int`, so there's no memory leak, and you don't have to remember to call `delete`. The overhead of using a `unique_ptr` instead of a raw `int*`? Negligible. The maintainability overhead of using a raw pointer instead of a unique one? Definitely not negligible. This kind of smart pointer receives a big thumbs-up from me, and having a nice implementation right there in the standard library makes it hard to defend not making use of it[^2].

`std::shared_ptr`, on the other hand, is for shared-ownership resource management. Multiple `shared_ptr` instances can point to the same block of data without the programmer needing to worry about making sure nobody deletes it before everyone else has finished with it. In order to do this it introduces reference-counting into the mix, so this time, yes, there *is* some overhead. That overhead, however, is book-keeping you'd probably be doing anyway. When a `shared_ptr`'s destructor is called, the reference count variable it shares with the other `shared_ptr`s that point to the same resource is decremented. If the reference count hits zero, it calls `delete`.

There's one more. `std::unique_ptr` and `std::shared_ptr` have a scrawny sibling: `std::weak_ptr`. It acts like a `shared_ptr`, but doesn't participate in shared ownership. When pointed at an allocated block of memory, the weak pointer shares a reference count variable with any `shared_ptrs` that also point to that block. It doesn't modify the reference count; it just looks at it. This means it can tell when it's *dangling* - when it points at memory that's been freed - because the reference count is 0. Useful!  

The main takeaway here is that I like these things, and I think should too. Once you're used to them they are very useful tools. If you're still not convinced, my next post will demonstrate a use-case I found for `weak_ptr` in a spare-time project that might tip the scales.

[^1]: At least without writing purposefully bad code.
[^2]: In most circumstances.
