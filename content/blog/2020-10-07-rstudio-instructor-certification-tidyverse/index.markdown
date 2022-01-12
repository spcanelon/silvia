---
title: Becoming certified as an RStudio Tidyverse Instructor
layout: single-sidebar
date: '2020-10-07'
categories:
  - R
  - Education
  - tidyverse
tags:
  - RStudio
  - R
slug: rstudio-instructor-certification-tidyverse
alias:
  - /blog/2020-10-07-rstudio-instructor-certification-tidyverse/
  - /blog/rstudio-instructor-certification-tidyverse/
subtitle: An overview of the RStudio Instructor certification process and collection of resources to support anyone on their certification journey.
summary: An overview of the RStudio Instructor certification process and collection of resources to support anyone on their certification journey.
lastmod: 2021-03-31
featured: yes
draft: no
image:
  placement: 1
  caption: '[Illustration from starline on Freepik](https://www.freepik.com/free-vector/abstract-hexagonal-black-white-3d-background_5432173.htm)'
  focal_point: Center
  preview_only: no
output:
  blogdown::html_page:
    toc: yes
    number_sections: no
    toc_depth: 1
links:
  - icon: github
    icon_pack: fab
    name: Teaching exam materials
    url: https://github.com/spcanelon/rit-teaching-exam
  - icon: file-code
    icon_pack: far
    name: Tidyverse exam v2.0 solution
    url: /blog/2020-rstudio-instructor-certification-tidyverse/tidyverse-sample-exam-solutions.html
---

<script src="{{< blogdown/postref >}}index_files/fitvids/fitvids.min.js"></script>

