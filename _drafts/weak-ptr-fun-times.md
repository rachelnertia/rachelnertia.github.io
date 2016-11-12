---
title: "std::weak_ptr in action"
layout: post
category: Programming
---

In my last post I talked about how I am starting to use the C++ standard library's smart pointer templates in my own code and finding it quite pleasant. But all I did was name and gave brief descriptions of the three templates - `unique_ptr`, `shared_ptr` and `weak_ptr`. I didn't give any examples of them in use.

### One RenderComponent, One sf::Texture

In my game engine Entities are made up of Components (a common [design pattern](http://gameprogrammingpatterns.com/component.html)). The PhysicsComponent connects it to the physical world. The RenderComponent describes how to draw it. RenderComponents can have textures. For now all my rendering code makes use of SFML's graphics library, so RenderComponents make use of textures through sf::Texture objects.

Initially, I'm willing to take the simplest course of action: RenderComponent has a sf::Texture member.

```cpp
class RenderComponent {
  sf::Texture mTexture;
};
```

When I want to use the texture, I call `mTexture.loadFromFile("example.png")` and continue on my way.

Advantages include:

- When the RenderComponent is deallocated, so is the sf::Texture, along with the actual texture data that might have been loaded onto the GPU's memory with `loadFromFile`.

Disadvantages include:

- Wasteful of main memory. sf::Texture has many members, most of which we will not touch, so those will make RenderComponent significantly larger.
- Wasteful of GPU memory. If two RenderComponents use example.png, two copies of it will be sitting in memory. This would also be wasteful of main memory because the sf::Textures would be identical too.

I can solve the first disadvantage by having RenderComponent own a pointer to an sf::Texture instead.

```cpp
class RenderComponent {
  sf::Texture* mTexture = nullptr;
};
```

Nice. When I want the RenderComponent to be textured, I allocate a `new sf::Texture` and call `loadFromFile` with it. Now I have to remember to call `delete` at some point, and I might screw up by exposing the pointer to outside bits of code, who might deallocate the memory or modify the pointer. Hence:

```cpp
class RenderComponent {
  std::unique_ptr<sf::Texture> mTexture;
};
```

Those insecurities are now nicely stitched up. Unfortunately, I'm still worried about being wasteful of space when multiple RenderComponents are using the same texture.

### Multiple RenderComponents, One sf::Texture

You could accomplish this in a bunch of ways. Here's one that takes advantage of smart pointers to minimize book-keeping and waste. First, I give RenderComponent a `shared_ptr` so that it can participate in shared ownership of an sf::Texture with other objects.

```cpp
class RenderComponent {
  std::shared_ptr<sf::Texture> mTexture;
};
```

When I want to set the texture to example.png, I need a way of knowing if there is already a dynamically-allocated sf::Texture somewhere out there that's been loaded with example.png. Enter the TextureLibrary class. The TextureLibrary, which all RenderComponents share an instance of, keeps track of all that for me. Setting the RenderComponent's texture is a matter of writing `mTexture = sTextureLibrary.LoadTexture("example.png")`, and I'm guaranteed not to be creating a duplicate. When no RenderComponents are using example.png, it will be automatically deallocated.

TextureLibrary needs to know about the reference counts of the sf::Textures it oversees without modifying them. A perfect fit for `std::weak_ptr`.

```cpp
class TextureLibrary
{
private:
  // Map of {filename, texture} key-value pairs.
  std::unordered_map<std::string, std::weak_ptr<sf::Texture>> mLoadedTextures;
public:
  std::shared_ptr<sf::Texture> LoadTexture(std::string filename)
  {
    // Cast filename to all-lower case.
    std::transform(filename.begin(), filename.end(), filename.begin(), ::tolower);

    // Check if the filename has already been loaded.
    if (mLoadedTextures.find(filename) != mLoadedTextures.end())
    {
      // Make sure the weak_ptr is not dangling before we create a new reference.
      if (!mLoadedTextures[filename].expired()) {
        return mLoadedTextures[filename].lock();
      }
    }

    // There is no sf::Texture using this file. Create a new one.
    std::unique_ptr<sf::Texture> temp(new sf::Texture);

    if (temp->loadFromFile(filename)) {
      std::shared_ptr<sf::Texture> shared(temp.release());
      mLoadedTextures[filename] = shared;
      return shared;
    }

    return nullptr;

    // If loadFromFile failed, temp will go out of scope here and delete itself.
  }
};
```

Elegant, concise and safe. There are definitely drawbacks - a little reference-counting overhead here and there - but for now I think the benefits of this system outweigh the costs. I'll continue to redesign  systems to make use of standard library smart pointers, and reap the benefits.
