---
title: Picking Easy Arguments
layout: post
category: Programming
tags: [ C++ ]
comments: true
---

We've all been there. We learn about a new-ish C++ feature, we consider using it, we weigh our optimism against our wariness of falling into the "*use all the features!*" pithole. We back away nervously. Maybe another time, we say, and retreat back into the darkness -- it may be dark, but after all, better the devil you know.

The argument to adopt recently-added C++ features can be quite difficult, and often this is the way it ought to be. Other times, however, the argument can be won in minutes.

### Variadic Functions ###

C-style [varargs](http://en.cppreference.com/w/cpp/utility/variadic) are awkward to work with and unsafe in many ways, including being completely typeless. Let's say you have a function that needs to branch based on the types of the arguments it's given. The classic example is some kind of `printf`: you pass a string, followed by a set of arguments to be formatted into that string. Without type introspection, it is necessary to find some other way to specify the types of the arguments. In the classic `printf`, this information is encoded by the programmer into the string argument.

```cpp
printf("One is %d and %s is 2", 1, "two"); // >> One is 1 and two is 2
```

This is not safe. If we mixed up our `%d` and `%s` there then we would probably crash the program. Some compilers feature enabled-by-default extensions that will warn/error you if they see this happening, but they are not obliged to.

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

```cpp
template <typename... Args> static void Append(const int msgId, const Args... args)
{
	Arg argArray[] = { args... };
	AppendLine(msgId, sizeof...(Args), argArray);
}
```

```cpp
static void Append(const int msgId) 
{ 
  AppendLine(msgId, 0, nullptr); 
}
template <typename T0> static void Append(const int msgId, T0 a)
{
	const int count = 1;
	Arg args[count] = { Arg(a) };
	AppendLine(msgId, count, args);
}
template <typename T0, typename T1> static void Append(const int msgId, T0 a, T1 b)
{
	const int count = 2;
	Arg args[count] = { Arg(a), Arg(b) };
	AppendLine(msgId, count, args);
}
template <typename T0, typename T1, typename T2> static void Append(const int msgId, T0 a, T1 b, T2 c)
{
	const int count = 3;
	Arg args[count] = { Arg(a), Arg(b), Arg(c) };
	AppendLine(msgId, count, args);
}
```

```cpp
if ((argCount > 0) && (args != nullptr))
{
	rw.BeginArray("args", nullptr);

	for (int i = 0; i < argCount; ++i)
	{
		Arg* arg = &args[i];

		switch (arg->m_Type)
		{
		case Arg::Type::Int:
			rw.WriteInt(nullptr, arg->m_IntValue);
			break;
		case Arg::Type::Float:
			rw.WriteFloat(nullptr, arg->m_FloatValue);
			break;
		case Arg::Type::Double:
			rw.WriteDouble(nullptr, arg->m_DoubleValue);
			break;
		case Arg::Type::String:
			rw.WriteString(nullptr, arg->m_StringValue);
			break;
		}
	}

	rw.End();
}
```
