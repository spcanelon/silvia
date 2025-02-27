---
title: "Revealing Room for Improvement in Accessibility within a Social Media Data Visualization Learning Community"
author: 
  - Silvia Canelón
  - Liz Hare
date: 2021-05-04T10:20:00
# date_end 2021-05-04T10:40:00
slug: data-viz-accessibility
image: featured.jpg
alias:
  - /talk/2021-05-04-data-viz-accessibility/
categories:
  - journalism
  - R
  - education
  - TidyTuesday
  - TidyTuesdayAltText
  - rtweet
  - RSelenium
  - data viz
  - accessibility
# event: "csv,conf,v6"
# event_url: https://www.eventbrite.com/e/csvconfv6-tickets-144250211265
# location: Virtual
subtitle: "Data visualization accessibility talk to share what we found after scraping alternative (alt) text from data viz shared on Twitter as part of the #TidyTuesday social project."
description: csv, conf, v6
abstract: ""
links:
- icon: calendar-check-fill
  name: speaker schedule
  url: https://csvconf.com/speakers/
- icon: images
  name: slides
  url: https://bit.ly/TidyTuesday
- icon: file-richtext-fill
  name: Zenodo
  url: https://doi.org/10.5281/zenodo.4743271
- icon: play-btn-fill
  name: video
  url: https://youtu.be/DxLkv2iRdf8
- icon: github
  name: alt text analysis
  url: https://github.com/spcanelon/csvConf2021
- icon: box-seam
  name: TidyTuesdayAltText
  url: https://github.com/spcanelon/TidyTuesdayAltText
---

<!-- <script src="{{< blogdown/postref >}}index_files/fitvids/fitvids.min.js"></script> -->

Presented with [Liz Hare, PhD](https://www.twitter.com/DogGeneticsLLC) from Dog Genetics, LLC

## Abstract

We all aim to use data to tell a compelling story, and many of us enjoy sharing how we got there by open-sourcing our code, but we don't always share our story with everyone. Even kind, supportive, and open communities like the #TidyTuesday R learning community on Twitter has a ways to go before the content shared can be accessible to everyone.<br><br>Lived experiences of blind R users tell us that most data visualizations shared for TidyTuesday are inaccessible to screen reading technology because they lack alternative text (i.e. alt text) descriptions. Our goal was to bring this hidden lack of accessibility to the surface by examining the alternative text accompanying data visualizations shared as part of the TidyTuesday social project.<br><br>We scraped the alternative text from 6,443 TidyTuesday images posted on Twitter between April 2, 2018 and January 31, 2021. The first image attached to each tweet was considered the primary image and was scraped for alternative text. Manual web inspection revealed the CSS class and HTML element corresponding to the primary image, as well as the attribute containing the alternative text. We used this information and the ROpenSci {RSelenium} package to scrape the alternative text. Our preliminary analysis found that only 2.4% of the images contained a text description entered by the tweet author compared to 84% which were described by default as 'Image.'<br><br>This small group of intentional alternative text descriptions had a median word count of 18 (range: 1-170), and a median character count of 83 (range: 8-788). As a reference point, Twitter allows 240 characters in a single tweet and 1,000 characters for image descriptions. This analysis was made possible thanks to a dataset of historical TidyTuesday tweet data collected using the ROpenSci {rtweet} package, and openly available in the [TidyTuesday GitHub repository](https://github.com/rfordatascience/tidytuesday).<br><br>We will present during Session 0 on May 4, 2021: [Crowdcast Link](https://crowdcast.io/e/csvconf6-0-session-0)

<div class="shareagain" style="min-width:300px;margin:1em auto;">
<iframe src="https://spcanelon.github.io/csvConf2021/slides" width="800" height="450" style="max-width:100%;border:2px solid currentColor;" loading="lazy" allowfullscreen></iframe>
<!-- <script>fitvids('.shareagain', {players: 'iframe'});</script> -->
</div>

