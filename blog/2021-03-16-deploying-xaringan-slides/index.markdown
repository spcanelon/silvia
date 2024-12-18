---
title: "Deploying xaringan Slides with GitHub Pages"
author: Silvia Canelón
date: '2021-03-16'
slug: deploying-xaringan-slides
image: featured.png
alias:
  - /blog/deploying-xaringan-slides/
  - /blog/2021-03-16-deploying-xaringan-slides/
categories:
  - R
  - tutorial
  - xaringan
  - git
subtitle: 'A ten-step workflow for creating an HTML xaringan slide deck and deploying it to the web using GitHub Pages'
summary: 'A ten-step workflow for creating an HTML xaringan slide deck and deploying it to the web using GitHub Pages'
links:
  - icon: calendar-check
    icon_pack: fas
    name: R-Ladies Talk
    url: ../../talk/2021-03-16-xaringan-deploy-demo/
  - icon: github
    icon_pack: fab
    name: R-Ladies template files
    url: https://github.com/spcanelon/RLadies-xaringan-template
  - icon: images
    icon_pack: far
    name: R-Ladies template slides
    url: https://spcanelon.github.io/RLadies-xaringan-template
---

> This post was featured in the RStudio Blog *R Views* under a revised title: [Deploying xaringan Slides with GitHub Pages](https://rviews.rstudio.com/2021/11/18/deploying-xaringan-slides-a-ten-step-github-pages-workflow/). The original title was “Deploying xaringan Slides: A Ten-Step GitHub Pages Workflow.” Other changes include an introductory paragraph and greater clarity in the “Choose your own adventure” section. Many thanks to Chief Editor Joe Rickert for a very encouraging and helpful editorial process! I am humbled by his note on R Views:
>
> *Silvia’s post is a mini masterpiece of clear, concise writing that elucidates complex technology within the narrow context of explaining a single well-defined task. Silvia does not attempt to say everything she knows about the subject, and she resists digressions that might obscure the path she is laying out. It is an example of achieving clarity through saying less.*

------------------------------------------------------------------------

This post will guide you step-by-step through the process of creating an HTML xaringan slide deck and deploying it to the web for easy sharing with others. We will be using the `xaringan` package to build the slide deck, GitHub to help us host our slides for free with GitHub Pages, and the `usethis` package to help us out along the way. You will get the most out of this workflow if you are already familiar with R Markdown and GitHub, and if you have already connected RStudio (or your preferred IDE) to Git and GitHub.[^1] The post will not cover the nuts and bolts of xaringan or talk about slide design & customization, but you can find lots of [learning resources](#learn-more) listed at the end.

# Choose your own adventure

-   **Option 1:** Start at the [beginning of the workflow](#the-ten-step-workflow) to make a slide deck using the R Markdown template built into the `xaringan` package. The built-in template doubles as documentation for the `xaringan` package, so it is a great way to familiarize yourself with the package features, but it also includes a lot of content that you will probably want to remove and modify when creating your presentation.

-   **Option 2:** Start with an [R-Ladies themed xaringan template](https://spcanelon.github.io/RLadies-xaringan-template) (embedded below). This is an example slide deck originally created as a teaching tool to highlight some of the main features of the `xaringan` package, and to demo some customization that incorporates the R-Ladies CSS theme built into xaringan. Please feel welcome to use/modify it to suit your needs! When you are ready, you can follow the steps immediately below 👇 to download the files to your machine, and then skip down to [Initialize version control with git](#initialize-version-control-with-git).

``` r
usethis::use_course(
  repo_spec = "spcanelon/RLadies-xaringan-template",
  destdir = "filepath/for/your/presentation"
  )
```

> Note: After copying the files to your machine you’ll probably want to rename the file folder to whatever makes sense for your presentation.

<div class="shareagain" style="min-width:300px;margin:1em auto;text-align:center;">
<iframe src="https://spcanelon.github.io/RLadies-xaringan-template" width="400" height="300" align="center" style="border:2px solid currentColor;" loading="lazy" allowfullscreen></iframe>
<script>fitvids('.shareagain', {players: 'iframe'});</script>
</div>

> Try navigating through the slides ☝️ with your left/right arrow keys and press the letter “P” on your keyboard to see some notes in Presenter View

# The Ten-Step Workflow

## Packages

This workflow was developed using:

| Software / package | Version  |
|--------------------|----------|
| R                  | 4.0.3    |
| RStudio            | 1.4.1103 |
| `xaringan`         | 0.19     |
| `usethis`          | 2.0.0    |

``` r
install.packages("xaringan")
install.packages("usethis")
```

## Creating your xaringan slide deck

**1. Create a new RStudio project for your presentation:**

``` r
usethis::create_project("filepath/for/your/presentation/repo-name")
```

> 📍 If you’re not sure where you are on your computer, check your working directory with `getwd()` and use it as a filepath reference point

<!--Output:    
    
    ```r
    New project 'rladies-xaringan-template' is nested inside an existing project '/filepath/for/the/presentation/', which is rarely a good idea.
    If this is unexpected, the here package has a function, `here::dr_here()` that reveals why '/filepath/for/the/presentation/' is regarded as a project.
    Do you want to create anyway?
    
    1: Absolutely not
    2: Yup
    3: No
    
    Selection: 2
    ```
-->

**2. Create a xaringan deck using a xaringan template:**<br>
*File* &gt; *New File* &gt; *R Markdown* &gt; *From Template* &gt; *Ninja Presentation* &gt; *OK*

**3. Delete what you don’t need and save your R Markdown file with whatever name you like.** If you pick `index.Rmd` the live link you share at the end will be relatively short.

**4. Render HTML slides from the open Rmd file using xaringan’s infinite moon reader:**

``` r
xaringan::infinite_moon_reader()
```

## Initialize version control with git

**5. Initialize version control of your slides with git:**

``` r
usethis::use_git()
```

You’ll be asked if you want to commit the files in your project (with the message “Initial commit”) and then if you want to restart to activate the Git pane. Say yes to both ✅

> Note: At the moment `usethis` names the primary branch “master” by default. [Issue \#1341](https://github.com/r-lib/usethis/issues/1341) suggests the option to instead name it “main” is in the works.

<!--Output:
> usethis::use_git()
✓ Setting active project to '/filepath/for/the/presentation/rladies-xaringan-template'
✓ Initialising Git repo
✓ Adding '.Rhistory', '.Rdata', '.httr-oauth', '.DS_Store' to '.gitignore'
There are 6 uncommitted files:
* '.gitignore'
* 'index_files/'
* 'index.html'
* 'index.Rmd'
* 'libs/'
* 'rladies-xaringan-template.Rproj'
Is it ok to commit them?

1: Yup
2: Negative
3: No way

Selection: 1


✓ Adding files
✓ Making a commit with message 'Initial commit'
● A restart of RStudio is required to activate the Git pane
Restart now?

1: Yes
2: Nope
3: Not now

Selection: 

-->

**6. Connect your local project with a GitHub repo:**

``` r
usethis::use_github()
```

> You could use the function argument `private = TRUE` to create a private GitHub repository. But you may have to remember to change the visibility before [deploying to GitHub Pages](#deploying-your-slides).

<!--Output:
> usethis::use_github(private = TRUE)
ℹ Defaulting to https Git protocol
✓ Setting active project to '/filepath/for/the/presentation/rladies-xaringan-template'
✓ Checking that current branch is default branch ('master')
✓ Creating private GitHub repository 'spcanelon/rladies-xaringan-template'
✓ Setting remote 'origin' to 'https://github.com/spcanelon/rladies-xaringan-template.git'
✓ Pushing 'master' branch to GitHub and setting 'origin/master' as upstream branch
✓ Opening URL 'https://github.com/spcanelon/rladies-xaringan-template'
-->

**7. Your new GitHub repo with all of your xaringan project files will automatically open up in your browser**

> Repo for the R-Ladies xaringan template:<br>
> https://github.com/spcanelon/RLadies-xaringan-template

## Making and committing changes to your slides

**8. Edit your slides as you wish.** Commit often! And then push to GitHub. Use the tools provided by the Git pane in RStudio, or use the following commands in the Terminal:

``` bash
# Step 1: Stage all modified files
git add .
```

``` bash
# Step 2: Describe the changes you made to your files
git commit -m "<A brief but descriptive commit message>"
```

> Consider writing a commit message that finishes the following sentence:[^2] “If applied, this commit will…” (e.g. “Change the slide theme,” “Add hello slide”)

``` bash
# Step 3: Push the changes to your GitHub repository
git push
```

## Deploying your slides

**9. When you’re ready to deploy your slides, you can use the `usethis::use_github_pages()` function** which makes the process of deploying via GitHub Pages super easy. I recommend pointing `branch` to the name of your primary branch.

``` r
usethis::use_github_pages(branch = "master")
```

> Note: Your repository must be **public** for your deployed slides to be available publicly, unless you have a paid GitHub account.

> Also, you only need to follow this step *once* to deploy your slides to the web. As long as you remember to push to your repo any changes that you make to your slides (Rmd and HTML), GitHub Pages will know how to render them.

<!--Output:
> usethis::use_github_pages(branch = "master")
✓ Setting active project to '/Users/scanelon/Box/2-Teaching/R-Projects/R-Ladies/RLadies-xaringan-template'
✓ Activating GitHub Pages for 'spcanelon/rladies-xaringan-template'
✓ GitHub Pages is publishing from:
● URL: 'https://spcanelon.github.io/RLadies-xaringan-template/'
● Branch: 'master'
● Path: '/'
-->

**10. Visit the link provided to see your newly deployed slides!** 🚀<br>Don’t panic if you don’t see them right away, sometimes it takes a little time. This is the link you will share with the world when you present. Notice it looks *very* similar to your GitHub repo link.

> Link to the R-Ladies xaringan template rendered slides:<br>
> https://spcanelon.github.io/RLadies-xaringan-template

# Bonus steps

11\. Go to the [repository home page](https://github.com/spcanelon/RLadies-xaringan-template) and find the About section on the right hand side. Add a description of your presentation and the link to your slides, that way your presentation is easily available to anyone visiting your repo.

12\. Check out Garrick Aden-Buie’s blog post Sharing Your `xaringan` Slides to learn how to [create a social media card](https://www.garrickadenbuie.com/blog/sharing-xaringan-slides/#create-a-social-media-card) for your slides and use your new link to share your slides in more places (e.g. [embedded on a website](https://www.garrickadenbuie.com/blog/sharing-xaringan-slides/#embed-your-slides), etc.)

13\. This GitHub Pages workflow is not exclusive to `xaringan` slides! Try it out with any other HTML file.

# Learn more

## Foundation

-   [Sharing Your Work with xaringan • Silvia Canelón](https://spcanelon.github.io/xaringan-basics-and-beyond/index.html) – workshop site
-   [Introducción al Paquete xaringan • Silvia Canelón](https://silvia.rbind.io/talk/2020-12-17-introduccion-xaringan/) – R-Ladies Meetup
-   [Making Slides with R Markdown • Alison Hill](https://arm.rbind.io/slides/xaringan.html) – workshop slides
-   [Presentation Ninja • xaringan Official Document](https://slides.yihui.org/xaringan/) – package documentation
-   [Chapter 7 xaringan Presentations • R Markdown: The Definitive Guide](https://bookdown.org/yihui/rmarkdown/xaringan.html) – book chapter

## Sharing your slides

-   [Sharing Your xaringan Slides • Garrick Aden‑Buie](https://www.garrickadenbuie.com/blog/sharing-xaringan-slides/) – blog post
-   [Functions For Building Xaringan Slides To Different Outputs • xaringanBuilder](https://jhelvy.github.io/xaringanBuilder/) – package site
-   [Sharing on Short Notice • Alison Hill & Desirée De Leon](https://alison.rbind.io/talk/2020-sharing-short-notice/) – video resource for deploying via Netlify

## Making your slides extra special

-   [Professional, Polished, Presentable • Garrick Aden‑Buie & Silvia Canelón • useR!2021](https://presentable-user2021.netlify.app/) – site for an intermediate xaringan workshop
-   [Home • yihui/xaringan Wiki • GitHub](https://github.com/yihui/xaringan/wiki) – wiki of customizations for xaringan
-   [Making Extra Great Slides • Garrick Aden‑Buie](https://www.garrickadenbuie.com/talk/extra-great-slides-nyhackr/) – talk & slides with xaringan overview and featuring CSS styling and xaringanthemer
-   [Applying design guidelines to slides with {xaringanthemer} • katie jolly](https://www.katiejolly.io/blog/2021-03-16/designing-slides) – blog post
-   [A playground of extensions for xaringan • xaringanExtra](https://pkg.garrickadenbuie.com/xaringanExtra/#/?id=xaringanextra) – package site
-   [Custom xaringan CSS Themes • xaringanthemer](https://pkg.garrickadenbuie.com/xaringanthemer/) – package site

[^1]: [Chapter 12 Connect RStudio to Git and GitHub \| Happy Git and GitHub for the useR](https://happygitwithr.com/rstudio-git-github.html)

[^2]: [How to Write a Git Commit Message \| Chris Beams](https://chris.beams.io/posts/git-commit/#imperative)
