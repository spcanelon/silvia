---
title: "WAVE Audit No. 1"
weight: 1
subtitle: "First audit using the WebAIM Web Accessibility Evaluation Tool (WAVE)"
excerpt: "First audit using the [WebAIM Web Accessibility Evaluation Tool (WAVE)](https://wave.webaim.org/)."
slug: audit-1
alias:
  - /blog/2021-a11y-website/01-wave-audit-1/
date: 2021-06-02
lastmod: 2021-06-07
draft: false
alt: "Test for alt text in archetype"
---



<style type="text/css">
.page-main img {
  box-shadow: 0px 0px 2px 2px rgba( 0, 0, 0, 0.2 );
  #/* ease | ease-in | ease-out | linear */
  transition: transform ease-in-out 0.6s;
}

.page-main img:hover {
  transform: scale(1.4);
}
</style>


> **Did you know that 97.4% of home pages have web accessibility failures???** :scream: 

This finding is one of many from an accessibility analysis that non-profit WebAIM (Web Accessibility in Mind) conducts annually on home pages of the top one million websites. You can find a summary of these findings in a WebAIM [blog post](https://webaim.org/blog/webaim-million-2021/) and detailed information in the [full report](https://webaim.org/projects/million/#wcag), both published on April 30, 2021.

Learning about all of the ways that digital content is made inaccessible to people with disabilities has made me take inventory of the different ways that I have contributed to this problem (there was some shame to process here :see_no_evil:). 

The magic of [R Markdown](https://bookdown.org/yihui/rmarkdown/) has given me the gift of turning R code into a variety of HTML outputs including R notebooks, [xaringan presentation slides](/project/xaringan-nhs-r/), and websites like this one -- all of which I've been able to share freely online with others. This magic though (like all magic?) comes with limitations. R tools (and technology more broadly) can't automatically ensure that its various outputs are accessible to everyone. That's where we come in as software developers and content creators and take personal responsibility. At the risk of extending this metaphor too far, I'll finish by offering the framework that we all need to practice (accessibility) spells/skills in order to use these magical tools responsibly.

All of this to say that gaining awareness about accessibility as a way to create the more inclusive world that I want to live in has motivated me to do better. I even found myself excited to conduct accessibility audits on my digital content, including my personal website ([data viz](https://chartability.fizz.studio/) too)! 

### My audit results

I relied on WebAIM's [Web Accessibility Evaluation Tool (WAVE)](https://wave.webaim.org/) to help me get started. I installed the [Firefox extension](https://wave.webaim.org/extension/) to conduct my audit. Here's what I found at a high level, and each section of the post contains an itemized list of failures for the page along with a screenshot:

- Most errors corresponded with missing alt-text for any images that are used to decorate page sidebars or populate thumbnails

- Some of my alt-text descriptions are too long! :laughing: I'll use this example to highlight some of the super helpful features of the WAVE tool. Below is a screenshot of the tool when I select the alert next to the super long alt-text description for a hex logo :woman_facepalming:

    <details><summary>WAVE tool reference and code accompanying an alert</summary>
    <img src="img/wave-ex-alt-text.png" title="Reference pane of the tool elaborates on what the alert means, why it matters, how to fix it, a note on the tool's algorithm, and a link to the WCAG standards and guidelines. Code section is expanded along the bottom and highlights exactly what part of the HTML code the alert is refering to." alt="Reference pane of the tool elaborates on what the alert means, why it matters, how to fix it, a note on the tool's algorithm, and a link to the WCAG standards and guidelines. Code section is expanded along the bottom and highlights exactly what part of the HTML code the alert is refering to." width="1898" style="display: block; margin: auto;" />
    </details>

- My blog and talk listings have redundant links because these layouts have thumbnails enabled and both the thumbnail and the title of the post are active links

- There are 5 alerts (combined) in the navigation bar and footer that appear on every page. These correspond to redundant title links. For example, the link for my Blog has the name "Blog" and also the title "Blog." This is something I can fix easily in the **config.toml** configuration file. I was wondering how these two fields were different in that file and now I know!

- The [blog post example](#blog-example) I documented here contained 177 low contrast errors! These were all related to the [arduino syntax highlighting](https://xyproto.github.io/splash/docs/arduino.html) in the various code chunks that I included. The code chunks currently feature primarily gray code against a white background.

### Next steps

I'm _definitely_ not an accessibility expert by any stretch of the imagination. But the great thing is, I don't have to be an expert in order to correct some of these failures! :muscle:

I'm going to need some more Hugo knowledge to correct some of the other ones but I _think_ I've become familiar enough with the Hugo Apéro theme building this site that I _might_ be able to poke around and make some changes. In either case, I'll be documenting my changes in this [a11y series of blog posts](/blog/2021-a11y-website/), so stay tuned and follow along with me!
> Update (June 7, 2021): I've opened [issue #28](https://github.com/spcanelon/silvia/issues/28) and have the first changes in branch `wave-audit-1` [available to preview](https://deploy-preview-29--silvia.netlify.app/) before merging.

I'll be learning from the [WCAG primer from TetraLogical](https://tetralogical.com/articles/wcag-primer/), recommended by the [a11y Project](https://www.a11yproject.com/checklist/#further-reading), and the [WCAG resources from WebAIM](https://www.w3.org/WAI/roles/designers/).

And last but not least:

> **Even if I manage to correct all of these errors and alerts, it doesn't mean my site is fully accessible.** 

It just means it's more accessible than when I began. There are numerous accessibility considerations that are very hard to test for failure (e.g. cognitive accessibility, flexibility, etc.) that I continue to learn about. Also, accessibility is changing all of the time, and we need to be ready to change with it. So just like with R, the learning doesn't stop! :nerd_face:

## Home page

Link: [https://silvia.rbind.io/](/)

Audit results:
- 1 error
  - 1 &#120; Missing alternative text
- 6 alerts
  - 1 &#120; Suspicious link text
  - 5 &#120; Redundant title text

<div class="figure" style="text-align: center">
<img src="img/wave-home.png" alt="There is an error symbol next to the decorative image on the home page. There are also alert symbols for links in the navigation bar and footer" width="950" />
<p class="caption">Figure 1: Audit for my home page</p>
</div>


## About page

Link: [https://silvia.rbind.io/about/](/about/)

Audit results:

- 4 errors
  - 3 &#120; Linked image missing alternative text
  - 1 &#120; Empty link
- 19 alerts
  - 2 &#120; Skipped heading level
  - 1 &#120; Possible heading
  - 4 &#120; Suspicious link text
  - 7 &#120; Redundant link
  - 5 &#120; Redundant title text

<div class="figure" style="text-align: center">
<img src="img/wave-about-header.png" alt="About page showing an alert in my blurb" width="1898" />
<p class="caption">Figure 2: Audit for my About page header</p>
</div>

<div class="figure" style="text-align: center">
<img src="img/wave-about-main-top.png" alt="An alert is shown next to some heading items, and a link. An error is shown next to a thumbnail image for the featured blog post" width="1898" />
<p class="caption">Figure 3: Audit for the main section of my About page</p>
</div>

<details><summary>Full page screenshot</summary>
<div class="figure" style="text-align: center">
<img src="img/wave-about.png" alt="Alerts are shown for links in the navigation bar and footer, for some heading items, and for a few links throughout the page" width="950" />
<p class="caption">Figure 4: Audit for my About page in full page view</p>
</div>
</details>

## Blog page

Link: [https://silvia.rbind.io/blog/](/blog/)

Audit results:

- 6 errors
  - 1 &#120; Missing alternative text
  - 5 &#120; Linked image missing alternative text
- 10 alerts
  - 5 &#120; Redundant link
  - 5 &#120; Redundant title text

<div class="figure" style="text-align: center">
<img src="img/wave-blog.png" alt="Alerts are shown for the navigation bar and footer, and for blog post links. Errors shown for the decorative image for the page and for the blog post thumbnails" width="950" />
<p class="caption">Figure 5: Audit for my Blog listing page in full page view</p>
</div>

### Blog example

Link: [https://silvia.rbind.io/blog/hello-hugo-apero/](/blog/hello-hugo-apero/)

Audit results:

- 25 errors
  - 1 &#120; Missing alternative text
  - 24 &#120; Empty link
- 177 contrast errors
  - 177 &#120; Very low contrast
- 17 alerts
  - 9 &#120; Long alternative text
  - 1 &#120; Skipped heading level
  - 1 &#120; Broken same-page link
  - 6 &#120; Redundant title text

<div class="figure" style="text-align: center">
<img src="img/wave-blog-hha-top.png" alt="Alerts shown for links in the navigation bar and for a heading item. Errors shown for the blog decorative image and for a link symbol next to a header." width="1898" />
<p class="caption">Figure 6: Audit for my Hello Hugo Apéro blog post</p>
</div>

## Talk page

Link: [https://silvia.rbind.io/talk/](/talk/)

Audit results:

- 5 errors
  - 5 &#120; Linked image missing alternative text
- 13 alerts
  - 5 &#120; Linked image missing alternative text
  - 2 &#120; Skipped heading level
  - 5 &#120; Redundant link
  - 5 &#120; Redundant title text
  - 1 &#120; YouTube video

<div class="figure" style="text-align: center">
<img src="img/wave-talks-top.png" alt="Alerts displayed for a heading item and the primary link to a talk. An error is displayed for the talk thumbnail." width="1898" />
<p class="caption">Figure 7: Audit for my Talk listing page</p>
</div>

<details><summary>Full page screenshot</summary>
<div class="figure" style="text-align: center">
<img src="img/wave-talks.png" alt="Alerts displayed in the navigation bar and footer, some heading items, all primary talk links, and a YouTube button link. Errors displayed for all talk thumbnail images." width="950" />
<p class="caption">Figure 8: Audit for my About page header in full page view</p>
</div>
</details>

### Talk example

Link: [https://silvia.rbind.io/talk/2021-05-04-data-viz-accessibility/](/talk/2021-05-04-data-viz-accessibility/)

Audit results:

- 1 error
  - 1 &#120; Empty link
- 6 alerts
  - 1 &#120; Skipped heading level
  - 5 &#120; Redundant title text

<div class="figure" style="text-align: center">
<img src="img/wave-talks-csvconf.png" alt="Alerts displayed for the navigation bar and footer, as well as the talk summary. No errors are displayed." width="950" />
<p class="caption">Figure 9: Audit for my CSV Conf talk post in full page view</p>
</div>

## Publication page

Link: [https://silvia.rbind.io/publication/](/publication/)

Audit results:

- 0 errors
- 5 alerts
  - 5 &#120; Redundant title text

<div class="figure" style="text-align: center">
<img src="img/wave-pubs-top.png" alt="No errors or alerts displayed for this view" width="1898" />
<p class="caption">Figure 10: Audit for my Publication listing page</p>
</div>

<details><summary>Full page screenshot</summary>

<div class="figure" style="text-align: center">
<img src="img/wave-pubs.png" alt="Alerts displayed for the navigation bar and footer" width="950" />
<p class="caption">Figure 11: Audit for my Publication listing page in full page view</p>
</div>

</details>

### Publication example

Link: [https://silvia.rbind.io/publication/geospatial-analysis-pregnancy-outcomes/](/publication/geospatial-analysis-pregnancy-outcomes/)

Audit results:

- 1 errors
  - 1 &#120; Empty link
- 6 alerts
  - 1 &#120; Skipped heading level
  - 5 &#120; Redundant title text

<div class="figure" style="text-align: center">
<img src="img/wave-pubs-geo.png" alt="Alerts displayed for the header bar and footer and for the publication summary" width="950" />
<p class="caption">Figure 12: Audit for my geospatial analysis publication in full page view</p>
</div>

## Project page

Link: [https://silvia.rbind.io/project/](/project/)

Audit results:

- 3 errors
  - 3 &#120; Empty link
- 5 alerts
  - 5 &#120; Redundant title text

<div class="figure" style="text-align: center">
<img src="img/wave-projects-top.png" alt="Errors displayed next to each project thumbnail image" width="1898" />
<p class="caption">Figure 13: Audit for my Project listing page</p>
</div>

### Project example

Link: [https://silvia.rbind.io/project/tidy-tuesday-alt-text/](/project/tidy-tuesday-alt-text/)

Audit results:

- 2 errors
  - 2 &#120; Empty link
- 10 alerts
  - 3 &#120; Long alternative text
  - 1 &#120; Skipped heading level
  - 6 &#120; Redundant title text

<div class="figure" style="text-align: center">
<img src="img/wave-projects-ttat-top.png" alt="Alert displayed in the project summary and next to an image alt-text. Error dislayed next to a link symbol accompanying a heading." width="1898" />
<p class="caption">Figure 14: Audit for my TidyTuesdayAltText project post</p>
</div>

<details><summary>Full page screenshot</summary>
<div class="figure" style="text-align: center">
<img src="img/wave-projects-ttat.png" alt="Alerts shown in the navigation bar and footer, project summary, and image alt-text. Errors shown next to link symbols accompanying headings." width="950" />
<p class="caption">Figure 15: Audit for my TidyTuesdayAltText project post in full page view</p>
</div>
</details>
