---
title: Handling JSON with jsonhpp
comments: true
layout: post
category: Programming
tags: [ JSON, C++ ]
---

json.hpp is a single-header C++ library for handling JSON. It provides easy, clean ways to read from and write to JSON files.

Reading in JSON from a file is easy. Let's say we've got a file called 'data.json' which looks like this:

```json
{
  "info": {
    "name": "Rachel",
    "age": 22,
    "likesBacon": true
  }
}
```

We use a `std::ifstream` to feed the data to an instance of `nlohmann::json`:

```cpp
using json = nlohmann::json;
json j;
std::ifstream ifs("data.json");
if (!ifs.is_open()) {
  return false;
}
ifs >> j;
ifs.close();
```
