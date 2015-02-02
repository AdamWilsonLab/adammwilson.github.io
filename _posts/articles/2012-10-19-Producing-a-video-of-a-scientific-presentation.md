---
layout: post
title: "Producing a video of a scientific presentation"
description: "Using ffmpeg to create a 'picture-in-picture' recording'"
category: research
tags: [photo,research, blog, Open Source Software]
imagefeature: 
comments: true
share: true

---

I just uploaded a [video of my dissertation defense]() that includes a video of me talking and a 'screencast' of my slides.  The video was, of course, taken during the presentation itself, then I later played the video with mplayer while recording a screencast of the slides (advancing the slides at the appropriate times).  If you are curious, here's how I did it:

1. Start the screen/audio capture (it took a little fiddling to get the screen size right)
{% highlight bash %}
optirun ffmpeg -f alsa -ac 2 -i pulse -f x11grab -r 25 -s 1124*670 -i :0.0+50,98 -vcodec libx264 -acodec libfaac -ab 192k -preset ultrafast -threads 6 -y -sameq WilsonDefense.avi
{% endhighlight %}
2. Start the Video
{% highlight bash %}
mplayer -ss 1145 -noborder -geometry 190x110+10+650 -screenw 200 -screenh 500 defense/2011-12-16\ 14.06.20\ Adam\'s\ Defense.avi
{% endhighlight %}
3. Then go to your slides and advance them when the time comes.
4. To stop the screen capture, return your focus to the terminal and hit ctrl-c

Here is the result:

<iframe width="420" height="315" src="//www.youtube.com/embed/nI1Sfc6lwLE" frameborder="0" allowfullscreen></iframe>