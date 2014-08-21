---
layout: page
permalink: /photo/index.html
title: Photography
tags: [about,photo]
imagefeature: fieldwork.jpg
featured: true

---
 <figure>
  <img src="{{ site.url }}/images/ResearchOutline.png" alt="Research Outline">
  <figcaption>Research Outline</figcaption>
</figure>



## Photography related posts:
{% for post in site.tags.photo %}
   [{{ post.title }}]({{ post.url}})  _{{ post.date | date: "%B %d, %Y" }}_
{% endfor %}