February 12th, 2021 was [Greg Wilson’s last day at RStudio](https://twitter.com/gvwilson/status/1360304482496614402?s=20). This means he is no longer running the [instructor training program](https://education.rstudio.com/trainers/#info), so the future of the program is unclear. You may want to contact <traininginstructor@rstudio.com> with any specific questions.

You can also jump down in this blog post to [Teaching resources](#teaching-resources) to find a consolidated list of materials previously taught as part of the RStudio certification program, in addition to some related resources (thanks to Yanina for adding to this list!).

Lastly, you may want to consider becoming certified through [The Carpentries](https://carpentries.org/blog/2018/07/apply-to-train/). Yanina Bellini Saibene ([@yabellini](https://twitter.com/yabellini)) and Dorris Scott ([@Dorris\_Scott](https://twitter.com/Dorris_Scott)) are a couple of RStudio instructors that have also been certified through The Carpentries.

# Why did I get trained?

Teaching R was not something I thought I’d ever get into but a couple of reasons were nudging me towards getting some formal training.

I wanted to be able to…

1.  …support my coworkers in their own data analysis projects and be better prepared to introduce R to undergraduate students coming through and hoping to apply learned skills elsewhere
2.  …incorporate data analysis into the research efforts of my local organizing collective, and was feeling ill-equipped to lead our group. Most collective members have very little experience with data analysis, if any, and none have programming experience

After the RStudio Instructor training I can confidently say I feel prepared for both of these challenges!

# Choose your own adventure

1.  Jump down to a [panel on the RStudio Certification](#attending-the-mir-panel) hosted by the [MiR Community](https://twitter.com/miR_community)
2.  Jump down to a list of [teaching exam examples](#teaching-exam-examples) and [Tidyverse sample exam solutions](#tidyverse-sample-exam-solutions) shared openly by other instructors
3.  **Keep reading** to find out what I learned before I decided to pursue the certification and what the certification experience was like for me.

# Deciding to become certified

## Asking around

In the interest of making an informed decision, I asked a few instructors to share a bit about their experience with the certification process before I made the commitment.

-   🇺🇸 [Stephan Kadauke](https://education.rstudio.com/trainers/people/kadauke+stephan/) is a colleague I met through the Children’s Hospital of Philadelphia R User group. Specifically at an [Intro to Machine Learning with the Tidyverse](https://alison.rbind.io/post/2020-06-02-tidymodels-virtually/) workshop led by Alison Hill.

I met these wonderful people through the [R-Ladies Global](https://twitter.com/RLadiesGlobal) Slack workspace:

-   🇦🇷 [Yanina Bellini Saibene](https://education.rstudio.com/trainers/people/bellini_saibene+yanina/) shared her experience with this process in her blog post [Obtaining RStudio certification. A shared path](https://yabellini.netlify.app/post/rstudiocertification/).
-   🇧🇴 🇳🇱 [Paloma Rojas-Saunero](https://education.rstudio.com/trainers/people/rojas-saunero+paloma/) shared her view as a Ph.D. candidate with experience teaching R in R-Ladies workshops and as a teaching assistant in biostatistics courses.
-   🇰🇪 [Shelmith Kariuki](https://education.rstudio.com/trainers/people/kariuki+shelmith/) speaks to her experience in her blog post [The RStudio Certification Process](https://shelkariuki.netlify.app/post/certification/).

### Here’s what folks had to say!

*Highlights are shared with the authors’ permission and my gratitude to them.*

#### What made you want to pursue the certification?

> One, it gave me incentive to read [R for Data Science](https://r4ds.had.co.nz/) cover to cover which I had been meaning to do for a while. Two, I’m teaching R and the certification gives me some gravitas to do that. Three, it forced me to critically think about cognitive load theory, concept mapping, and lesson development, all of which are super useful when you actually have to develop lessons. **–Stephan**

> I pursued the certification for a few reasons. First because I am really enthusiastic about teaching and I love the tidyverse, so I wanted to find opportunities of teaching it outside my university. Second because I feel that RStudio is growing so fast on teaching materials that sharing with other instructors would be a great way to always keep updated. And last but not least, I was also encouraged by the idea of going through the process with Yanina Bellini Saibene and other amazing women as she discusses in her blog post. **–Paloma**

#### What did you think of the training itself, particularly the pedagogical aspects?

> The training is top notch. In my mind, Greg Wilson is the \#1 authority when it comes to teaching programming and R in particular. **–Stephan**

> I think the best part is to take and learn the pedagogical aspect. Greg Wilson is an awesome trainer and you will love as a student all the tools and techniques that he teaches you. For learning this, the course is already worth it. All the content is more developed in the book [Teaching Tech Together](https://teachtogether.tech/) by Greg Wilson if you want to look it over. **–Yanina**

> About the training, it was mind blowing, it changed my view of teaching not only programming but everything. Greg’s book is amazing and the way he teaches is outstanding. I learned so much. **–Paloma**

#### Have you been able to implement what you learned in some way either at work or elsewhere?

> Yes! As you probably saw, I’m teaching the intro to R course for [R/Medicine](https://www.youtube.com/playlist?list=PL4IzsxWztPdljYo7uE5G_R2PtYw3fUReo). And I’ve been teaching a similar course to doctors, in addition to some other teaching sessions that I’ve done for the CHOP R User group and/or medical resident teaching. **–Stephan**

> Yes! Immediately. I delivered 3 in-person courses after training and more than 15 courses on-line using all the pedagogical tools. I also co-founded [Metadocencia](https://metadocencia.netlify.app/en/) where we share practical tools to help teachers teach online (volunteer-run and free) using these principles learned in the training. I also use some of the tools for my work as the chief of a research group for some meetings and identifying the target of some of our development (especially concept maps and learner personas). **–Yanina**

> I think I use what I learned so far even when I am preparing my work presentations, when developing any type of class, event, book club, etc.
> Overall it was an experience that made me reflect a lot on how teaching is usually done, how is my teaching so far and an inspiration about the teacher I want to be. **–Paloma**

## Attending the MiR panel

If you read the questions and responses above you might have noticed one character in this story that I haven’t introduced yet. His name is **[Greg Wilson](https://twitter.com/gvwilson)**. I tend to take such strong endorsements with a spoonful of skepticism and (spoiler alert) I’m happy to say I **fully** agree with everything that was said by those above. In that spirit, I’ll add my own glowing recommendation:

> Greg Wilson is truly a programming pedagogy expert, and an incredibly kind human being. I’m grateful to have learned from him within the context of the certification, and appreciate being able to continue learning from his example in a variety of other contexts.

Nevertheless, I’m glad I got to do a gut-check beforehand when I attended the [RStudio Instructor Certification Panel](https://www.youtube.com/watch?v=582tMkPvloU) hosted by the MiR Community and facilitated by [Dorris Scott](https://twitter.com/Dorris_Scott) and [Danielle Smalls-Perkins](https://twitter.com/smallperks). You’ll notice Yanina and Shelmith were two of the panelists! Hearing from this panel was the last piece of the puzzle I needed to feel like pursuing the certification was an **enthusiastic yes**.

<iframe style="display: block; margin: auto;" width="560" height="315" src="https://www.youtube.com/embed/582tMkPvloU" frameborder="0" allowfullscreen>
</iframe>

# Certification components

The certification itself has three components:

1.  **Instructor training covering modern teaching methods**. Materials for this training are [available here](https://drive.google.com/drive/folders/13ohFt3D0EJ5PDbMaWTxnHH-hwA7G0IvY) and are based on the book [Teaching Tech Together](https://teachtogether.tech/) written by Greg (and currently undergoing translation into Spanish by a team of volunteers!).

2.  A 90-minute **teaching exam** based on content from the instructor training. This includes a 15-minute demonstration lesson and a written component.

3.  A 90-minute **Tidyverse exam** to test your knowledge of the subject matter in [R for Data Science](https://r4ds.had.co.nz/) (make sure to check the [program FAQs](https://education.rstudio.com/trainers/#faq) for information about the Shiny exam)

# Learning the pedagogy

When I completed the instructor training on pedagogy it took place completely online over three days. The first two days were dedicated to the materials linked in the earlier section and were taught by Greg. Despite the training starting at 7am for me, I *really* enjoyed it! There were 12 of us in the cohort and there were a handful of opportunities for us to do activities in small groups and multiple opportunities to practice the teaching tools that will help us better support R learners in our own teaching.

Some of my favorite topics were mental models, cognitive capacity, and formative assessments. At the heart of all three is the concept map, which serves as a guide for reverse-designing a lesson and delivering it effectively. You can find examples of concept maps [here as slides](https://docs.google.com/presentation/d/1ForBjP0pVhljBLuqOyYfyHw_1rrwJzpWW1ZHzCqAJpU/edit?ts=5f10c02e#slide=id.p) and [here on GitHub](https://github.com/rstudio/concept-maps/). I’ve found concept maps to come in handy in so many other places in my life and I even made one to help me plan out this blog post. Check it out:

<img src="RIT-post-concept-map.jpg" title="Concept map showing &quot;RStudio Instructor Certification&quot; at the center and various concepts and connections pointing to it. Including MiR webinar, teaching exam, R4DS, and others. These form the different components of the blog post and was helpful in planning out what to write about." alt="Concept map showing &quot;RStudio Instructor Certification&quot; at the center and various concepts and connections pointing to it. Including MiR webinar, teaching exam, R4DS, and others. These form the different components of the blog post and was helpful in planning out what to write about." width="75%" style="display: block; margin: auto;" />

The third day of training, our cohort had the pleasure of learning all about using the [`learnr` 📦](https://rstudio.github.io/learnr/) to build interactive R tutorials, from [Mine Çetinkaya-Rundel](https://education.rstudio.com/trainers/people/cetinkaya-rundel+mine/):

-   <i class="fas fa-link"></i> Course website: [rstd.io/rit](https://rstudio-education.github.io/instructor-training/)
-   <i class="fas fa-images"></i> Slides: [building interactive tutorials in R](https://rstudio-education.github.io/instructor-training/slides/tutorial.html)
-   <i class="fas fa-folder"></i> RStudio Cloud project: [rstd.io/rit-cloud](https://rstd.io/rit-cloud)
-   <i class="fab fa-github"></i> Source materials: [rstudio-education/instructor-training](https://github.com/rstudio-education/instructor-training)

# Preparing for the exams

## Teaching exam

I relied on the [instructor training materials](https://drive.google.com/drive/folders/13ohFt3D0EJ5PDbMaWTxnHH-hwA7G0IvY) and my in-class notes to prepare my demonstration lesson and study for the written component of the teaching exam. For anything that didn’t fully sink in, I consulted [Teaching Tech Together](https://teachtogether.tech/).

You can find [all materials for my teaching demonstration](https://github.com/spcanelon/rit-teaching-exam) on GitHub. They include the slides below and [this R Markdown file](https://github.com/spcanelon/rit-teaching-exam/blob/master/lubridate_livecode.Rmd) that I used to incorporate live coding into the lesson.

I found an excellent reference for a demonstration lesson in [Florencia D’Andrea](https://education.rstudio.com/trainers/people/dandrea+florencia/)’s post [Two examples of iteration with purrr - Class for the RStudio certification](https://florencia.netlify.app/2020/06/two-examples-of-iteration-with-purrr.en-us/).

It comes highly recommended that someone take a look at each one of our lessons before it ships out because it seems it’s common not to realize we’ve packed too much in! Yanina was kind enough to sit through my lesson as a learner and provided fantastic feedback. Some of the things I was able to work on before my teaching exam included providing context for the lesson at the beginning (asking the learner to download the file, introducing the lesson in the context of a workshop, etc.) and talking through all my key strokes during the live coding portions. Thanks again Yani!

<div class="shareagain" style="min-width:300px;margin:1em auto;">
<iframe src="https://spcanelon.github.io/rit-teaching-exam" width="1600" height="900" style="border:2px solid currentColor;" loading="lazy" allowfullscreen></iframe>
<script>fitvids('.shareagain', {players: 'iframe'});</script>
</div>

## Tidyverse exam

Lucky for me the MiR Community organized some study sessions specifically for preparing for the Tidyverse exam! Dorris and I met regularly to discuss our approach to the sample exam (v2.0) and present chapters of *R for Data Science* that we weren’t as comfortable with. Yanina joined us for some of the sessions to lend us her expertise and provide tips and tricks!

One of the recommendations Yanina made was to explore the [RStudio Primers](https://rstudio.cloud/learn/primers) for any topic we wanted to practice. For me that meant **iteration** using `purrr`’s `map` functions. After the iteration primer and the companion *R for Data Science* chapter, I felt like I could iterate all day every day.

In real life, both the written portion of the teaching exam and the Tidyverse exam are very much like the sample exams provided on the RStudio Education blog. You can find those here:

-   Sample exam v1.0 (February 2020): [Instructor Certification Exams](https://education.rstudio.com/blog/2020/02/instructor-certification-exams/)
-   Sample exam v2.0 (August 2020): [More sample exams](https://education.rstudio.com/blog/2020/08/more-example-exams/)

If you’re a member of the MiR Community and like the idea of studying with some structure and friendly accountability, join us for the study group! And if you’re not, you can [learn more about joining MiR as a member or ally here](https://docs.google.com/forms/d/1x3eFj0syKeFkEQVg1XNSDOFlbOCkIDseKxKeC8or1-U/viewform?edit_requested=true).

# Additional resources

## Teaching resources

-   <i class="fas fa-images"></i> [Slides for the instructor training course • Greg Wilson](https://drive.google.com/drive/folders/13ohFt3D0EJ5PDbMaWTxnHH-hwA7G0IvY)
-   <i class="fas fa-book"></i> [Teaching Tech Together • Greg Wilson](https://teachtogether.tech/)
-   <i class="fas fa-link"></i> [Teaching R and Data Science with RStudio • Mine Çetinkaya-Rundel](rstd.io/rit)
-   <i class="fas fa-link"></i> [Teaching in Production • Alison Hill](rstd.io/tip)
-   <i class="fab fa-youtube"></i> [Teaching Online at Short Notice - RStudio 2020 • Greg Wilson](https://www.youtube.com/watch?v=-2enQV3Dfng)
-   <i class="fab fa-youtube"></i> [Sharing on Short Notice - RStudio 2020 • Alison Hill & Desirée De Leon](https://www.youtube.com/watch?v=QcE4RBH2auQ)
-   <i class="fab fa-youtube"></i> [Evidence Based Teaching: What We Know and How to Use It - EuroSciPy 2015 • Greg Wilson](https://www.youtube.com/watch?v=kmVKGxPlTvc)
-   <i class="fab fa-github"></i> [rstudio-education/r4ds-instructors: Instructors’ Guide to accompany “R for Data Science” • RStudio Education](https://github.com/rstudio-education/r4ds-instructors)
-   <i class="fas fa-link"></i> [Cursos cortos para enseñar online • MetaDocencia](https://www.metadocencia.org/)
-   <i class="fas fa-link"></i> [Flattening the leaRning curve: Teaching R online during COVID-19 • Brendan Cullen](https://bcullen.rbind.io/post/2020-10-19-teaching-an-r-bootcamp-remotely/)

## Experiences with the certification process

-   Yanina Bellini Saibene – [Obtaining RStudio certification. A shared path](https://yabellini.netlify.app/post/rstudiocertification/)
-   Shelmith Kariuki – [The RStudio Certification Process](https://shelkariuki.netlify.app/post/certification/)
-   Ted Laderas – [My Experience with RStudio Instructor Training](https://education.rstudio.com/blog/2019/11/my-experience-with-rstudio-instructor-training/#tidyverse-certification-exam)
-   Rayna Harris – [A Review: RStudio Teaching Certification Course](https://www.raynamharris.com/blog/rstudioTTT/)
-   Brendan Cullen – [Reflections on RStudio Instructor Training](https://bcullen.rbind.io/post/2020-09-03-reflections-on-rstudio-instructor-training/)
-   Yuqi Liao – [Getting Certified as an RStudio Instructor](https://www.yuqiliao.com/blog/rstudiocertification/)
-   Beatriz Milz – [Certificação da RStudio](https://beatrizmilz.com/posts/2021-03-02-certificacao-rstudio/)
-   Rohan Alexander – [In Appreciation of Greg Wilson](https://rohanalexander.com/posts/2021-03-14-greg-wilson/)

## Teaching exam examples

-   Silvia Canelón
    -   [Lesson slides: Using lubridate to work with time intervals](https://spcanelon.github.io/rit-teaching-exam)
    -   [GitHub repo](https://github.com/spcanelon/rit-teaching-exam)
-   Yanina Bellini Saibene
    -   [Lesson materials: Concept map and formative assessments](https://docs.google.com/document/d/1Z8zhRjK7tQ-VcOUMnOmxKNb2Ra_3DKsvMzo1iGeIt0I/edit)
    -   [Lesson slides: Código en R Markdown](https://docs.google.com/presentation/d/1Uzb5sHM54_t6NWLSDely6fCi8Nu4qhCT-qxMKY-vh78/edit#slide=id.p)
    -   [GitHub repo](https://github.com/yabellini/RStudioCT)
-   Paloma Rojas-Saunero
    -   [Lesson overview](https://palolili23.github.io/texam/teaching_exam.html)
    -   [Lesson slides: Tidy data](https://palolili23.github.io/texam/slides.html)
    -   [Lesson script: Tidyr: Reshape](https://palolili23.github.io/texam/tidyr.html)
-   Florencia D’Andrea
    -   [Lesson slides: Iteration with purrr package for automatized file management](https://flor14.github.io/purrr_slides/purrr_class_15min#1)
    -   [Blog post: Two examples of iteration with purrr - Class for the RStudio certification](https://florencia.netlify.app/2020/06/two-examples-of-iteration-with-purrr.en-us/)
    -   [GitHub repo](https://github.com/flor14?tab=repositories&q=purrr_&type=&language=)
-   Beatriz Milz
    -   [Lesson slides: Adding figures in R Markdown](https://beatrizmilz.github.io/RStudio_Certification)
    -   [GitHub repo](https://github.com/beatrizmilz/RStudio_Certification)
-   Laurie Baker
    -   [Lesson slides](https://laurielbaker.github.io/r-studio-instructor-training/slides/lubridate_slides.html#1)
    -   [GitHub repo](https://github.com/LaurieLBaker/r-studio-instructor-training#rstudio-instructor-certification-teaching-exam)
-   Corrado Lanera
    -   [Lesson slides: (Meta)data texting in {ggplot2}](https://corradolanera.github.io/rs-teaching-exam/)
    -   [GitHub repo](https://github.com/CorradoLanera/rs-teaching-exam)
-   Brendan Cullen
    -   [Lesson slides: Column-wise operations with dplyr: Old and New](https://columnwise-operations-dplyr.netlify.app/)
    -   [GitHub repo](https://github.com/brendanhcullen/rstudio-instructor-certification)
-   Adi Sarid
    -   [GitHub repo: Exercise on purrr](https://github.com/adisarid/rstudio_certification_exam)
-   David John Baker
    -   [Lesson slides: Learn to Pivot!](https://docs.google.com/presentation/d/1MFstJ3qFF1kK5dHJubn7KsPb2kcPSmuLnvHSP3QiFEA/edit?usp=sharing)
    -   [GitHub repo](https://github.com/davidjohnbaker1/rstudio_certification_training)
-   Yuqi Liao
    -   [Lesson slides: Creating animated visualizations in R](https://animationr.netlify.app/#1)
    -   [GitHub repo](https://github.com/yuqiliao/RStudio_TeachingSample)
-   Luis Verde
    -   [GitHub repo](https://github.com/luisDVA/example-lesson)

## Tidyverse sample exam solutions

-   Silvia Canelón – [August 2020 sample exam (v2.0)](tidyverse-sample-exam-solutions.html)
-   Brendan Cullen – [August 2020 sample exam (v2.0)](https://tidyverse-exam-v2-solutions.netlify.app/)
-   Marly Gotti – [February 2020 sample exam (v1.0)](https://marlycormar.github.io/tidyverse_sample_exam/sample_exam_sols/sols.html)
-   Ezekiel Adebayo Ogundepo – [August 2020 sample exam (v2.0)](https://rpubs.com/gbganalyst/tidyverse-sample-exam)
