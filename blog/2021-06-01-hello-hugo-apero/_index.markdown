---
title: "Hello Hugo Apéro: Converting a Blogdown Site from Hugo Academic"
date: '2021-06-01'
slug: hello-hugo-apero
image: featured.png
alias:
  - /blog/hello-hugo-apero/
  - /blog/2021-06-01-hello-hugo-apero/
categories:
  - R
  - website
  - tutorial
  - git
  - blogdown
  - hugo
subtitle: 'A tutorial on how to take your personal Hugo Academic/Wowchemy website and convert it to the Hugo Apéro theme'
summary: 'A tutorial on how to take your personal Hugo Academic/Wowchemy website and convert it to the Hugo Apéro theme'
links:
  - icon: glass-cheers
    icon_pack: fas
    name: Hugo Apéro Docs
    url: https://hugo-apero-docs.netlify.app/
---
<script src="{{< blogdown/postref >}}index_files/clipboard/clipboard.min.js"></script>
<link href="{{< blogdown/postref >}}index_files/xaringanExtra-clipboard/xaringanExtra-clipboard.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/xaringanExtra-clipboard/xaringanExtra-clipboard.js"></script>
<script>window.xaringanExtraClipboard(null, {"button":"<i class=\"fa fa-clipboard\"><\/i> Copy Code","success":"<i class=\"fa fa-check\" style=\"color: #90BE6D\"><\/i> Copied!","error":"Press Ctrl+C to Copy"})</script>
<link href="{{< blogdown/postref >}}index_files/font-awesome/css/all.css" rel="stylesheet" />
<link href="{{< blogdown/postref >}}index_files/font-awesome/css/v4-shims.css" rel="stylesheet" />



<style type="text/css">
.page-main img {
  box-shadow: 0px 0px 2px 2px rgba( 0, 0, 0, 0.2 );
}
</style>

## What to expect

