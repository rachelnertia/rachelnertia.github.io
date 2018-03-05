--- 
layout: post
title: Flappy Word 'Released'
comments: true
category: Game Dev
tags: [Flappy Word, Unity, C#]
---

<img style="float: right;" src="/images/flappy_word_v1_0.gif">

This news is about a month old by now, but: that's right, I'm 'done' with Flappy Word.

You can play a web build [here](https://googledrive.com/host/0B7qrbyhEE5SeRXE0ajFhQmh4aVk/) or on the [itch.io page](http://inertia.itch.io/flappy_word), where you can also download versions for Windows, Mac or Linux[^1].

<br>

### Things I learned

**1)** I think Unity's WebGL build target isn't quite *there* yet. [They've dropped the 'preview' label](http://blogs.unity3d.com/2015/12/07/unity-5-3-webgl-updates/) but all this really means is that it's now at a point where the Unity folks are willing to cover support tickets about it -- if you're a Premium or Enterprise user. It's still kind of laggy and outputs *enormous* files which the user has to download. I don't want to be too down on it but at least for the immediate future if I want to target HTML5/WebGL I'll probably just do it the 'hard' way and write some JavaScript[^2]. I'm sure it'll be good eventually.

**2)** Implementing the word-typing (you know, the main mechanic) taught me a fair bit.

**a)** Use [System.Enum.Parse](https://msdn.microsoft.com/en-us/library/system.enum.parse(v=vs.110).aspx) to convert between letters (chars) and key codes (enums) so you know which key the player should type next. I don't understand what magic this function is performing but it's very useful. 

**b)** I used [Resources](http://docs.unity3d.com/ScriptReference/Resources.html) for the dictionary file. I've no idea if this is the optimal way to handle big text-based data assets in Unity, but it was simple and I've found no reason to switch to any other method. 

{% highlight csharp %}
string dictionary = (Resources.Load("dictionary") as TextAsset).text;
{% endhighlight %}

**c)** This big huge string is parsed and broken up into an array of strings, which is then sorted for length. Sorting is nice and simple thanks to an anonymous [delegate](https://msdn.microsoft.com/en-gb/library/ms173171.aspx):

{% highlight csharp %}
words.Sort(
    delegate (string s1, string s2) {
        return s1.Length.CompareTo(s2.Length);
    }
);
{% endhighlight %}

Delegates are kind of analogous to [modern C++ lambdas](http://en.cppreference.com/w/cpp/language/lambda) (wee local function objects), with differences. They can't capture variables from their scope, but other methods can be 'assigned' to them (I don't think I understand what that actually means yet). 

**3)** Screen shake made the game feel better, but it introduced audio problems. I was using [AudioSource.PlayClipAtPoint](http://docs.unity3d.com/ScriptReference/AudioSource.PlayClipAtPoint.html), which had worked fine up until then as a quick throwaway audio clip solution, but now that the camera (and therefore listener) was jiggling about the 3D spatialisation was noticeable, and horrible. Detaching the Listener from the camera worked, but it still bothered me that I didn't have a method for just playing non-spatialised temporary audio clips.

{% highlight csharp %}
static public AudioSource PlayClip2D(AudioClip clip, float volume = 1.0f, 
	float pitch = 1.0f) 
{
    GameObject temp = new GameObject("TempAudio");
    AudioSource asource = temp.AddComponent<AudioSource>();
    asource.clip = clip;
    asource.spatialBlend = 0.0f; // Make it 2D
    asource.volume = volume;
    asource.pitch = pitch;
    asource.Play(); // Start the sound
    Destroy(temp, clip.length); // Destroy the object after clip duration.
    return asource;
}
{% endhighlight %}

So I had to write my own function which does EXACTLY what PlayClipAtPoint does but without the position and zeroing out the <code>spatialBlend</code> variable. Because the Unity scripting API doesn't have one for some reason.

**4)** Unity's UI stuff is cool. My UIController script sure as hell doesn't interface with it as gracefully as I'd like. That's something to improve upon next time.

**5)** Avoid having one big monolithic script that controls everything by factoring parts of it out into separate scripts as early as possible, even if you end up attaching them all to one 'controller' GameObject. It's just better that way. The mono-Monobehaviour I created was horrifying to work with until I refactored most of it out into new scripts.

Anyway, if I keep going I'll be writing for ages. This was a surprisingly educational project.

### Repository

I've decided to make the [Bitbucket repository](https://bitbucket.org/r_crawford/flappy-word) public. By NO means should any of the code within be imitated. It is all bad. Horrible and bad, but if you end up taking a look hopefully you can learn how not to do things. 

You could clone it, or you could just download the [full source in a zip file](https://www.dropbox.com/s/72k769m5jr741sc/flappy-word-v1-0-src.zip?dl=0).

[^1]: I don't know how well the Mac or Linux versions work because I can't test them. Let me know!
[^2]: Maybe try a framework/engine to help like [Phaser](http://phaser.io/) or [Superpowers](http://superpowers-html5.com/index.en.html).