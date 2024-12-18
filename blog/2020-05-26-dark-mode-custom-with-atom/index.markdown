---
title: Customizing Hugo Academic's Dark Mode with Help from Atom
author: Silvia Canelón
date: '2020-06-16'
image: featured.png
slug: dark-theme-custom-with-atom
categories:
  - website
  - tutorial
  - atom
  - blogdown
  - hHugo
  - css
alias:
  - /blog/dark-theme-custom-with-atom/
subtitle: Tutorial on how to customize the dark mode in Hugo's Academic theme with help from the Atom text editor package Pigments.
summary: Tutorial on how to customize the dark mode in Hugo's Academic theme with help from the Atom text editor package Pigments.
lastmod: '2020-06-16T13:22:13-04:00'
links:
  - icon: filetype-css
    icon_pack: far
    name: CSS
    url: https://github.com/spcanelon/silvia/blob/hugo-academic/assets/scss/custom.scss
---

<style>.color-preview {
  display: inline-block;
  width: 1em;
  height: 1em;
  border-radius: 50%;
  margin: 0 0.33em;
  vertical-align: middle;
  transition: transform 100ms ease-in-out;
}
.color-preview:hover {
  cursor: pointer;
  transform: scale(2);
  transform-origin: 50% 50%;
}</style>
<!--`<span class="color-preview" style="background-color: 414073"></span><code>414073</code>`{=html}
<span class="color-preview" style="background-color: #414073"></span><code>#414073</code>-->

# Where I started

