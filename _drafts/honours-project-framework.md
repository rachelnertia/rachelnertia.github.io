---
layout: post
title: framework
---

This is partly a progress update on the application I'm making for my Honours project but mostly me talking about the framework I'm using to make it, which now has all of its basic features in place. It'll expand as the project goes on, so taking stock when it's in its most simple form is a pretty worthwhile blog post.

## The Window

![](/images/directx_framework_01.png "Busy bees, just like me.")

Window management works like it does in [SFML](http://www.sfml-dev.org/). Sort of. That's the goal, anyway.

{% highlight cpp %}
dxf::Window window;
window.Create(640, 480, "DirectX Window");

while (window.IsOpen()) { // application main loop
	dxf::WindowEvent event;
	while (.window.PollEvent(event)) { // event processing loop
		switch (event.type) {
		case dxf::WindowEvent::Closed:
			window.Close();
			break;
		default:
			break;
		}
	}

	window.Clear();
	window.Bind(); // prepare to render

	// ... draw objects here ...

	window.Display(); // flip buffers
}
{% endhighlight %}

The <code>dxf::Window</code> manages the application's DirectX device and a bunch of other DirectX objects which it creates, like a swap chain and render target[^1]. <code>Window::Create()</code> sets up DirectX and the destructor cleans everything up, so the Window is the first thing an application using this framework needs to create before it gets on with important things.

## ImGui

[ImGui](https://github.com/ocornut/imgui) is where that nifty little 'Test' window comes from. ImGui is *rad*, and I wouldn't know about it if not for a news post on Gamasutra a few months ago. I've not used it extensively yet so there might be drawbacks I've not yet spotted, but for my debug UI purposes it looks like the best option there is [^2].

ImGui doesn't do any rendering. You send it commands, it constructs lists of vertices, and you handle the rendering. You don't even need to worry too much about how to do that, because there are examples which show how to write a renderer for DirectX, OpenGL or another environment.

Example: 

![](/images/imgui_window.png)

{% highlight cpp %}
bool b = true;
ImGui::Begin("Test Window", &b);
	ImGui::Text("Hello");
ImGui::End();
{% endhighlight %}

ImGui is haphazardly integrated with the rest of my program at the moment and doesn't yet make use of my useful framework code, so tidying that up is definitely a thing I want to do in the weeks ahead.

[^1]: I'm planning to factor the render target out into a separate class which the Window will own an instance of. It'll be possible to render to any given 'RenderTarget', then render *that* to the Window's back buffer RenderTarget. All this might not be completely possible.

[^2]: I encountered a few problems while setting it up which I will try to write about so that other people have a less frustrating time.
