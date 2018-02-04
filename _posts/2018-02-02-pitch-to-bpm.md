---
title: Pitch to BPM
layout: post
category: Programming
tags: [ FMOD, music, maths, oldblogs ]
---

*Before this blog, I had another blog, and another blog before that blog, and so on until the beginning of time. At the moment I'm trying to dig up the best stuff I put on those old sites and re-post it here. This serves two purposes:*

- *Maybe some of this stuff is actually worth preserving.*
- *I get to put off writing actual new posts for a bit longer.*
 
*So here is a post I wrote in university, re-hashed a bit but otherwise unchanged.*

## Preamble

When we were making the musical platformer [*AMPS*](https://pack-of-wolves.itch.io/amps), I had a problem to solve.

Objects in the game world use a song’s beat like a clock. The song is a group of [FMOD](https://www.fmod.com/) Events which function as layers, all playing at once. We wanted to speed up the song and thus speed up the clock. The problem is that the `FMOD::Event` class[^1] doesn’t provide a method for changing the speed of playback. It does, however, provide `SetPitch` and `GetPitch` functions.

FMOD increases the pitch of audio tracks without worrying about smart pitch-shifting (no, I don’t know what the technique to increase pitch independently of tempo is actually called), so that increasing the pitch doesn’t just make the song sound higher, it makes it sound like it’s being played faster. Imagine making a record play faster than the RPM it’s meant to be played at.

So we can just modify the pitch to make it play faster or slower, but how do we keep our game objects in time with the beat of the song?

`Event::SetPitch` and `Event::GetPitch` measure pitch as follows: a pitch of **0.0** is the base pitch of the audio sample. Nothing has been altered about it. A pitch of **1.0** means the pitch has been shifted up by one pitch unit, and **-1.0** means it’s been shifted down by one pitch unit. Obviously.

What are “pitch units”? **Semitones, tones or octaves**. It depends what you pass to `Event::SetPitch` or `Event::GetPitch` as the second parameter. The options are `FMOD_EVENT_PITCHUNITS_SEMITONES`, `FMOD_EVENT_PITCHUNITS_TONES`, `FMOD_EVENT_PITCHUNITS_OCTAVES`. e.g.

`event->setPitch(new_pitch, FMOD_EVENT_PITCHUNITS_SEMITONES);`

I use semitones. There are 12 semitones in an octave, so the stuff below should be adaptable to not-using-semitones.

You need to know the base BPM (beats-per-minute) of the track you are pitch-shifting.

**Here’s the general formula to pitch up from 0.0 semitones to n semitones:**

`new BPM = base BPM * (2 ^ (n / 12))`

e.g. pitching up by a semitone…

`105 bpm * (2 ^ (1 semitone / 12)) = 111.24 bpm.`

…pitching down by a semitone:

`105bpm * (2 ^ (-1 semitone / 12)) = 99.11 bpm.`

Pitching up increases BPM more than pitching down decreases it, because pitch scales logarithmically.

## Additionally…

We’re using a ‘song-based delta-time’ for updating game objects. Normally the delta-time would be the time since the last frame, but in this case it’s the amount of time the song has progressed since the last frame, so basically the same thing. To account for music going faster or slower, we make world go faster or slower by multiplying this delta-time by a variable equal to `(new bpm / base bpm)`.

## BPM to Pitch

Where *m* is the number you’re multiplying the base BPM by to get the new BPM:

```
new pitch-shift amount (in semitones) = 12 * (ln(m) / ln(2))
new pitch-shift amount (in octaves) = (ln(m) / ln(2))
```

## Link dump:

- [http://www.fmod.org/questions/question/forum-17081]()
- THIS IS WRONG: [http://www.dummies.com/how-to/content/how-to-calculate-a-tunes-beats-per-minute-and-adju.html]()
- [http://www.thewhippinpost.co.uk/tools/tempo-pitch-calculator.htm]()

[^1]: We were using the FMOD Ex API, I think (?), but I can't find a reference online to link to. There is, however, [this article](https://www.fmod.com/resources/documentation-api?page=content/generated/overview/transitioning.html#/) about the differences between that API and more recent versions of FMOD.