With Alison Hill’s [Up and Running with Blogdown](https://alison.rbind.io/post/2017-06-12-up-and-running-with-blogdown/) post! **Super helpful**, though because I came to it 2.5 years late, it was more like ‘up and running with lots of water breaks’ because I had to stop and account for changes made to the Hugo Academic theme in the meantime.

-   For example, prior to Academic version 4.6, custom CSS was added using the `plugins_css` option in `params.toml`, but [in current version 4.8](https://sourcethemes.com/academic/docs/customization/#customize-style-css), the theme supports SCSS (a superset of CSS) and a **custom.scss** file is added in the `assets/scss/` folder.

The [going futher](https://alison.rbind.io/post/2017-06-12-up-and-running-with-blogdown/#going-further) section in Alison’s post specifically talks about customizing the out-of-the-box theme and Alison directly links to her custom CSS file, which I closely referred to when changing colors in [my custom SCSS file](https://github.com/spcanelon/silvia/blob/master/assets/scss/custom.scss).

Alison’s CSS helped me customize everything from text colors and fonts to alert colors and borders for Academic’s light mode. At this point I had the light mode looking the way I wanted but the dark mode still used out-of-the-box colors for the most part and they ***just didn’t go***.

<img src="img/academic-minimal-dark-theme.png" title="Out-of-the-box colors included an eggplant page background with a light purple foreground. The issue I perceived was that these colors clashed with the navy blue and gold color changes I had made and was happy with in the light mode. I particularly was bothered by a cyan color highlight for code text" alt="Out-of-the-box colors included an eggplant page background with a light purple foreground. The issue I perceived was that these colors clashed with the navy blue and gold color changes I had made and was happy with in the light mode. I particularly was bothered by a cyan color highlight for code text" width="50%" style="display: block; margin: auto;" />

So I decided not to enable the dark-mode option in **params.toml** until I could figure out how to customize my stylesheet accordingly. That time has come because it turns out [it’s pretty straightforward](https://github.com/gcushen/hugo-academic/issues/988#issuecomment-475896178)!

The [Blogdown book](https://bookdown.org/yihui/blogdown/css.html) does an excellent job summarizing what you need to know about CSS. This post builds on that a little by incorporating [features made possible by SCSS](https://sass-lang.com/guide) including **variables**.

# Choose your own adventure

1.  **Check out the SCSS file** linked above <i class="fas fa-hand-point-up"></i> to see how I customized my theme.
2.  **Keep reading** to follow along and learn with me <i class="fas fa-user-friends"></i>.

# Why Atom?

[Atom](https://atom.io/) is a text editor that I like to use to *modify* any files in my website directory. I say modify because I much prefer to *create* content for posts like this one using the [Blogdown addins in RStudio](https://bookdown.org/yihui/blogdown/rstudio-ide.html). It’s such a breeze! But here’s why I think Atom is a fantastic companion to the RStudio IDE:

1.  **Seeing your directory files is made friendly in Tree View** when you open your website folder as a ‘project folder.’ You can just click on the file once to preview it and double-click if you want to actually open it. I find this to be really helpful when I can’t remember which file contains what I’m looking for because I don’t have to actually open each file to see what’s in it.
2.  **Searching for something specific is easy with the built-in search tool**. I’ve used this many times when I can’t remember where that specific parameter (e.g. fonts) or file type (e.g. `.scss`) is located within my directory. I also find it super handy to find specific HTML color codes or color variables. This brings me to my most favorite feature in Atom…
3.  **The [pigments](https://atom.io/packages/pigments) package!** Like R, Atom has a universe of handy packages and `pigments` will **display colors** behind the code text that represents it. It’s kind of magical and has been a real game changer for me. Having this package will make customizing your scss file much easier on the eyes and brain.

-   You may also choose to install the [highlight-selected](https://atom.io/packages/highlight-selected) package to make highlighted text easier to spot throughout your file and the [file-icons](https://atom.io/packages/file-icons) package to make it easier to discern between different file types in your tree view. You can install packages in *Atom &gt; Preferences &gt; Install*.

# Adding dark mode definitions to stylesheet

Looking through GitHub issues I found that including two sub-themes, one for light mode and one for dark mode, [may be considered for Academic in the future but is not a priority](https://github.com/gcushen/hugo-academic/issues/995). A related issue shared that if you use a custom CSS, you can [define `.dark .<SELECTOR-NAME> {...}` for dark mode](https://github.com/gcushen/hugo-academic/issues/988).

Not knowing what all of the options were for dark mode, I took a look at the **dark.scss** dark mode stylesheet built in to Academic in `themes/hugo-academic/assets/scss/academic/` folder. You can see the `pigments` package in action here! It makes it easier to identify elements with colors that you want to change. I’m looking at you inline code text color <code>rgb(139, 233, 253)</code><span class="color-preview" style="background-color: rgb(139, 233, 253)"></span>

<details>
<summary>
CSS code
</summary>

Note that in SCSS syntax `//` indicates comments and `#` indicates hex codes

``` css
.dark pre,
.dark code {
  color: rgb(139, 233, 253); // cyan code text color
  background-color: rgb(68, 71, 90); // light purple code background
}
```

</details>

<img src="img/atom-inline-text-color.png" title="CSS code chunk styling inline code. The Atom editor enables viewers to see the color that hex and rgb color codes correspond to, as the background of the color code text. This screenshot demonstrates that the inline code text color was cyan and the inline code background was light purple." alt="CSS code chunk styling inline code. The Atom editor enables viewers to see the color that hex and rgb color codes correspond to, as the background of the color code text. This screenshot demonstrates that the inline code text color was cyan and the inline code background was light purple." width="726" style="display: block; margin: auto;" />

Another way to find the css for the element you want to change is to use your browser’s web inspector tool. In the screenshot below from Hugo Academic’s [customization documentation (available in the Internet Archive)](https://web.archive.org/web/20200512194921/https://sourcethemes.com/academic/docs/customization/) I right-clicked on **themes/academic/data/themes/minimal.toml** and then clicked on “inspect element.” The element code was `.dark pre, .dark code` which you might recognize from the code in **dark.scss**.

<img src="img/web-element-inspector.png" title="A view of the Firefox web inspector inspecting some inline code available on the Hugo Academic documentation site which used the out-of-the-box dark mode colors. The inspector reveals that the selected text was styled by the CSS code chunk included earlier and includes color previews so you can visually identify elements by color." alt="A view of the Firefox web inspector inspecting some inline code available on the Hugo Academic documentation site which used the out-of-the-box dark mode colors. The inspector reveals that the selected text was styled by the CSS code chunk included earlier and includes color previews so you can visually identify elements by color." width="700px" style="display: block; margin: auto;" />

You can copy and paste this new `.dark` theme code into a new (or existing) **custom.scss** file saved in the `assets/scss/` folder of your directory to start seeing how changes you make affect the look of your site.

# Choosing dark theme colors

Alright. Now that we have some new dark theme code in our custom file, we can move on to the exciting task of **choosing colors**! If you’re looking for some inspiration, [Coolors has some dark color palettes](https://coolors.co/palettes/trending/dark):

<img src="img/coolors-dark-palettes.png" title="Six different palettes available under the &quot;Dark&quot; category in the Coolors galleries, which feature deeper colors" alt="Six different palettes available under the &quot;Dark&quot; category in the Coolors galleries, which feature deeper colors" width="732" style="display: block; margin: auto;" />

Coolors is also a great place to save colors into custom palettes. Here’s a basic example of mine:

<img src="img/coolors-my-basic-palette.png" title="My palette saved in Coolors, featuring a navy blue primary color with a darker and lighter variant, a gold secondary color also with variants, and a neutral off-white color between them" alt="My palette saved in Coolors, featuring a navy blue primary color with a darker and lighter variant, a gold secondary color also with variants, and a neutral off-white color between them" width="700px" style="display: block; margin: auto;" />

If you’re like me and want to design a dark theme that uses the primary and secondary colors you picked for your light theme, keep reading! I’m gonna share highlights from what I learned about dark theme design and how to ensure your color combinations meet [Web Content Accessibility Guidelines (WCAG)](https://www.w3.org/WAI/standards-guidelines/wcag/).

The bulk of what I learned came from the extensive Material Design resources, including (of course) the [dark theme foundational material](https://www.material.io/design/color/dark-theme.html), which will look familiar if you’ve ever used an Android device.

## Basics of dark theme design

-   The primary **surface color** for dark themes should be dark gray, rather than black. The recommended color is <code>\#121212</code><span class="color-preview" style="background-color: #121212"></span>

-   As you layer components, surfaces with a higher elevation (closer to the hypothetical ‘light source’) should be lighter than those below it to create a visual hierarchy. This can be achieved by applying a semi-transparent white overlay to the primary dark gray surface.

<img src="img/material-surface-overlays.png" title="Ten different dark mode overlay examples from Material Design. The darkest/base layer contains 0% white overlay, elevation level 01 has 5% of a white overlay, level 02 has 7%, level 04 has 8%, level 05 has 9%, level 06 has 11%, level 08 has 12%, level 12 has 14%, level 16 has 15%, and level 24 has 16%" alt="Ten different dark mode overlay examples from Material Design. The darkest/base layer contains 0% white overlay, elevation level 01 has 5% of a white overlay, level 02 has 7%, level 04 has 8%, level 05 has 9%, level 06 has 11%, level 08 has 12%, level 12 has 14%, level 16 has 15%, and level 24 has 16%" width="524" style="display: block; margin: auto;" />

-   The primary **text color** for dark themes should not be 100% opaque white (i.e. <code>\#FFFFFF</code><span class="color-preview" style="background-color: #FFFFFF; border: 2px solid gray;"></span>) because it can appear to bleed or blur against dark backgrounds and be difficult to read.
-   Text hierarchy is established by controlling the opacity, for example:
    -   High emphasis text is white with 87% opacity:<br><code>rgba(255, 255, 255, 0.87)</code><span class="color-preview" style="background-color: rgba(255, 255, 255, 0.87); border: 2px solid gray;"></span>
    -   Medium emphasis is white with 60% opacity:<br><code>rgba(255, 255, 255, 0.60)</code><span class="color-preview" style="background-color: rgba(255, 255, 255, 0.60); border: 2px solid gray;"></span>
    -   Disabled text is white with 38% opacity:<br><code>rgba(255, 255, 255, 0.38)</code><span class="color-preview" style="background-color: rgba(255, 255, 255, 0.38); border: 2px solid gray;"></span>
-   To meet WCAG AA standard, there must be a 4.5:1 contrast level between the body text and the dark theme surface at the highest/lightest elevation. The contrast level is 7:1 for the WCAG AAA standard.

## Tools to explore palettes

Material Design has a [color palette generator](https://material.io/design/color/the-color-system.html#tools-for-picking-colors) and a [color tool](https://material.io/resources/color/) that can be used to dark and light variants of a color. I used the color tool to find a dark and light variant of my primary and secondary colors. The accessibility feature of the color tool is helpful to determine the minimum opacity for white text to ensure enough contrast. The [Coolors color contrast checker](https://coolors.co/contrast-checker) is another great tool.

# Color variables

One of the cool features of SCSS is the ability to use variables defined by prefix `$` (i.e. `$spc-primary: #122140;`. You can set your variables at the top of your SCSS file and use the variable name throughout the file. This makes it super easy to try out different dark mode colors without having to use find-and-replace. If you’re using the `pigments` package in Atom, it’ll even show you the variable colors in a dropdown!

> **Tip:** I like using a bright color like
> <html>
> <span style="background-color:#FDF4F4; color:#A90533">red </span>
> </html>
>
> to test color changes for different CSS elements because stands out and makes it easier to see what was modified.

I defined my primary colors and variants, text colors, and various background colors as variables. And although dark gray (\#121212) is recommended as a standard dark theme background, you can also create a custom background color by mixing it with your primary color. In my case I used `mix(#122140, #121212, 40)` to create a color that was 40% my primary color and 60% dark gray.

> I controlled white text opacity by using `rgba()` in CSS which accepts an alpha value between 0 and 1.

Now, ideally I’d be able to define the result of this `mix()` as a color variable, but some CSS properties like `background-color` don’t recognize it. So I had to convert the result to a color code and define that as a variable instead. `pigments` made this conversion easy when I toggled the menu (Shift+Command+P on a Mac) and searched for the `pigments: convert` options.

<img src="img/atom-pigments-menu.png" title="The command palette in the Atom editor lets you search for packages and functions. When you type &quot;pigments: convert&quot; you can see the options like &quot;Pigments: Convert To Hex&quot;, &quot;Pigments: Convert to Rgba&quot;, etc." alt="The command palette in the Atom editor lets you search for packages and functions. When you type &quot;pigments: convert&quot; you can see the options like &quot;Pigments: Convert To Hex&quot;, &quot;Pigments: Convert to Rgba&quot;, etc." width="700px" style="display: block; margin: auto;" />

This `mix()` function also came in handy when defining background surfaces with semi-transparent white overlays.

<details>
<summary>
CSS code
</summary>

Note that in SCSS syntax `//` indicates comments and `#` indicates hex codes

``` scss
// COLOR CALCULATIONS
// below from mix($spc-primary, $spc-bkg-dark-std, 25)
// custom bkg
$spc-bkg-dark: #12151d;
// below from mix($spc-primary, $spc-bkg-dark-std, 40)
// 00dp surface
$spc-00dp: #121824;     
// below from mix($spc-00dp, white, 95)
// 00dp with 5% white overlay
$spc-01dp: #1d232e;
// below from mix($spc-00dp, white, 93)
// 00dp with 7% white overlay
$spc-02dp: #222833;
// below from mix($spc-00dp, white, 92)
// 00dp with 8% white overlay
$spc-03dp: #242a35;
// below from mix($spc-00dp, white, 91)
// 00dp with 9% white overlay
$spc-04dp: #272c37;
```

</details>

<img src="img/atom-background-color-definitions.png" title="Atom editor showing the color variables I assigned to different elevation levels of my base background color. The mix() SCSS function let me mix by base dark color with white to create the effect of a white overlay as recommended by Material Design." alt="Atom editor showing the color variables I assigned to different elevation levels of my base background color. The mix() SCSS function let me mix by base dark color with white to create the effect of a white overlay as recommended by Material Design." width="700px" style="display: block; margin: auto;" />

**And that’s a wrap**. Have fun building your new custom dark theme!
