---
title: 'Philly Center City District Sips 2023: An Interactive Map'
layout: single-sidebar
date: '2023-06-05'
slug: ccd-sips
categories:
  - R
tags:
  - R
  - maps
  - webscraping
  - robotstxt
  - rvest
  - leaflet
  - tidygeocoder
subtitle: 'An interactive map showing restaurants participating in CCD Sips 2023'
summary: 'An interactive map showing restaurants participating in CCD Sips 2023'
featured: yes
links:
- icon: map-marked-alt
  icon_pack: fas
  name: Interactive Map
  url: http://tiny.cc/ccdsips2023
format: hugo
---

Philly's Center City District posted a list of restaurants and bars participating in Philly's 2023 [CCD Sips](https://centercityphila.org/explore-center-city/ccdsips). CCD Sips is a series of summer Wednesday evenings (5-7pm) filled with **happy hour specials**, between June 7th and August 30th.

I prefer to take in this information as a **map** instead of a list, so I scraped some information from the website and made one! You can click or tap on the circle map markers to see information about each restaurant/bar along with a direct link to their posted happy hour specials.

Check out the link at the top of this post for a larger version of the interactive map below.

<!--https://dannyda.com/2021/06/09/how-to-make-html-iframe-responsive-iframe-height-equal-to-viewport-screen-height/-->
<style>
iframe {
display: block;
background: #FFFFFF;
border: none; /* Reset default border */
height: 70vh; /* Viewport-relative units */
width: 100%;
}
</style>
<iframe src="map.html" scrolling="no">
</iframe>
