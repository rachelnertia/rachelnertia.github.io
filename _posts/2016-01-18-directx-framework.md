---
layout: post
title: DirectX 11 Framework
category: Programming
tags: [C++, Honours Project, DirectX, graphics programming, ImGui]
---

This post is about the framework code I've written as part of my Honours project application. The aim of the framework is to make working with DirectX 11 as painless as possible. I won't actually discuss anything about my project in it. The framework will expand as the project goes on, hopefully blossoming into something other people might consider using, so taking stock when it's in its most simple form is a pretty worthwhile blog post.

## The Window

![](/images/directx_framework_window_01.png "Busy bees, just like me.")

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

	window.Clear(); // clear to black
	window.Bind(); // prepare to render

	// ... draw objects here ...

	window.Display(); // flip buffers
}
{% endhighlight %}

The <code>dxf::Window</code> manages the application's DirectX device and a bunch of other DirectX objects which it creates, like a swap chain and render target[^1]. <code>Window::Create()</code> sets up DirectX and the destructor cleans everything up, so the Window is the first thing an application using this framework needs to create before it gets on with important things.

## Shaders

Currently there's only vertex and pixel shaders. Setting up shaders is straightforward.

{% highlight cpp %}
// Set up the simple vertex shader.
dxf::VertexShader simple_vs;
simple_vs.Create(m_window->GetDevice(), "shaders/simple_vs.hlsl", "main"));
{% endhighlight %}

This finds the shader code file and compiles it 

Vertex shaders are special because they have an <code>ID3D11InputLayout*</code> associated with them. I used to have to set these up manually by filling out an array of <code>D3D11_INPUT_ELEMENT_DESC</code> structs and calling <code>ID3D11Device::CreateInputLayout</code>, which necessitates a tonne of pointless bespoke code which is a chore to write and easy to mess up[^2]. Now, though, I use black magic in the form of shader reflection to automatically generate the input layout object as demonstrated [here](https://takinginitiative.wordpress.com/2011/12/11/directx-1011-basic-shader-reflection-automatic-input-layout-creation/) (thanks, Bobby Anguelov!), which eases the process greatly. I'm wondering what else I could do with shader reflection.

When it's time to render, you just <code>Bind</code> the shader to the device context along with all the other objects.

There's objects associated with shaders, too, such as Textures, Samplers, and ConstantBuffers, all currently rather skeletally implemented. I'm working on features as I come to need them.

## Meshes

The Mesh class manages vertex and index buffers. Currently I don't handle non-indexed meshes. To create a mesh (in this case, an indexed quad):

{% highlight cpp %}
dxf::Mesh mesh;

unsigned quad_indices[6];
quad_indices[0] = 0; // bottom left
quad_indices[1] = 1; // top left
quad_indices[2] = 2; // top right
quad_indices[3] = 0; // bottom left
quad_indices[4] = 2; // top right
quad_indices[5] = 3; // bottom right

// Pass in the device, a pointer to the first index, and how many indices
// there are.
mesh.SetIndices(window->GetDevice(), quad_indices, 6);

// This structure should match up with the input structure used in the vertex 
// shader the mesh is rendered with otherwise weird not good things will happen.
struct Vertex {
	D3DXVECTOR3 position;
};

Vertex quad_verts[4];
quad_verts[0].position = D3DXVECTOR3(0.0f, 0.0f, 0.0f); // bottom left
quad_verts[1].position = D3DXVECTOR3(0.0f, 1.0f, 0.0f); // top left
quad_verts[2].position = D3DXVECTOR3(1.0f, 1.0f, 0.0f); // top right
quad_verts[3].position = D3DXVECTOR3(1.0f, 0.0f, 0.0f); // bottom right

// Pass in the device, a pointer to the first vertex, the size of each vertex, and
// how many vertices there are.
mesh.SetVertices(window->GetDevice(), &quad_verts[0], sizeof(quad_verts[0]), 4);

{% endhighlight %}

This abstracts away nitty-gritty DirectX code, which is nice.

Actually rendering the mesh isn't quite the way I'd like it yet. I'd like the verbs to be something like 'render [mesh] to [target]' where target is an instance of some kind of RenderTarget class. For now the process is:

{% highlight cpp %}
mesh.Bind(window->GetContext());
mesh.Draw(window->GetContext());
{% endhighlight %}

## ImGui

There's more to talk about but I'll finish for now by talking about the GUI layer.

[ImGui](https://github.com/ocornut/imgui) is where that nifty little 'Test' window comes from. ImGui is *rad*, and I wouldn't know about it if not for a news post on Gamasutra a few months ago. I've not used it extensively yet so there might be drawbacks I've not yet spotted, but for my debug UI purposes it looks like the best option there is [^3].

ImGui doesn't do any rendering. You send it commands, it constructs lists of vertices, and you handle the rendering. You don't even need to worry too much about how to do that, because there are examples which show how to write a renderer for DirectX, OpenGL or another environment which you can just copy into your codebase.

Example: 

![](/images/imgui_window.png)

{% highlight cpp %}
bool b = true;
ImGui::Begin("Test Window", &b);
	ImGui::Text("Hello");
ImGui::End();
{% endhighlight %}

ImGui is haphazardly integrated with the rest of my program at the moment and doesn't yet make use of my useful framework code, so tidying that up is definitely a thing I want to do in the weeks ahead.

Next steps: actually implementing Honours project stuff...

[^1]: I'm planning to factor the render target out into a separate class which the Window will own an instance of. It'll be possible to render to any given 'RenderTarget', then render *that* to the Window's back buffer RenderTarget. All this might not be completely possible.

[^2]: I tried some really horrible ways of getting around writing that annoying repetitive input layout code before I happened upon shader reflection. 

[^3]: I encountered a few problems while setting it up which I will try to write about (later) so that other people have a less frustrating time.
