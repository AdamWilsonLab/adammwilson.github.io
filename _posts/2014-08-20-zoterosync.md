---
layout: post
title: Syncing Zotero attachments via google drive
description: ""
categories: web
tags: [web]
comments: true
mathjax: null
featured: true
published: true
---

I use the wonderful Zotero reference manager but found two limitations:

1. [Zotero Storage](https://www.zotero.org/support/storage) is quite expensive ($60/year for 6GB).  Given that I'm already paying $120/year to Google Drive for 1TB, I'd rather use that storage directly.
2. They only support WebDaav backups which seem to be getting rarer and rarer.  Neither Dropbox or Google Drive currently support the WebDaav protocols.

So rather than fork over the dough, I simply moved the storage folder (not the full data directory with the database) to a google drive folder and created a symbolic link to it from within the Zotero data directory (following advice [here](https://zotpad.uservoice.com/knowledgebase/articles/103395-what-is-a-symbolic-link-and-why-should-i-use-one-w) and [here](https://forums.zotero.org/discussion/16827/standalone-dropbox-sync/)) like this:

```ln -s /Users/adamw/GoogleDrive/Work/papers/storage /Users/adamw/zotero/storage```

This simultaneously allows backing up the attachments to Google Drive and syncing attachments across computers/devices.  So far, so good....  