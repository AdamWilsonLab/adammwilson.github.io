---
layout: page
title: Copy all the files in a directory to a new directory using R
teaser: ""
categories: blog
tags: [blog, r]
comments: true
mathjax: null
featured: false
published: true
---

Someone asked me how to move a directory full of files from one place to another using R. The easiest way I've found is as follows (where `oldpath`; is the existing directory and `newpath`; is the new directory):

```r
 file.copy(list.files(oldpath),newpath)
```