By the end of the tutorial you will have switched your website from using the Hugo Academic theme to using the new [Hugo Apéro theme designed by Alison Hill](https://alison.rbind.io/project/hugo-apero/) <i class="fas fa-glass-cheers pr2"></i> 

Specifically you will be able to migrate your blog, publications, and talks. If you need to migrate courses, I recommend taking a look at how [Alison](https://alison.rbind.io/project/) and [Kelly Bodwin](https://www.kelly-bodwin.com/courses/) organized their courses and workshops into projects using this theme. I didn't have projects prior to converting my site, but after creating a few projects post-Apéro I'm confident any projects you've created pre-Apéro will carry over easily.

<details><summary>Projects on my site: https://silvia.rbind.io/project</summary>
<div class="figure" style="text-align: center">
<img src="img/silvia-project-list.png" alt="The Project listing page for my site with a grid layout featuring thumbnail images. The top of the page says 'Projects' and below is a short description of what can be found on the page. It also includes a by-line that reads 'Written by Silvia Canelón.' There are three projects featured with a decorative thumbnail image, a title, and a summary. Items also include an author and category links but they are cut off in this screenshot." width="1265" />
<p class="caption">Figure 1: My Project listing: https://silvia.rbind.io/project</p>
</div>
</details>

If you like videos, Alison recorded a [walkthrough of this conversion process](https://youtu.be/oBtDgW9u7Nw) using Julia Silge's site as an example.

**What _not_ to expect**

A tutorial on how to create a Hugo Apéro site from scratch -- but don't worry! Alison covers this in a [workshop she gave for R-Ladies Tunis](https://alison.rbind.io/talk/2021-iyo-tunis/) and in the [Get started series of blog posts](https://hugo-apero-docs.netlify.app/start/) included in the documentation site.

## The Plan

I was lucky that Alison had already started converting her own personal site because she gave me a template and example to follow! <i class="fas fa-hands-helping"></i>

We'll follow the steps below throughout the tutorial and each of the six steps comes with its own commit in my git history, so you can see exactly what I changed and when. <i class="fas fa-code-branch"></i>

{{< tweet 1370027805543698432 >}}

Then we'll [reuse and migrate](#migrating-the-content) your existing content, set up a [contact form](#contact-form), [tidy up your directory](#tidying-up-your-directory), explore some resources for [customizing your new site](#customizing-your-site), and end with the grand finale: [deploying your new site](#deploying-your-new-site)!

## Prework

### Branch deploy

Create a new `apero` branch from the primary branch of your website repository

1. `git checkout -b apero` to create new local branch

1. `git push --set-upstream origin apero` to push new branch to GitHub

Create a new Netlify deploy from your `apero` branch by enabling branch deploys on Netlify.com. Garrick Aden-Buie kindly provided some great resources on how to do this [on Twitter](https://twitter.com/grrrck/status/1384960915276275715). Netlify will automatically deploy a live preview of your site from your new branch to a link like **\<branch-name>\--silvia.netlify.app**. In my case it was https://apero--silvia.netlify.app

<i class="fas fa-route pr2"></i>Site settings: Build & deploy > Continuous Deployment > Deploy contexts

<div class="figure" style="text-align: center">
<img src="img/netlify-branch-deploy.png" alt="The deploy contexts section after clicking the Edit settings button. This section shows three settings that can be edited. The first is the production branch which is set to 'main' in a free text box. The second is deploy previews which is a radio button set to 'any pull request against your production branch/branch deploy branches (as opposed to 'none'). The third is branch deploys which is a radio button set to 'all' (as opposed to 'none' and 'let me add individual branches'). There are two buttons at the bottom of this section, Save and Cancel." width="75%" />
<p class="caption">Figure 2: Netlify site settings for deploy contexts</p>
</div>

Your new apero branch deploy at this point is an independent copy of your current website so from here on out you can make changes freely without affecting anything in your main branch :tada:

### Hugo version

The last piece of prework before we dive in is to update your local version of Hugo and update the Hugo version accordingly in a few different places.
  
1. Update Hugo locally using `blogdown::install_hugo()` (for me the latest version was v0.82.1)
  
    ```r
    blogdown::install_hugo()
    ```

2. Update **.Rprofile** and then restart R per the instructions that appear in the console.
    
    ```r
    # fix Hugo version
    options(blogdown.hugo.version = "0.82.1")
    ```

3. Update **netlify.toml**
    
    ```r
    [context.production.environment]
      HUGO_VERSION = "0.82.1"
      HUGO_ENV = "production"
      HUGO_ENABLEGITINFO = "true"
    
    [context.branch-deploy.environment]
      HUGO_VERSION = "0.82.1"
    
    [context.deploy-preview.environment]
      HUGO_VERSION = "0.82.1"
    ```

4. Run `blogdown::check_site()` to find any issues. In my case these checking functions found a Hugo version mismatch and I ended up having to specifically run `blogdown::install_hugo("0.82.1")` to resolve it.

    <details><summary>Console output</summary>
    
    ```r
    ― Checking netlify.toml...
    ○ Found HUGO_VERSION = 0.82.1 in [build] context of netlify.toml.
    | Checking that Netlify & local Hugo versions match...
    | Mismatch found:  blogdown is using Hugo version (0.69.2) to build site locally.  Netlify is using Hugo version (0.82.1) to build site.
    ● [TODO] Option 1: Change HUGO_VERSION = "0.69.2" in netlify.toml to match local version.
    ● [TODO] Option 2: Use blogdown::install_hugo("0.82.1") to match Netlify version, and set options(blogdown.hugo.version = "0.82.1") in .Rprofile to pin this Hugo version (also remember to restart R).
    | Checking that Netlify & local Hugo publish directories match...
    ○ Good to go - blogdown and Netlify are using the same publish directory: public
    ― Check complete: netlify.toml
    ```
    
    </details>
    
If you end up needing to make your own changes, I recommend running `blogdown::check_site()` again when you're done to make sure you've resolved all of the issues. 

And then run `blogdown::serve_site()` to render a live preview of your site :rocket:

---

## 1. Install theme alongside Academic, change in **config.toml**

> <i class='fas fa-code-branch pr2'></i> Follow along with me at [commit cc5d24](https://github.com/spcanelon/silvia/commit/cc5d24d93676990675abc52145fd7a369c7bffa6)

The first step is to install all of the Hugo Apéro theme files to the `theme/` folder in your site directory:


```r
blogdown::install_theme(theme = "hugo-apero/hugo-apero",
                        update_config = FALSE, 
                        force = TRUE)
```

<details><summary>Console output</summary>


```r
trying URL 'https://github.com/hugo-apero/hugo-apero/archive/main.tar.gz'
downloaded 21.4 MB

Do not forget to change the 'theme' option in 'config.toml' to "hugo-apero"
Warning message:
The theme has provided an example site. You should read the theme's documentation and at least take a look at the config file config.toml (or .yaml) of the example site, because not all Hugo themes work with any config files. 
```

</details>

As indicated in console output, modify the **config.toml** file so it points to your new theme folder instead of `hugo-academic`:

```toml
#theme = "hugo-academic"
theme = "hugo-apero"
```

<i class="fas fa-exclamation-circle pr2"></i> At this point you will probably start to get some error messages like the one below. Don't panic! Let's get through the rest of the steps first. I'm including my errors in this post in case they are helpful/validating for you!

```r
Could not build site because certain shortcodes weren't found

Error: Error building site: "/Users/silvia/Documents/Website/silvia/content/home/demo.md:58:1": failed to extract shortcode: template for shortcode "alert" not found
```

## 2. Copy all Academic shortcodes to **layouts/** root (remove later)

> <i class='fas fa-code-branch pr2'></i> Follow along with me at [commit f3c7d53](https://github.com/spcanelon/silvia/commit/f3c7d5334b4effbd850b204eb267425f6740b4af)

Copy the shortcodes

- From `themes/hugo-academic/layouts/shortcodes/` 

- To `layouts/shortcodes/`

<i class="fas fa-exclamation-circle pr2"></i> My error message:

```r
Error: Error building site: TOCSS: failed to transform "style.main.scss" (text/x-scss): SCSS processing failed: file "stdin", line 7, col 24: Invalid CSS after "...textFontFamily:": expected expression (e.g. 1px, bold), was "<no value>;"
```

## 3. Remove all assets

> <i class='fas fa-code-branch pr2'></i> Follow along with me at [commit 3843c76](https://github.com/spcanelon/silvia/commit/3843c76a5da6184b2d9b547b18f96ec6810a695a)

Before deleting anything, I recommend making a backup of your entire website folder, just in case.

In the `assets/` root folder, delete:

- the `images/` folder which might contain your site icon

- the `scss/` folder which might contain your `custom.scss` file

<i class="fas fa-exclamation-circle pr2"></i> My error message:

```r
Error: Error building site: TOCSS: failed to transform "style.main.scss" (text/x-scss): SCSS processing failed: file "stdin", line 7, col 24: Invalid CSS after "...textFontFamily:": expected expression (e.g. 1px, bold), was "<no value>;"
```

## 4. Remove all custom layouts

> <i class='fas fa-code-branch pr2'></i> Follow along with me at [commit 1ad7e3d](https://github.com/spcanelon/silvia/commit/1ad7e3d491d309e71e1b4fa0bbad1e3af6b9d322)

I had a couple of partials that I deleted from the `layouts/` folder:

- **partials/site_footer.html** which provided a custom footer for my website
- **partials/widgets/about.html** which included the custom formatting for certificates in the Education section of the About page of my Academic site

<i class="fas fa-exclamation-circle pr2"></i> My error message:

```r
Error: Error building site: TOCSS: failed to transform "style.main.scss" (text/x-scss): SCSS processing failed: file "stdin", line 7, col 24: Invalid CSS after "...textFontFamily:": expected expression (e.g. 1px, bold), was "<no value>;"
```

## 5. Copy over Apéro example site **config.toml** file

> <i class='fas fa-code-branch pr2'></i> Follow along with me at [commit db37289](https://github.com/spcanelon/silvia/commit/db37289e768640522130f98353996de4a6e0abfc)

Rename **config.toml** in the root folder to **config_old.toml**

Copy **config.toml** 

- From `themes/hugo-apero/exampleSite/`

- To your root directory (in my case it was `silvia/`)

<i class="fas fa-exclamation-circle pr2"></i> My error message:

```r
Error: Error building site: failed to render pages: render of "page" failed: execute of template failed: template: _default/single.html:3:8: executing "_default/single.html" at <partial "head.html" .>: error calling partial: "/Users/silvia/Documents/Website/silvia/themes/hugo-apero/layouts/partials/head.html:14:53": execute of template failed: template: partials/head.html:14:53: executing "partials/head.html" at <js>: can't evaluate field Build in type string
```

## 6. Remove Academic **config/** directory

> <i class='fas fa-code-branch pr2'></i> Follow along with me at [commit 5541f38](https://github.com/spcanelon/silvia/commit/5541f38871911d5067c6c8856936d54d183b3ec9)

Delete the `config/` folder from your root directory (in my case `silvia/`)

I learned [the hard way](https://github.com/hugo-apero/hugo-apero-docs/issues/78) that the error below was due to not using an updated version of Hugo, which is why I included that step in the [Prework](#hugo-version). All this to say, I'm hoping you don't see the error below!

<i class="fas fa-exclamation-circle pr2"></i> My error message:

```r
Error: Error building site: failed to render pages: render of "page" failed: execute of template failed: template: _default/single.html:3:8: executing "_default/single.html" at <partial "head.html" .>: error calling partial: "/Users/silvia/Documents/Website/silvia/themes/hugo-apero/layouts/partials/head.html:14:53": execute of template failed: template: partials/head.html:14:53: executing "partials/head.html" at <js>: can't evaluate field Build in type string
```

---

## Migrating the content

Assuming you have made it this far and are able to at least serve a live site that uses the new Hugo Apéro theme, you are ready to start migrating your content! :tada:

File are organized differently in Hugo Apéro and the next steps detail the high-level changes I made to get my content to fit the new structure. The goal was to have my site parallel the [Hugo Apéro example site](https://hugo-apero.netlify.app/) and [Alison's personal site](https://alison.rbind.io).

### File organization

To get an overview of how the file structure is different between the Academic and Apéro themes we'll look at the  `content/` folder of the Apéro example site, my old Academic site, and my current Apéro site. These are organized into the panelsets below.

{{< panelset class="content directory" >}}
{{< panel name="Example Site" >}}
  
<i class="fas fa-route pr2"></i>Location: `silvia/themes/hugo-apero/exampleSite`

```bash
├── config.toml
├── content
    ├── _index.md
    ├── about
    ├── blog
    ├── collection
    ├── contributors.md
    ├── elements
    ├── form
    ├── license.md
    ├── project
    └── talk
```
{{< /panel >}}
{{< panel name="My Academic site" >}}

<i class="fas fa-route pr2"></i>Location: `silvia/`
  
```bash
.
├── config.toml
├── content
    ├── authors
    ├── courses
    ├── home
    ├── license.md
    ├── post
    ├── project
    ├── publication
    ├── slides
    └── talk
```
{{< /panel >}}

{{< panel name="My Apéro site" >}}

<i class="fas fa-route pr2"></i>Location: `silvia/`

```bash
.
├── config.toml
├── content
    ├── _index.md       # <-- new!
    ├── about           # <-- new!
    ├── blog            # <-- renamed (formerly post)
    ├── collection      # <-- new!
    ├── form            # <-- new!
    ├── license.md
    ├── project
    ├── publication
    └── talk
```
{{< /panel >}}
{{< /panelset >}}

### About page

Resource: [Customize your about page | Hugo Apéro](https://hugo-apero-docs.netlify.app/learn/about-page/)

My About page:

- [content/about/header/index.md](https://github.com/spcanelon/silvia/blob/bef8a7c9fd7b529e7cb58c3c92dafe59aa8d2259/content/about/header/index.md)
- [content/about/main/index.md](https://github.com/spcanelon/silvia/blob/bef8a7c9fd7b529e7cb58c3c92dafe59aa8d2259/content/about/main/index.md)
- [content/about/sidebar/index.md](https://github.com/spcanelon/silvia/blob/bef8a7c9fd7b529e7cb58c3c92dafe59aa8d2259/content/about/sidebar/index.md)


<div class="figure" style="text-align: center">
<img src="img/silvia-about-page-1.png" alt="My About page featuring a large headline to greet visitors and a short blurb about me in the header of the site. Below this area on the left in the main area of the page is more information with a heading and some prose. To the right of the main area is the sidebar which includes a small image, a name in large font, a subheading for the name, social media icons, and a spot for an audio clip for a name pronunciation. On the top edge of the page is a navigation bar with 'About' highlighted" width="1265" />
<p class="caption">Figure 3: The header of my About page: https://silvia.rbind.io/about/</p>
</div>

<div class="figure" style="text-align: center">
<img src="img/silvia-about-page-2.png" alt="Below the header is the main area of the page on the left with more information about me with a heading and some prose. To the right of the main area is the sidebar which includes a small image of me, my name in large font, my professional title underneath along with social media icons and a short list of my interests." width="1265" />
<p class="caption">Figure 4: The main section of my About page: https://silvia.rbind.io/about/</p>
</div>

I wanted to reuse my content from the About section of my Academic site, so I did a lot of copy-and-pasting into the right spots before editing. These steps are outlined in the table below. 

| Step | Content to copy      | From                                          | To                               |
|------|--------------------- |-----------------------------------------------|----------------------------------|
| 1    | Folder               | themes/hugo-apero/exampleSite/content/about/  | content/                         |
| 2    | Body part 1          | content/authors/silvia/_index.md              | content/about/header/index.md    |
| 3    | Body part 2          | content/authors/silvia/_index.md              | content/about/main/index.md      |
| 4    | Biography → outro    | content/authors/silvia/_index.md              | content/about/main/index.md      |
| 5    | Interests → link_list| content/authors/silvia/_index.md              | content/about/sidebar/index.md   |
| 6    | Photo                | content/authors/silvia/avatar.png             | content/about/sidebar/avatar.png |

### Homepage

Resource: [Customize your homepage | Hugo Apéro](https://hugo-apero-docs.netlify.app/blog/homepage/)

My homepage: [content/_index.md](https://github.com/spcanelon/silvia/blob/bef8a7c9fd7b529e7cb58c3c92dafe59aa8d2259/content/_index.md)

<div class="figure" style="text-align: center">
<img src="img/silvia-home-page.png" alt="The homepage of my site which shows my name in large font on the left, my title, social media icons, a short blurb about me, and a link that says 'Read More' that can be clicked to enter the site. On the right side is a photo of one of my favorite lakes." width="1280" />
<p class="caption">Figure 5: My Homepage: https://silvia.rbind.io</p>
</div>

1. Copy **_index.md** from `themes/hugo-apero/content/` to `content/`

1. Save an image for your homepage in the `static/img/` folder

1. Specify your homepage image in **_index.md**

### Blog

My blog listing: [content/blog/_index.md](https://github.com/spcanelon/silvia/blob/bef8a7c9fd7b529e7cb58c3c92dafe59aa8d2259/content/blog/_index.md)

<div class="figure" style="text-align: center">
<img src="img/silvia-blog-list.png" alt="The Blog listing page for my site with a sidebar layout and thumbnails enabled. There is a sidebar on the left side with some information about my blog including a blog name 'Meeting People Where They R'. It also includes my name as the blog author, a link to subscribe via RSS, and a decorative image of a small potted cactus plant sitting on top of a stack of books. On the right side in the main area of the page there are two blog posts featured, including this one. Each has a title, a summary, the date, and a decorative image as the thumbnail." width="1265" />
<p class="caption">Figure 6: My Blog listing: https://silvia.rbind.io/blog</p>
</div>

Update `[menu]` options in **config.toml** to activate Blog by changing `url = "/blog/"` and renaming `content/post/` to `content/blog/` to activate the new Apéro layout with the sidebar on the blog post listing and to enable thumbnails

```toml
[[menu.header]]
  name = "Blog"
  title = "Blog"
  url = "/blog/"
  weight = 2            # <-- item 2 in the navigation bar
```

Edit **content/blog/_index.md** with heading for the Blog listing page

- Make sure `text_link_url: /blog/`

- The `author:` field will populate the by-line in each blog post unless another author is indicated in the YAML of the blog post.

### Publications

My publication listing: [content/publication/_index.md](https://github.com/spcanelon/silvia/blob/bef8a7c9fd7b529e7cb58c3c92dafe59aa8d2259/content/publication/_index.md)

<div class="figure" style="text-align: center">
<img src="img/silvia-publication-list.png" alt="The Publication listing page for my site with a single layout which doesn't have a sidebar. The top of the page says 'Publications' and below is a short description of what can be found on the page. It also includes a by-line that reads 'Written by Silvia Canelón.' There is primarily one publication featured with a title, a summary, the authors, and the date. This listing visually separates publications in the list with a horizontal bar" width="1265" />
<p class="caption">Figure 7: My Publication listing: https://silvia.rbind.io/publication</p>
</div>

Update `[menu]` options in **config.toml** to activate Publications

```toml
[[menu.header]]
  name = "Publications"
  title = "Publications"
  url = "/publication/"
  weight = 4            # <-- item 4 in the navigation bar
```

Rename **content/publication/_index.md** to **_index-old.md** and copy over **_index.md** from `themes/hugo-apero/exampleSite/content/blog/`

Edit **content/publication/_index.md** to suit your preferences

Modify individual publications:

- The Apéro theme doesn't have a built-in "abstract" field so I copied and pasted the content in this field from the YAML of each publication page into the area below the YAML.
- If your publications have multiple authors, they can be included as a string list in the `author:` field of the YAML

### Talks

My talk listing: [content/talk/_index.md](https://github.com/spcanelon/silvia/blob/bef8a7c9fd7b529e7cb58c3c92dafe59aa8d2259/content/talk/_index.md)

<div class="figure" style="text-align: center">
<img src="img/silvia-talk-list.png" alt="The Talk listing page for my site with a single layout which doesn't have a sidebar and features decorative thumbnail images on the left. The top of the page says 'Talks' and below is a short description of what can be found on the page. This listing visually separates talks in the list by year with a horizontal bar." width="1265" />
<p class="caption">Figure 8: My Talk listing: https://silvia.rbind.io/talk</p>
</div>

Rename **content/talk/_index.md** to **_index-old.md** and copy over **_index.md** from `themes/hugo-apero/exampleSite/content/talk/`

Edit **content/talk/_index.md** to suit your preferences

### .Rmd → .Rmarkdown

You can create content for your blogdown site from **.md**, **.Rmd**, and **.Rmarkdown** files, anytime and anywhere. However, there are some limitations:
- **.md** is great if your file doesn't contain any R code
- **.Rmd** files generate **.html** files while **.Rmarkdown** files generate **.markdown** files. Both can run R code, but only **.markdown** files generated from **.Rmarkdown** benefit from some of the features available from Hugo, like the syntax highlighting built into Apéro.

If you were writing R tutorials/posts/etc. in **.Rmd** (like me), you will notice any code chunks you were displaying will not be formatted with proper syntax highlighting :cry: To remedy this, you will have to:

1. Change these **index.Rmd** files to **index.Rmarkdown** (I recommend using your computer's file explorer for this)

1. Rebuild your **index.Rmarkdown** files to **index.markdown** (using `blogdown::build_site(build_rmd = TRUE)`, see the [helper functions](https://pkgs.rstudio.com/blogdown/reference/build_site.html) for more granular control)

1. Delete the **index.html** output files that had previously been generated

<i class="fas fa-exclamation-triangle pr2"></i> Rebuilding your R Markdown pages may not be a good idea if they contain code that might break, so please proceed with caution!

If you made it this far, **congratulations**! You have a brand new site! :partying_face:

## Final touches

### Contact form

Resource: [Built-in Contact Form | Hugo Apéro](https://hugo-apero-docs.netlify.app/learn/built-in-contact-form/)

If you'd like to use Apéro's built-in contact form powered by Formspree, copy the `themes/hugo-apero/exampleSite/content/form/` folder into `content/` and edit **contact.md**.

### Tidying up your directory

Now you can delete all of the files and folders you don't need anymore! 

I'm including the files and folders I deleted as a list and as a directory tree. These are organized in the panelset below.

{{< panelset class="files and folders to delete" >}}
{{< panel name="List of items" >}}

- The content folders carried over from Hugo Academic: authors, home, post, courses, and slides
- The config folder
- The resources folder
- The data folder containing fonts and themes folders
- The assets/images folder
- The static/img/headers, static/publications, and static/rmarkdown-libs folders
- All of the **index.html** files in the blog, publication, and talks folders
- The old config file, that I had renamed **config_old.toml**
- The old index files that I had renamed **_index-old.md**
- The partials in layouts/shortcodes
- And finally the themes/hugo-academic folder! :fire:  

{{< /panel >}}

{{< panel name="Directory tree" >}}

I deleted the following files:
- All of the **index.html** files in the blog, publication, and talks folders
- The old config file, that I had renamed **config_old.toml**
- The old index files that I had renamed **_index-old.md**

And I deleted the folders indicated in this directory tree:

<i class="fas fa-route pr2"></i>Location: `silvia/`

```bash
.
├── config                # <-- this folder
├── resources             # <-- this folder
├── data                  # <-- this folder
├── assets
│   └── images            # <-- this folder
├── static
│   ├── img
│   │   └── headers       # <-- this folder
│   ├── publications      # <-- this folder
│   └── rmarkdown-libs    # <-- this folder
├── layouts
│   └── shortcodes        # <-- custom partials in this folder
└── themes
    └── hugo-academic     # <-- this folder
```

{{< /panel >}}
{{< /panelset >}}

## Customizing your site

Hopefully all of that wasn't terrible, and if it was, please know I'm rooting for you. You're doing great! :raised_hands: 

Now you get to enjoy the fun part which is customizing your site! The theme documentation goes through this in detail:

- [Set up your social | Hugo Apéro](https://hugo-apero-docs.netlify.app/learn/social/)
- [Style your site typography | Hugo Apéro](https://hugo-apero-docs.netlify.app/learn/fonts/)
- [Style your site colors | Hugo Apéro](https://hugo-apero-docs.netlify.app/learn/color-themes/)

## Deploying your new site

Once you're happy with your new Apéro site, the last step is to merge your `apero` branch with the primary branch of your website repository. But first, a few steps:

1. **Optional:** Create a branch of your primary branch and call it `hugo-academic` so that you have a snapshot of your Academic files right before the merge. Since we set up Netlify to deploy all of our branches, there will now be a live link for this new branch that you can visit whenever you feel like time traveling back to your old site. For me this link is https://hugo-academic--silvia.netlify.app/

2. Switch back to your `apero` branch and update the `baseURL` field in **config.toml** to your regular website path. In my case:

    ```toml
    baseURL = "https://silvia.rbind.io/"
    ```

    Then commit and push this change to your `apero` branch.
    
3. Merge your `apero` branch with your primary branch. I usually use git commands in a combination of the RStudio terminal and the Git pane, but for this big merge I felt more comfortable doing it on github.com! :sweat_smile: Do what feels most comfortable for you.

4. Resolve any merge conflicts (I had a few!) in the git tool of your choosing. These are the git commands GitHub recommended:

    ```bash
    git fetch origin       # makes sure local files were recent
    git checkout apero     # moves you to your `apero` branch
    git merge main         # attempts a merge with your `main` branch
    ```
    
    When you're finished, commit your changes and push. Then follow these next steps, also recommended by GitHub:
    
    ```bash
    git checkout main       # moves you to your `main` branch
    git merge --no-ff apero # creates a new commit for the merge
    ```
    
    This step will sort of replace all of the files that both themes had in common with the `apero` version (e.g. **config.toml**, **netlify.toml**, **content/publication**), and leave the old Academic files alone. So you will have to delete these extra Academic files ([again](#tidying-up-your-directory)!). I'm not sure how to avoid this -- maybe it's not an issue when you don't have merge conflicts? I don't know :thinking:
    
5. Tidy up your directory (again?)

    Go through [the steps above](#tidying-up-your-directory) to clean out any residual Academic files from your directory. Make sure to check your `content/` folders for any example files from Academic that might still be hanging around and delete them.
    
    Then run `blogdown::serve_site()` to build your new Apéro site locally. Go through the site and make sure everything looks the way it should and that links are generally pointing to the right places. 
    
    When you're satisfied, commit the changes to your primary branch!<br>There may be *a lot* of files that were deleted and added during the switch to Apéro and, while not generally recommended, I used the `git add .` command to stage all of the changes at once, commited the changes, and then pushed. I did this after thoroughly looking through the list of changed files so I knew what was happening.

6. Wait a couple of minutes for the changes to get pushed to your primary branch (e.g. `main`) and then wait patiently for Netlify to build your site after the merge.

7. <i class="fas fa-glass-cheers pr2"></i>Celebrate and share your brand new site! :tada: :partying_face: :champagne:<br>If you share on Twitter, use the #HugoApero hashtag so the [Hugo Apéro squad](https://twitter.com/apreshill/status/1397052533588185092) can clap for you!
