---
title: "Resources for Data Viz Accessibility"
weight: 1
subtitle: "A selection of general and R-specific resources on how and why to make accessible data visualizations."
excerpt: "A selection of general and R-specific resources on how and why to make accessible data visualizations."
date: 2021-09-23
lastmod: 2021-10-13
draft: false
tags: 
  - R
  - data viz
  - a11y
---



<style type="text/css">
/*.main {
  display: grid | inline-grid;
}

.grid-container {
  display: grid;
  grid-template-columns: 1fr 4fr;
  grid-auto-flow: row;
  grid-gap: 10px 10px;
}


.grid-item {
  /*background-color: rgba(255, 255, 255, 0.8);*/
  border: 1px solid rgba(0, 0, 0, 0.8);
  /*padding: 20px;
  font-size: 18px;
  line-height: 1.5em;*/
  text-align: left;
  height: auto;
} */

/* -- css for images --*/  
.page-main img {
  box-shadow: 0px 0px 2px 2px rgba( 0, 0, 0, 0.2 );
  #/* ease | ease-in | ease-out | linear */
  transition: transform ease-in-out 2s;
}

.page-main img:hover {
  transform: scale(1.4);
}
</style>

> [MiR Community](https://mircommunity.com/about/) (community for minority R users) recently learned that we received a grant to teach data viz accessibility practices to the R community! This educational event will take place as a TidyTuesday week in the spring of 2022. See the [news on Twitter](https://twitter.com/spcanelon/status/1438958412793065487?s=20) and stay tuned for updates! 🎉

## General resources

- **Note:** There is an extensive list of data viz accessibility resources at https://github.com/dataviza11y/resources/blob/main/README.md

- Article by Doug Schepers that provides great background on data viz accessibility, explains how data visualization itself is assistive technology, and offers considerations for a variety of readers: [Why Accessibility Is at the Heart of Data Visualization](https://medium.com/nightingale/accessibility-is-at-the-heart-of-data-visualization-64a38d6c505b)
  
- The [Chartability methodology](https://chartability.fizz.studio/) helps data viz practitioners audit their data viz, and it's language/tool-agnostic. Chartability was created by Frank Elavsky with input from the broader community and is the most thorough set of standards I've come across.

- Øystein Moseng provides some basic practices to consider in the post [10 Guidelines for DataViz Accessibility](https://www.highcharts.com/blog/tutorials/10-guidelines-for-dataviz-accessibility/). Among those included are these two which I don't come across as often:

    - Do not rely on color alone to convey information. I've also heard this referred to as "color independence" and in some cases as "dual-encoding" of information
    - Prefer simple, familiar visualizations over complex novelties.
    
      <img src="guidelines-oystein-moseng.png" alt="The pie chart using color and pattern to differentiate between slices. This screenshot also demos an interactive chart element in action: hovering over one pie slice enlarges the slice, reveals more information about the selected slice, and dims the non-selected slices."/><p class="caption" style="text-align:center;">Pie chart from Øystein's post using color and patterns to encode information</p>
  
- Talk at the Data Visualization Society's Outlier conference earlier this year, by Frank Elavsky, Larene Le Gassick, and Sarah Fossheim: [Are your visualizations excluding people?](https://www.youtube.com/watch?v=SWB-KLXN-Ok)

- Guidelines by Amy Cesal on how to write alt text for data visualizations: [Writing Alt Text for Data Visualization](https://medium.com/nightingale/writing-alt-text-for-data-visualization-2a218ef43f81)

    <img src="alt-text-amy-cesal.png" width="100%" alt="Example alt text format that reads: Chart type of type of data where reason for including chart. Also the recommendation to include a link to the data source somewhere in the text."/>
    
- Post by Lisa Charlotte Muth on how to pick colors for your data viz that everyone can appreciate: [How to pick more beautiful colors for your data visualizations - Datawrapper Blog](https://blog.datawrapper.de/beautifulcolors/)

    <img src="datawrapper.png" width="100%" alt="The first pie chart uses colors of similar lightness that end up appearing the same when checked under grayscale simulation. The first option for improvement picks different colors that all stand out from one another in grayscale. The second option keeps the original colors but delineates pie slices with a contrasting border."/><p class="caption" style="text-align:center;">Example from Charlotte's post of two different approaches to improving a pie chart</p>

- Post by Gareth Ford Williams from The Readability Group about how to make more informed font choices: [A Guide to Understanding What Makes a Typeface Accessible](https://medium.com/the-readability-group/a-guide-to-understanding-what-makes-a-typeface-accessible-and-how-to-make-informed-decisions-9e5c0b9040a0)
  - Related is a talk from The Readability Group sharing findings from a survey study about font preferences including 2000+ participants. Among these were participants with dyslexia characteristics and participants with poor near vision: [Don't Believe the Type!](https://youtu.be/h8IOqUl1zII?t=1029)
  
    <img src="typeface-poor-near-vision.png" width="100%" alt="The fonts selected most often in this group were San Francisco Pro, Red Hat Text, Calibri, and Segoe UI, in that order. San Francisco Pro was selected by 68% of participants The fonts selected least often were Open Dyslexic, Dyslexie, Comic Sans MS, and Sylexiad Sans. Open Dyslexic was selected by 12% of participants. Both Times New Roman and Helvetica are highlighted as showing the largest differences between users with poor near vision and those without. Times New Roman was the 6th least selected and Helvetica was in the middle learning towards the most selected fonts."/><p class="caption" style="text-align:center;">Bar graph showing the frequency by which 20 different fonts were selected by study participants with strong poor near vision in comparison with users with no poor near vision.</p>

- Amber Thomas provides an example of how to make scrollytales more accessible in a piece created with Ofunne Amaka for The Pudding: [The Naked Truth](https://pudding.cool/2021/03/foundation-names/)

    <blockquote class="twitter-tweet" data-conversation="none"><p lang="en" dir="ltr">I&#39;m excited to release this project for many reasons, but one among them is that I introduced lots of new (to me) <a href="https://twitter.com/hashtag/a11y?src=hash&amp;ref_src=twsrc%5Etfw">#a11y</a> features. My favorite: the ability to turn off scrollytelling 💖 Would love to hear what folks think! <a href="https://t.co/eDSQr9RjFe">pic.twitter.com/eDSQr9RjFe</a></p>&mdash; Amber Thomas (@ProQuesAsker) <a href="https://twitter.com/ProQuesAsker/status/1375159092684058626?ref_src=twsrc%5Etfw">March 25, 2021</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
    
- Sarah Fossheim provides a code-through showing how to make screenreader-friendly graphs using D3.js: [How to create a screen reader accessible graph like Apple's with D3.js](https://fossheim.io/writing/posts/apple-dataviz-a11y-tutorial/)

    <img src="d3js-apple-rings.png" width="100%" alt=""/>
    
- Chris DeMartini has a series of blog posts documenting his journey auditing one of his public Tableau visualizations for accessibility:
  1. [A Tableau Accessibility Journey](https://datablick.com/blog/2021/2/4/a-tableau-accessibility-journey-part-i)
  2. [Focus Order]( https://datablick.com/blog/2021/2/18/a-tableau-accessibility-journey-part-ii-focus-order)
  3. [Color Contrast and Font Size](https://www.datablick.com/blog/2021/4/15/a-tableau-accessibility-journey-part-iii-color-contrast-and-font-size)
  4. [Keyboard Accessibility](https://www.datablick.com/blog/2021/8/10/a-tableau-accessibility-journey-part-iv-keyboard-accessibility)
<br>  
  <img src="tableau-chris-demartini.png" width="100%" alt="The user is using a kind of selection tool to hover over an area of the visualization, in this case the title, and check font color contrast against its background. The tool pulls up details along the bottom of the page, including WCAG pass/fail test results, background and foreground color hex codes, and other color characteristics."/><p class="caption" style="text-align:center;">Title of Chris's Tableau visualization being checked for color contrast.</p>

## R resources

- [Liz Hare](https://twitter.com/DogGeneticsLLC) and I gave a talk earlier this year on alt text in data viz shared as a part of TidyTuesday on Twitter. After web-scraping alt text from TidyTuesday tweets we found that only 3% of data viz tweets had alt text to accompany them (over the first 3 years of the TidyTuesday project). Links to the video recording, slides, and resources at https://github.com/spcanelon/csvConf2021. The talk includes guidelines on what makes effective alt text for data viz (complementary to those Amy Cesal includes in her post). 
    
    <img src="alt-text-silvia-liz.png" width="100%" alt="Effective alt includes a description that conveys meaning in the data, variables on the axes, scale described within the description, description of the type of plot. Direct link to slide: https://spcanelon.github.io/csvConf2021/slides/indexLH.html#11"/><p class="caption" style="text-align:center;">Slide from our presentation summarizing the most useful alt-text features found among 196 data viz tweets</p>

- Post from RStudio on how to add alt text to visualizations produced in R Markdown (spoiler: you can use code chunk option `fig.alt`): [New in knitr: Improved accessibility with image alt text](https://blog.rstudio.com/2021/04/20/knitr-fig-alt/)
    
    ````
    ```{r fig.cap="Bigger flippers, bigger bills", fig.alt = "Scatterplot of flipper length by bill length of 3 penguin species, where we show penguins with bigger flippers have bigger bills."}
    
    ggplot(data = penguins, aes(x = flipper_length_mm,
                                y = bill_length_mm,
                                color = species)) +
      geom_point(aes(shape = species), alpha = 0.8) +
      scale_color_manual(
        values = c("darkorange","purple","cyan4")) 
    ```
    ````

- The [Highcharter R package](https://jkunst.com/highcharter/index.html) developed by Joshua Kunst adds interactivity to data viz using Highcharts JavaScript components designed with web accessibility in mind. I haven't played with the package yet, but it looks awesome!

    <img src="highcharter.png" width="100%" alt="Scatterplot of the palmerpenguins dataset showing data points clustered by species and the highcharter package making it possible to focus on one cluster and identify the x and y values of a specific data point. In this case the data point was a Chinstrap penguin observation mapping to a flipper length of 201mm and bill length of 52.20mm."/><p class="caption" style="text-align:center;">Highcharter interactivity in action, showing x and y coordinates of a specific Chinstrap penguin data point in the scatterplot</p>
    

