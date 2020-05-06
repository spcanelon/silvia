# Steps to take

- to view live version use the **serve site** add-in `blogdown::serve_site()`. But only use it once and it automatically reloads when you save changes to your files via _LiveReload_
- to stop the session, run `servr::daemon_stop(1)`or end it manually

## Color palette
Penn/DBEI primary colors
- PennBlue = "#1e376c" #DBEI/CCEB
- PennRed = "#a90533" #DBEI/CCEB

DBEI secondary colors
- DarkBlue = "#2e5d97" #DBEI
- LightBlue = "#2e9ad5" #DBEI
- Purple = "#7e6b94" #DBEI
- Orange = "be6c43" #DBEI
- Yellow = "#ffd400" #DBEI
- Beige = "#e8eade" #DBEI

CCEB primary colors
- OrangeRed = "#ef3742" #DBEI
- LightRed = "#d99792" #DBEI

CCEB secondary colors
- Green = "#83944e" #CCEB

CCEB center of excellence colors
- PastelYellow = "#f5eca5"
- PastelGreen = "#cee6c1"
- PastelBlue = "c9e3ef"
- PastelBeige = "d8d8c9"

Other
- ExcelOrange = "#d47d3a" #Excel orange
- ExcelYellow = "#efbf2c" #Excel yellow
- Grey = "#999999"

## Resources
- Great resource for looking at colors in similar families: https://www.color-hex.com/
- Quick look at the different pre-set Hugo Academic theme colors: https://sourcethemes.com/academic/themes/
- Embedding HTML pages
```
<iframe
    src="./2019_AMIA_annual_symposium.pdf"
    width="100%"
    height="950px"
    style="border:none;">
</iframe>
```
- Embedding PDF: https://www.w3docs.com/snippets/html/how-to-embed-pdf-in-html.html
- Adding website to search engines: https://ahrefs.com/blog/submit-website-to-search-engines/

# Structure

## .git
## .Rproj.user
## config
### default
- languages.toml
- menus.toml
- params.toml
  - this is where I changed the `font` from the default (i.e. "") to "Rose" and font size to Medium.
  - browse built-in font sets in `themes/hugo-academic/data/fonts/`
  - browse user installed font sets in `data/fonts/`
  - this is where I set `day_night = false` so that I could just focus on the color scheme I want for a light mode page. Not sure how to select a set of colors for dark mode to start playing around with it.
  - this is where all contact information lives

## content
### authors
#### admin
This is the author content on my homepage.
- index.md: includes my intro paragraph as well as connection information for social media etc.
- avatar.jpg: this is my home page photo

## data
### theme
This is where I copied the `minimal.toml` theme to so that I could customize the colors and save as `my_theme`.
- https://sourcethemes.com/academic/docs/customization/

## public
## resources
## static
## themes

### hugo-academia

### hugo-academic (primary)

Loose files:
- .gitignore
- config.toml
- index.html
- index.Rmd
- netlify.toml
- README.md
- silvia.Rproj
