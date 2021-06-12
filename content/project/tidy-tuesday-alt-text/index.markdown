---
title: "TidyTuesdayAltText"
subtitle: "An R package with the goal of providing insight into the alternative (alt) text accompanying the data visualizations shared on Twitter as part of the TidyTuesday social project"
excerpt: "An R package with the goal of providing insight into the alternative (alt) text accompanying the data visualizations shared on Twitter as part of the [TidyTuesday social project](https://github.com/rfordatascience/tidytuesday#a-weekly-social-data-project-in-r)."
date: 2021-05-04
author: "Silvia Canelón"
draft: false
tags:
  - TidyTuesday
  - TidyTuesdayAltText
  - accessibility
  - R
categories:
  - R
  - Package
layout: single
links:
- icon: box
  icon_pack: fas
  name: package
  url: https://github.com/spcanelon/TidyTuesdayAltText
- icon: comment
  icon_pack: fas
  name: related talk
  url: "/talk/2021-05-04-data-viz-accessibility/"
- icon: chart-bar
  icon_pack: fas
  name: tidytuesday databases on notion
  url: tiny.cc/notion-dataviz
---

## About the data  <a href='https://github.com/spcanelon/TidyTuesdayAltText'><img src='featured-hex.png' align="right" height="200" alt='Hex logo for the package. White with a thick black border. Inside, the TidyTuesday logo on the top half which are the words TidyTuesday in white against a broad brush stroke of black paint. On the bottom half, the words alt = "text" in black against a white background and within angle brackets to simulate html code.'/></a>

The original data were collected and made available by Tom Mock ([\@thomas_mock](https://twitter.com/thomas_mock)) using [{rtweet}](https://github.com/ropensci/rtweet). These data are available in the [TidyTuesday repository](https://github.com/rfordatascience/tidytuesday#a-weekly-social-data-project-in-r).

These tweets were processed and scraped for alternative text by Silvia Canelón ([\@spcanelon](https://twitter.com/spcanelon))

1. Data were filtered to remove tweets without attached media (e.g. images)
1. Data were supplemented with reply tweets collected using {rtweet}. This was done to identify whether the original tweet or a reply tweet contained an external link (e.g. data source, repository with source code)
1. Alternative (alt) text was scraped from tweet images using [{RSelenium}](https://docs.ropensci.org/RSelenium/). The first image attached to each tweet was considered the primary image and only the primary image from each tweet was scraped for alternative text. The following attributes were used to build the scraper:

- CSS selector: `.css-1dbjc4n.r-1p0dtai.r-1mlwlqe.r-1d2f490.r-11wrixw`
- Element attribute: `aria-label`

<div class="figure" style="text-align: center">
<img src="https://raw.githubusercontent.com/spcanelon/csvConf2021/master/slides/img/webInspection.png" alt="Web inspection tool being used to identify the CSS selector corresponding to the primary image of one of Hao Ye's (@Hao_and_Y) tweets with alt text" width="90%" />
<p class="caption">Figure 1: Example of web inspection being used to identify the CSS selector utilized for alt-text web scraping</p>
</div>

This data package does not include data that could directly identify the tweet author in order to respect any author’s decision to delete a tweet or make their account private after the data was originally collected.[^1]

To obtain the tweet text, author screen name, and many other tweet attributes, you can “rehydrate” the TweetIds (or “status” ids)[^2]) using the {rtweet} package.[^3]

[^1]: [Developer Policy – Twitter Developers | Twitter Developer](https://developer.twitter.com/en/developer-terms/policy)
[^2]: [Tweet object | Twitter Developer](https://developer.twitter.com/en/docs/twitter-api/data-dictionary/object-model/tweet) 
[^3]: [Get tweets data for given statuses (status IDs). — lookup_tweets • rOpenSci: rtweet](https://docs.ropensci.org/rtweet/reference/lookup_tweets.html)

---

##  TidyTuesday databases on Notion

I use the data available in the TidyTuesday repository to populate some searchable TidyTuesday databases at [tiny.cc/notion-dataviz](https://tiny.cc/notion-dataviz) with data visualizations tagged by the dataset of the week, hashtags, mentions, etc.


<div class="figure" style="text-align: center">
<img src="tt-db-notion.png" alt="The Notion 2021 TidyTuesday database showing a gallery of the most recent data visualizations in the collection, organized in a grid" width="2034" />
<p class="caption">Figure 2: Screenshot of the 2021 TidyTuesday database on Notion, taken on June 1, 2021</p>
</div>

<span>{{< tweet 1349728938268962819 >}} align = "center" </span>
