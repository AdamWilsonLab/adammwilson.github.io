---
layout: page
permalink: /teaching/
title: Teaching
tags: [about,teaching]
image:
  feature: fieldwork.jpg
featured: true

---

## Environmental Science (GEO 104)
Environmental science is the interdisciplinary study of the physical, chemical, and biological systems that sustain life on our planet.  In this course we will explore current environmental challenges such as the conservation of biodiversity, the sustainable production of energy, and the implications of human population growth. The processes of scientific inquiry and discovery will be emphasized through investigation of specific case studies and the critical evaluation of the underlying scientific evidence.  

## GIS for Environmental Modeling (GEO 479/559)
This is an intermediate level GIS course designed for senior undergraduate students and graduate students. Students are expected to have basic knowledge of GIS through either completing an introductory level GIS course or having entry level work experiences with GIS. The course emphasizes GIS applications for environmental modeling, which is loosely defined as any projects that contain environmental elements. The course has a lecture and a lab component. The lecture will focus on Methodology Design by introducing a series of GIS methods and their intended use to help students select appropriate GIS methods for a project. These topics are covered under the following sections: Basic GIS Methods, Testing and Validating GIS methods, and Integrating GIS with Environmental Models. The hands-on labs will focus on learning GIS tools to help implement a GIS project. Advanced topics in GIS research will also be introduced. The course should benefit students specialized in environment, natural resources, and any disciplines that are concerned with environmental issues.

## Spatial Environmental Data Analysis (GEO 503)
The quantity and quality of data available for ecological and environmental research has exploded over the past few decades. These ‘big data’ now allow us to address important questions (both old and new) with unprecedented rigor and generality.  Leveraging these new data streams requires new tools and increasingly sophisticated workflows. The free and open-source R programming language has become a lingua franca for ecological, epidemiological, and statistical research.  The course will use a combination of lecture and hands-on exercises to provide a gentle introduction to programming in R with a focus on spatial data processing.  The use of ‘literate programming’ (code embedded within text) to generate dynamic, reproducible research output (figures, manuscripts, websites, etc.) will also be addressed. The course includes an extensive project for students to conduct spatial analysis related to their research.  Familiarity with basic GIS concepts (raster, vector, geographic projection, etc.) will be assumed, but no prior experience with R is necessary.  The course is open to advanced undergraduate students and graduate students (postdocs are also welcome) with an interest in advancing their data analysis and modeling skill-set. 


## Teaching related posts:
{% for post in site.tags.teaching %}
   [{{ post.title }}]({{ post.url}})  _{{ post.date | date: "%B %d, %Y" }}_
{% endfor %}
