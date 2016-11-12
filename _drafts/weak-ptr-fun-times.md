---
title: "std::weak_ptr in action"
layout: post
category: Programming
---

In my last post I talked about how I am starting to use the C++ standard library's smart pointer templates in my own code and finding it quite pleasant. But all I did was name and gave brief descriptions of the three templates - `unique_ptr`, `shared_ptr` and `weak_ptr`. I didn't give any examples of them in use.

### One RenderComponent, One sf::Texture

In my game engine Entities are made up of Components. The PhysicsComponent connects it to the physical world. The RenderComponent describes how to
draw it. RenderComponents can have textures. 
