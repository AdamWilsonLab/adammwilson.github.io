---
layout: page
permalink: /publications/index.html
title: Publications
tags: [about,research]
image:
 feature: WilsonAdam_20100729_9935_v2.jpg
featured: true

---

C.V.
<figure>
	<a href="{{ site.url }}/files/Wilson_Adam_CV.pdf" ><img src="{{ site.url }}/images/Wilson_Adam_CV_thumb.png" width="25%"></a>
</figure>



## Articles

    {% bibliography -q @article %}

## Presentations

    {% bibliography -q @inproceedings %}

## Other

    {% bibliography -q !@article&!@inproceedings %}
