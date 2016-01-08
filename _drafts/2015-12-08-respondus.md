---
layout: page
title: Installing Responds 4.0 on a Mac with wine
teaser: "Seems to work!"
categories: blog
tags: [web]
comments: true
published: true
---


Respondus is a windows-only program used to generate tests.  I've successfully installed it on OS X using the following procedure:

Download `Respondus4Campus.exe ` from your university (if you have a site license).

```
brew install wine
brew install winetricks
winetricks dlls mfc42
wine Respondus4Campus.exe 
wine ~/.wine/drive_c/Program\ Files/RespondusCampus40/Respond.exe
```

I haven't tested all the features, but so far, so good!

![](images/posts/respondus.png)


