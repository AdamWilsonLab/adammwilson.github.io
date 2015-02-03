---
layout: page
permalink: /research/index.html
title: Research Interests
tags: [about,research]
image:
  feature: fieldwork.jpg
featured: true

---
 <figure>
  <img src="{{ site.url }}/images/ResearchOutline.png" alt="Research Outline">
  <figcaption>Research Outline</figcaption>
</figure>

Humans’ impact on the global environment has exploded in recent decades, but our comprehension of that impact has not kept pace. It is vital for the conservation of biodiversity and our own long–term sustainability that we understand how global change affects ecological and evolutionary patterns and processes even when they occur over vast spatial and temporal scales.  I study ecological processes across spatio-temporal scales ranging from biomass at the gram/centimeter scale to the effect of global climate fluctuations on wildfire risk over decades and across thousands of kilometers. My approach harnesses multi-scale modeling frameworks and diverse data streams including remote sensing, field work, and existing data sets to understand and predict the impacts of global change on biodiversity and ecosystem dynamics. 

In addition to biodiversity, it is also important to consider how global change can affect ecosystem function and resilience.  Remotely sensed data offer tantalizing spatio-temporal coverage of ecosystem dynamics, but require in situ measurements to connect those data to ecological processes on the ground.   I use hierarchical statistical models to reveal the complex spatio-temporal patterns of ecosystem dynamics (such as disturbance and biomass accumulation) and provide accurate accounting of uncertainty. By coupling fine scale ecological observations with coarser, but spatially and temporally continuous remotely sensed and meteorological data, we can increase our understanding of how ecosystems have responded to climate in the past and assist in forecasting how they will respond in the future.

Many of the challenges we face in understanding the biotic response to global change are multidisciplinary in nature.  I seek to meet these challenges by working across scales and disciplines, drawing from climatology, remote sensing, biogeography, ecosystem ecology, and Bayesian statistics.

## Research related posts:
{% for post in site.tags.research %}
   [{{ post.title }}]({{ post.url}})  _{{ post.date | date: "%B %d, %Y" }}_
{% endfor %}

