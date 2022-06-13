---
title: 'Philly Center City District Sips 2022: An Interactive Map'
layout: single-sidebar
date: '2022-05-31'
publishDate: '2022-05-31'
lastUpdated: '2022-06-01'
slug: ccd-sips
categories:
  - R
  - Tutorial
tags:
  - R
  - maps
  - webscraping
  - robotstxt
  - rvest
  - leaflet
  - ggmap
subtitle: 'An interactive map showing restaurants participating in CCD Sips 2022 & a companion R tutorial on webscraping, geocoding, and map-making'
summary: 'An interactive map showing restaurants participating in CCD Sips 2022 & a companion R tutorial on webscraping, geocoding, and map-making'
featured: yes
links:
- icon: map-marked-alt
  icon_pack: fas
  name: Interactive Map
  url: http://tiny.cc/ccdsips2022
format: hugo
---



<script src="index_files/libs/htmlwidgets-1.5.4/htmlwidgets.js"></script>
<script src="index_files/libs/jquery-1.12.4/jquery.min.js"></script>
<link href="index_files/libs/leaflet-1.3.1/leaflet.css" rel="stylesheet" />
<script src="index_files/libs/leaflet-1.3.1/leaflet.js"></script>
<link href="index_files/libs/leafletfix-1.0.0/leafletfix.css" rel="stylesheet" />
<script src="index_files/libs/proj4-2.6.2/proj4.min.js"></script>
<script src="index_files/libs/Proj4Leaflet-1.0.1/proj4leaflet.js"></script>
<link href="index_files/libs/rstudio_leaflet-1.3.1/rstudio_leaflet.css" rel="stylesheet" />
<script src="index_files/libs/leaflet-binding-2.0.4.1/leaflet.js"></script>
<script src="index_files/libs/leaflet-providers-1.9.0/leaflet-providers_1.9.0.js"></script>
<script src="index_files/libs/leaflet-providers-plugin-2.0.4.1/leaflet-providers-plugin.js"></script>
<link href="index_files/libs/leaflet-awesomemarkers-2.0.3/leaflet.awesome-markers.css" rel="stylesheet" />
<script src="index_files/libs/leaflet-awesomemarkers-2.0.3/leaflet.awesome-markers.min.js"></script>
<link href="index_files/libs/fontawesome-4.7.0/font-awesome.min.css" rel="stylesheet" />
<link href="index_files/libs/lfx-fullscreen-1.0.2/lfx-fullscreen-prod.css" rel="stylesheet" />
<script src="index_files/libs/lfx-fullscreen-1.0.2/lfx-fullscreen-prod.js"></script>


Philly's Center City District posted a list of restaurants and bars
participating in Philly's 2022 [CCD
Sips](https://centercityphila.org/explore-center-city/ccdsips). CCD Sips
is a series of summer Wednesday evenings (4:30-7pm) filled with **happy
hour specials**, between June 1st and August 31st.

I prefer to take in this information as a **map** instead of a list, so
I scraped some information from the website and made one! You can click
or tap on the circle map markers to see information about each
restaurant/bar along with a direct link to their posted happy hour
specials.

Check out the link at the top of this post for a larger version of the
interactive map below. And jump down to the [tutorial](#tutorial-start)
if you'd like to learn how I used R to build the interactive map!

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

## Tutorial start

Aside from the `tidyverse` and `here` packages, I used a handful of R
packages to bring this map project together.

| Package          | Purpose                                   | Version |
|------------------|-------------------------------------------|---------|
| `robotstxt`      | Check website for scraping permissions    | 0.7.13  |
| `rvest`          | Scrape the information off of the website | 1.0.1   |
| `ggmap`          | Geocode the restaurant addresses          | 3.0.0   |
| `leaflet`        | Build the interactive map                 | 2.0.4.1 |
| `leaflet.extras` | Add extra functionality to map            | 1.0.0   |

## Scraping the data

### Checking site permissions

Check the site's terms of service using the
[robotstxt](https://docs.ropensci.org/robotstxt/) package, which
downloads and parses the site's robots.txt file.

What I wanted to look for was whether any pages are not allowed to be
crawled by bots/scrapers. In my case there weren't any, indicated by
`Allow: /`.

``` r
get_robotstxt("https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view")
```

<details>
<summary>
Output
</summary>

``` md
[robots.txt]
--------------------------------------

# robots.txt overwrite by: on_suspect_content

User-agent: *
Allow: /



[events]
--------------------------------------

requested:   https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view/robots.txt 
downloaded:  https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view/robots.txt 

$on_not_found
$on_not_found$status_code
[1] 404


$on_file_type_mismatch
$on_file_type_mismatch$content_type
[1] "text/html; charset=utf-8"


$on_suspect_content
$on_suspect_content$parsable
[1] FALSE

$on_suspect_content$content_suspect
[1] TRUE


[attributes]
--------------------------------------

problems, cached, request, class
```

</details>

### Harvesting data from the first page

Then I used the [rvest](https://rvest.tidyverse.org/index.html) package
to scrape the information from the tables of restaurants/bars
participating in CCD Sips.

I've learned that ideally you would only scrape each page once, so I
checked my approach with the first page before I wrote a function to
scrape the remaining pages.

``` r
# define the page
url <- "https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1"

# read the page html
html1 <- read_html(url)

# extract table info
table1 <- 
  html1 %>% 
  html_node("table") %>% 
  html_table()
table1 %>% head(3) %>% kableExtra::kable()
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> Name </th>
   <th style="text-align:left;"> Address </th>
   <th style="text-align:left;"> Phone </th>
   <th style="text-align:left;"> CCD SIPS Specials </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1028 Yamitsuki Sushi &amp; Ramen </td>
   <td style="text-align:left;"> 1028 Arch Street, Philadelphia, PA 19107 </td>
   <td style="text-align:left;"> 215.629.3888 </td>
   <td style="text-align:left;"> CCD SIPS Specials </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1225 Raw Sushi and Sake Lounge </td>
   <td style="text-align:left;"> 1225 Sansom St, Philadelphia, PA 19102 </td>
   <td style="text-align:left;"> 215.238.1903 </td>
   <td style="text-align:left;"> CCD SIPS Specials </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1518 Bar and Grill </td>
   <td style="text-align:left;"> 1518 Sansom St, Philadelphia, PA 19102 </td>
   <td style="text-align:left;"> 267.639.6851 </td>
   <td style="text-align:left;"> CCD SIPS Specials </td>
  </tr>
</tbody>
</table>

``` r
# extract hyperlinks to specific restaurant/bar specials
links <- 
  html1 %>% 
  html_elements(".o-table__tag.ccd-text-link") %>% 
  html_attr("href") %>% 
  as_tibble()
links %>% head(3) %>% kableExtra::kable()
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> #1028-yamitsuki-sushi-ramen </td>
  </tr>
  <tr>
   <td style="text-align:left;"> #1225-raw-sushi-and-sake-lounge </td>
  </tr>
  <tr>
   <td style="text-align:left;"> #1518-bar-and-grill </td>
  </tr>
</tbody>
</table>

``` r
# add full hyperlinks to the table info
table1Mod <-
  bind_cols(table1, links) %>% 
  mutate(Specials = paste0(url, value)) %>% 
  select(-c(`CCD SIPS Specials`, value))
table1Mod %>% head(3) %>% kableExtra::kable()
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> Name </th>
   <th style="text-align:left;"> Address </th>
   <th style="text-align:left;"> Phone </th>
   <th style="text-align:left;"> Specials </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1028 Yamitsuki Sushi &amp; Ramen </td>
   <td style="text-align:left;"> 1028 Arch Street, Philadelphia, PA 19107 </td>
   <td style="text-align:left;"> 215.629.3888 </td>
   <td style="text-align:left;"> https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#1028-yamitsuki-sushi-ramen </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1225 Raw Sushi and Sake Lounge </td>
   <td style="text-align:left;"> 1225 Sansom St, Philadelphia, PA 19102 </td>
   <td style="text-align:left;"> 215.238.1903 </td>
   <td style="text-align:left;"> https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#1225-raw-sushi-and-sake-lounge </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1518 Bar and Grill </td>
   <td style="text-align:left;"> 1518 Sansom St, Philadelphia, PA 19102 </td>
   <td style="text-align:left;"> 267.639.6851 </td>
   <td style="text-align:left;"> https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#1518-bar-and-grill </td>
  </tr>
</tbody>
</table>

### Harvesting data from the remaining pages

Once I could confirm that the above approach harvested the information I
needed, I adapted the code into a function that I could apply to pages
2-3 of the site.

``` r
getTables <- function(pageNumber) {
  Sys.sleep(2)
  
  url <- paste0("https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=", pageNumber)
  
  html <- read_html(url)
  
  table <- 
    html %>% 
    html_node("table") %>%
    html_table()
  
  links <- 
    html %>% 
    html_elements(".o-table__tag.ccd-text-link") %>% 
    html_attr("href") %>% 
    as_tibble()
  
  tableSpecials <<-
    bind_cols(table, links) %>% 
    mutate(Specials = paste0(url, value)) %>% 
    select(-c(`CCD SIPS Specials`, value))
}
```

I used my `getTable()` function and the `purrr::map_df()` function to
harvest the table of restaurants/bars from pages 2 and 3. Then I
combined all the data frames together and saved the complete data frame
as an `.Rds` object so that I wouldn't have to scrape the data again.

``` r
# get remaining tables
table2 <- map_df(2:3, getTables) 

# combine all tables
table <- bind_rows(table1Mod, table2)
table %>% head(3) %>% kableExtra::kable()
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> Name </th>
   <th style="text-align:left;"> Address </th>
   <th style="text-align:left;"> Phone </th>
   <th style="text-align:left;"> Specials </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1028 Yamitsuki Sushi &amp; Ramen </td>
   <td style="text-align:left;"> 1028 Arch Street, Philadelphia, PA 19107 </td>
   <td style="text-align:left;"> 215.629.3888 </td>
   <td style="text-align:left;"> https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#1028-yamitsuki-sushi-ramen </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1225 Raw Sushi and Sake Lounge </td>
   <td style="text-align:left;"> 1225 Sansom St, Philadelphia, PA 19102 </td>
   <td style="text-align:left;"> 215.238.1903 </td>
   <td style="text-align:left;"> https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#1225-raw-sushi-and-sake-lounge </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1518 Bar and Grill </td>
   <td style="text-align:left;"> 1518 Sansom St, Philadelphia, PA 19102 </td>
   <td style="text-align:left;"> 267.639.6851 </td>
   <td style="text-align:left;"> https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#1518-bar-and-grill </td>
  </tr>
</tbody>
</table>

``` r
# save full table to file
write_rds(
  table,
  file = here("content/blog/2022-05-31-ccd-sips/specialsScraped.Rds")
  )
```

## Geocoding addresses

The next step was to use geocoding to convert the restaurant/bar
addresses to geographical coordinates (longitude and latitude) that I
could map. I used the [ggmap](https://github.com/dkahle/ggmap) package
and the Google Geocoding API service because this was a small project
(59 addresses/requests) which wouldn't make a dent in the [free credit
available on the platform](https://mapsplatform.google.com/pricing/).

The last time I geocoded addresses was for an [almost identical project
in 2019](../2019-ccd-sips) and I had issues using the same API key from
back then, so I made a new one. I restricted my new key to the Geocoding
and Geolocation APIs.

``` r
# register my API key
# ggmap::register_google(key = "[your key]")

# geocode addresses
specials_ggmap <- 
  table %>% 
  mutate_geocode(Address)

# rename new variables
specials <- 
  specials_ggmap %>% 
  rename(Longitude = lon,
         Latitude = lat) 
specials %>% head(3) %>% kableExtra::kable()
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> Name </th>
   <th style="text-align:left;"> Address </th>
   <th style="text-align:left;"> Phone </th>
   <th style="text-align:left;"> Specials </th>
   <th style="text-align:right;"> Longitude </th>
   <th style="text-align:right;"> Latitude </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1028 Yamitsuki Sushi &amp; Ramen </td>
   <td style="text-align:left;"> 1028 Arch Street, Philadelphia, PA 19107 </td>
   <td style="text-align:left;"> 215.629.3888 </td>
   <td style="text-align:left;"> https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#1028-yamitsuki-sushi-ramen </td>
   <td style="text-align:right;"> -75.15746 </td>
   <td style="text-align:right;"> 39.95354 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1225 Raw Sushi and Sake Lounge </td>
   <td style="text-align:left;"> 1225 Sansom St, Philadelphia, PA 19102 </td>
   <td style="text-align:left;"> 215.238.1903 </td>
   <td style="text-align:left;"> https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#1225-raw-sushi-and-sake-lounge </td>
   <td style="text-align:right;"> -75.16149 </td>
   <td style="text-align:right;"> 39.95004 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1518 Bar and Grill </td>
   <td style="text-align:left;"> 1518 Sansom St, Philadelphia, PA 19102 </td>
   <td style="text-align:left;"> 267.639.6851 </td>
   <td style="text-align:left;"> https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#1518-bar-and-grill </td>
   <td style="text-align:right;"> -75.16665 </td>
   <td style="text-align:right;"> 39.95020 </td>
  </tr>
</tbody>
</table>

I made sure to save the new data frame with geographical coordinates as
an `.Rds` object so I wouldn't have to geocode the data again! This
would be particularly important if I was working on a large project.

``` r
# save table with geocoded addresses to file
write_rds(
  specials,
  file = here("content/blog/2022-05-31-ccd-sips/specialsGeocoded.Rds"))
```

## Building the map

To build the map, I used the
[leaflet](https://rstudio.github.io/leaflet/) package. Some of the
resources I found helpful, in addition to the package documentation:

-   [Scrape website data with the new R package rvest (+ a postscript on
    interacting with web pages with RSelenium) · Hollie at
    ZevRoss](https://www.zevross.com/blog/2015/05/19/scrape-website-data-with-the-new-r-package-rvest/)
    -- how to style pop-ups
-   [Leaflet Map Markers in R · Jindra
    Lacko](https://www.jla-data.net/eng/leaflet-markers-in-r/) -- how to
    customize marker icons
-   [A guide to basic Leaflet accessibility ·
    Leaflet](https://leafletjs.com/examples/accessibility/) --
    accessibility considerations. Though it's unclear to me how these
    features built into the Leaflet library translate over to the
    leaflet R package. For example, I couldn't find an option for adding
    alt-text or a title to each marker, but maybe I wasn't looking in
    the right place within the documentation.

### Customizing map markers

``` r
# style pop-ups for the map with inline css styling

# marker for the restaurants/bars
popInfoCircles <- paste("<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'>", "<a style='color: #00857A;' href=", specials$Specials, ">", specials$Name, "</a></h2>","<p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'>", specials$Address, "</p>")

# marker for the center of the map
popInfoMarker<-paste("<h1 style='padding-top: 0.5em; margin-top: 1em; margin-bottom: 0.5em; font-family: Red Hat Text, sans-serif; font-size: 1.8em; color:#43464C;'>", "<a style='color: #00857A;' href='https://centercityphila.org/explore-center-city/ccdsips'>", "Center City District Sips 2022", "</a></h1><p style='color:#9197A6; font-family: Red Hat Text, sans-serif; font-size: 1.5em; padding-bottom: 1em;'>", "Philadelphia, PA", "</p>")

# custom icon for the center of the map
awesome <-
  makeAwesomeIcon(
    icon = "map-pin",
    iconColor = "#FFFFFF",
    markerColor = "darkblue",
    library = "fa"
  )
```

### Plotting the restaurants/bars

``` r
leaflet(data = specials, 
        width = "100%", 
        height = "850px",
        # https://stackoverflow.com/a/42170340
        options = tileOptions(minZoom = 15,
                              maxZoom = 19)) %>%
  # add map markers ----
  addCircles(
    lat = ~ specials$Latitude, 
    lng = ~ specials$Longitude, 
    fillColor = "#009E91", #olivedrab goldenrod
    fillOpacity = 0.6, 
    stroke = F,
    radius = 12, 
    popup = popInfoCircles,
    label = ~ Name,
    labelOptions = labelOptions(
      style = list(
        "font-family" = "Red Hat Text, sans-serif",
        "font-size" = "1.2em")
      ))
```

<div id="htmlwidget-545ca529d46ff5ab83bf" style="width:100%;height:850px;" class="leaflet html-widget"></div>
<script type="application/json" data-for="htmlwidget-545ca529d46ff5ab83bf">{"x":{"options":{"minZoom":15,"maxZoom":19,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false},"calls":[{"method":"addCircles","args":[[39.9535423,39.9500363,39.9501977,39.9526642,39.9488888,39.9527827,39.9467935,39.9517476,39.9506007,39.9543618,39.9500062,39.9490852,39.9482475,39.950472,39.9477828,39.9520312,39.9554292,39.9511145,39.9557898,39.9524665,39.9645357,39.9557404,39.9519308,39.9491023,39.9518233,39.9497054,39.9521221,39.95006,39.949742,39.9592359,39.9504997,39.9510645,39.9504002,39.9512789,39.9505301,39.9502943,39.9502786,39.9496281,39.9503869,39.9543944,39.9486272,39.9485658,39.9556688,39.9539205,39.9477453,39.9499506,39.9495269,39.9498662,39.9485127,39.9500493,39.9495688,39.950494,39.9505038,39.9539766,39.9517805,39.9489914,39.9495639,39.9509174,39.9497121],[-75.1574552,-75.1614924,-75.1666453,-75.1649353,-75.1611295,-75.1703617,-75.165297,-75.1602294,-75.1703389,-75.1578357,-75.1621608,-75.1678993,-75.1666834,-75.1625679,-75.1621493,-75.1749899,-75.1664549,-75.17157,-75.1697556,-75.1562495,-75.160513,-75.1683553,-75.1704529,-75.1543329,-75.173394,-75.1621847,-75.1720716,-75.162397,-75.160578,-75.1617433,-75.1666931,-75.1713807,-75.1616684,-75.1695181,-75.1668181,-75.150981,-75.1669645,-75.1518931,-75.1671925,-75.16985,-75.1666453,-75.1598508,-75.1708177,-75.1736121,-75.159542,-75.1621737,-75.1622446,-75.1604892,-75.1680322,-75.1624957,-75.1589615,-75.162746,-75.1625185,-75.1696621,-75.1729152,-75.1701493,-75.1617091,-75.1596095,-75.1588397],12,null,null,{"interactive":true,"className":"","stroke":false,"color":"#03F","weight":5,"opacity":0.5,"fill":true,"fillColor":"#009E91","fillOpacity":0.6},["<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#1028-yamitsuki-sushi-ramen > 1028 Yamitsuki Sushi & Ramen <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1028 Arch Street, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#1225-raw-sushi-and-sake-lounge > 1225 Raw Sushi and Sake Lounge <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1225 Sansom St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#1518-bar-and-grill > 1518 Bar and Grill <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1518 Sansom St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#air-grill-garden-dilworth-park > Air Grille Garden at Dilworth Park <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1 S 15th St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#aki-nom-nom > Aki Nom Nom <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1210 Walnut St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#artbar > ArtBar <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1800 Market St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#balcony-bar-at-the-kimmel-center > Balcony Bar at the Kimmel Center <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 300 S Broad St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#bank-and-bourbon > Bank and Bourbon <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1200 Market St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#bar-bombon > Bar Bombon <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 133 S 18th St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#bar-ly-chinatown > Bar-Ly Chinatown <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 101 N. 11th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#barbuzzo > Barbuzzo <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 110 S 13th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#bellini > Bellini <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 220 S 16th St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#blume > Blume <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1500 Locust Street, Philadelphia, PA, 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#brü-craft-wurst > Brü Craft & Wurst <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1318 Chestnut St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#bud-marilyns > Bud & Marilyn's <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1234 Locust St, Philadephia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#butcher-bar > Butcher Bar <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 2034 Chestnut St, Philadelphia PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#capriccio-café-and-bar > Capriccio Café and Bar <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 110 N 16th St, Philadelphia PA, 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#cavanaugh-s-rittenhouse > Cavanaugh's Rittenhouse <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1823 Sansom St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#city-tap-house-logan-square > City Tap House Logan Square <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 2 Logan Square, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#city-winery > City Winery <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 990 Filbert St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#clementine-s-stable-cafe > Clementine's Stable Cafe <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 631 N. Broad St, Philadelphia, PA 19123 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#con-murphy-s-irish-pub > Con Murphy's Irish Pub <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1700 Ben Franklin Pkwy, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#continental-midtown-2 > Continental Midtown <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1801 Chestnut St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#craftsman-row-saloon > Craftsman Row Saloon <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 112 S. 8th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#dim-sum-house-by-jane-g-s > Dim Sum House by Jane G's <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1930 Chestnut St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#doubleknot > Double Knot <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 120 S 13th St. , Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#drinker-s-pub > Drinker's Pub <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1903 Chestnut St., Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#drury-beer-garden > Drury Beer Garden <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1311 Sansom St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#finn-mccools-ale-house > Finn McCools Ale House <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 118 S 12th Street, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#gabi > Gabi <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 339 North Broad St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#giuseppe-and-sons > Giuseppe and Sons <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1523 Sansom St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#the-goat-rittenhouse > The Goat Rittenhouse <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1907 Sansom St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#good-luck-pizza-co > Good Luck Pizza Co. <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 105 S. 13th St., Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#gran-caffe-l-aquila > Gran Caffe L'Aquila <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1716 Chestnut St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#harp-crown1 > Harp & Crown <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1525 Sansom St, Philadelphia, PA, 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#independence-beer-garden > Independence Beer Garden <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 100 S Independence Mall W, Philadelphia, PA 19106 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#ladder-15 > Ladder 15 <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1528 Sansom St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#lascalas > LaScala's Fire <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 615 Chestnut St, Philadelphia, PA 19106 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#marathon-16th-sansom > Marathon 16th & Sansom <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 121 S 16th St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#misconduct-tavern > Misconduct Tavern <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1801 John F Kennedy Blvd, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#misconduct-tavern8 > Misconduct Tavern <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1511 Locust St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#moriarty-s-restaurant > Moriarty's Restaurant <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1116 Walnut St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#the-mulberry-on-arch > The Mulberry on Arch <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1835 Arch St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#paganos-market-and-bar > Pagano's Market and Bar <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 2001 Market St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#picanha-brazilian-steakhouse > Picanha Brazilian Steakhouse <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1111 Locust St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#prunella > Prunella <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 112 S 13th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#sampan7 > Sampan <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 124 S 13th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#sueno > Sueno <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 114 S. 12th St., Philadelphia PA, 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#tequilas-restaurant > Tequilas Restaurant <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1602 Locust St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#time-restaurant > Time Restaurant <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1315 Sansom St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#top-tomato-bar-pizza > Top Tomato Bar & Pizza <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 116 S 11th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#tradesman-s > Tradesman's <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1322 Chestnut Street, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#u-bahn > U-Bahn <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1320 Chestnut St, Philadephia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#uptown-beer-garden > Uptown Beer Garden <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1735 John F Kennedy Blvd, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#veda > Veda <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1920 Chestnut St., Philadelphia PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#via-locust > Via Locusta <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1723 Locust St,  Philadelphia PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#vintage-wine-bar-bistro > Vintage Wine Bar & Bistro <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 129 S 13th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#the-wayward-canopy > The Wayward <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1170 Ludlow St., Philadelphia, PA <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#wrap-shack > Wrap Shack <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 112 S 11th St., Philadelphia, PA 19107 <\/p>"],null,["1028 Yamitsuki Sushi &amp; Ramen","1225 Raw Sushi and Sake Lounge","1518 Bar and Grill","Air Grille Garden at Dilworth Park","Aki Nom Nom","ArtBar","Balcony Bar at the Kimmel Center","Bank and Bourbon","Bar Bombon","Bar-Ly Chinatown","Barbuzzo","Bellini","Blume","Brü Craft &amp; Wurst","Bud &amp; Marilyn's","Butcher Bar","Capriccio Café and Bar","Cavanaugh's Rittenhouse","City Tap House Logan Square","City Winery","Clementine's Stable Cafe","Con Murphy's Irish Pub","Continental Midtown","Craftsman Row Saloon","Dim Sum House by Jane G's","Double Knot","Drinker's Pub","Drury Beer Garden","Finn McCools Ale House","Gabi","Giuseppe and Sons","The Goat Rittenhouse","Good Luck Pizza Co.","Gran Caffe L'Aquila","Harp &amp; Crown","Independence Beer Garden","Ladder 15","LaScala's Fire","Marathon 16th &amp; Sansom","Misconduct Tavern","Misconduct Tavern","Moriarty's Restaurant","The Mulberry on Arch","Pagano's Market and Bar","Picanha Brazilian Steakhouse","Prunella","Sampan","Sueno","Tequilas Restaurant","Time Restaurant","Top Tomato Bar &amp; Pizza","Tradesman's","U-Bahn","Uptown Beer Garden","Veda","Via Locusta","Vintage Wine Bar &amp; Bistro","The Wayward","Wrap Shack"],{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"style":{"font-family":"Red Hat Text, sans-serif","font-size":"1.2em"},"className":"","sticky":true},null,null]}],"limits":{"lat":[39.9467935,39.9645357],"lng":[-75.1749899,-75.150981]}},"evals":[],"jsHooks":[]}</script>

### Adding the map background

``` r
leaflet(data = specials, 
        width = "100%", 
        height = "850px",
        # https://stackoverflow.com/a/42170340
        options = tileOptions(minZoom = 15,
                              maxZoom = 19)) %>%
  # add map markers ----
  addCircles(
    lat = ~ specials$Latitude, 
    lng = ~ specials$Longitude, 
    fillColor = "#009E91", #olivedrab goldenrod
    fillOpacity = 0.6, 
    stroke = F,
    radius = 12, 
    popup = popInfoCircles,
    label = ~ Name,
    labelOptions = labelOptions(
      style = list(
        "font-family" = "Red Hat Text, sans-serif",
        "font-size" = "1.2em")
      )) %>%
  # add map tiles in the background ----
  addProviderTiles(providers$CartoDB.Positron)
```

<div id="htmlwidget-35fe6b91c3a3c2b5b27d" style="width:100%;height:850px;" class="leaflet html-widget"></div>
<script type="application/json" data-for="htmlwidget-35fe6b91c3a3c2b5b27d">{"x":{"options":{"minZoom":15,"maxZoom":19,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false},"calls":[{"method":"addCircles","args":[[39.9535423,39.9500363,39.9501977,39.9526642,39.9488888,39.9527827,39.9467935,39.9517476,39.9506007,39.9543618,39.9500062,39.9490852,39.9482475,39.950472,39.9477828,39.9520312,39.9554292,39.9511145,39.9557898,39.9524665,39.9645357,39.9557404,39.9519308,39.9491023,39.9518233,39.9497054,39.9521221,39.95006,39.949742,39.9592359,39.9504997,39.9510645,39.9504002,39.9512789,39.9505301,39.9502943,39.9502786,39.9496281,39.9503869,39.9543944,39.9486272,39.9485658,39.9556688,39.9539205,39.9477453,39.9499506,39.9495269,39.9498662,39.9485127,39.9500493,39.9495688,39.950494,39.9505038,39.9539766,39.9517805,39.9489914,39.9495639,39.9509174,39.9497121],[-75.1574552,-75.1614924,-75.1666453,-75.1649353,-75.1611295,-75.1703617,-75.165297,-75.1602294,-75.1703389,-75.1578357,-75.1621608,-75.1678993,-75.1666834,-75.1625679,-75.1621493,-75.1749899,-75.1664549,-75.17157,-75.1697556,-75.1562495,-75.160513,-75.1683553,-75.1704529,-75.1543329,-75.173394,-75.1621847,-75.1720716,-75.162397,-75.160578,-75.1617433,-75.1666931,-75.1713807,-75.1616684,-75.1695181,-75.1668181,-75.150981,-75.1669645,-75.1518931,-75.1671925,-75.16985,-75.1666453,-75.1598508,-75.1708177,-75.1736121,-75.159542,-75.1621737,-75.1622446,-75.1604892,-75.1680322,-75.1624957,-75.1589615,-75.162746,-75.1625185,-75.1696621,-75.1729152,-75.1701493,-75.1617091,-75.1596095,-75.1588397],12,null,null,{"interactive":true,"className":"","stroke":false,"color":"#03F","weight":5,"opacity":0.5,"fill":true,"fillColor":"#009E91","fillOpacity":0.6},["<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#1028-yamitsuki-sushi-ramen > 1028 Yamitsuki Sushi & Ramen <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1028 Arch Street, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#1225-raw-sushi-and-sake-lounge > 1225 Raw Sushi and Sake Lounge <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1225 Sansom St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#1518-bar-and-grill > 1518 Bar and Grill <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1518 Sansom St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#air-grill-garden-dilworth-park > Air Grille Garden at Dilworth Park <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1 S 15th St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#aki-nom-nom > Aki Nom Nom <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1210 Walnut St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#artbar > ArtBar <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1800 Market St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#balcony-bar-at-the-kimmel-center > Balcony Bar at the Kimmel Center <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 300 S Broad St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#bank-and-bourbon > Bank and Bourbon <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1200 Market St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#bar-bombon > Bar Bombon <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 133 S 18th St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#bar-ly-chinatown > Bar-Ly Chinatown <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 101 N. 11th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#barbuzzo > Barbuzzo <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 110 S 13th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#bellini > Bellini <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 220 S 16th St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#blume > Blume <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1500 Locust Street, Philadelphia, PA, 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#brü-craft-wurst > Brü Craft & Wurst <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1318 Chestnut St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#bud-marilyns > Bud & Marilyn's <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1234 Locust St, Philadephia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#butcher-bar > Butcher Bar <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 2034 Chestnut St, Philadelphia PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#capriccio-café-and-bar > Capriccio Café and Bar <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 110 N 16th St, Philadelphia PA, 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#cavanaugh-s-rittenhouse > Cavanaugh's Rittenhouse <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1823 Sansom St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#city-tap-house-logan-square > City Tap House Logan Square <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 2 Logan Square, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#city-winery > City Winery <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 990 Filbert St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#clementine-s-stable-cafe > Clementine's Stable Cafe <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 631 N. Broad St, Philadelphia, PA 19123 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#con-murphy-s-irish-pub > Con Murphy's Irish Pub <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1700 Ben Franklin Pkwy, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#continental-midtown-2 > Continental Midtown <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1801 Chestnut St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#craftsman-row-saloon > Craftsman Row Saloon <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 112 S. 8th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#dim-sum-house-by-jane-g-s > Dim Sum House by Jane G's <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1930 Chestnut St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#doubleknot > Double Knot <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 120 S 13th St. , Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#drinker-s-pub > Drinker's Pub <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1903 Chestnut St., Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#drury-beer-garden > Drury Beer Garden <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1311 Sansom St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#finn-mccools-ale-house > Finn McCools Ale House <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 118 S 12th Street, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#gabi > Gabi <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 339 North Broad St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#giuseppe-and-sons > Giuseppe and Sons <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1523 Sansom St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#the-goat-rittenhouse > The Goat Rittenhouse <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1907 Sansom St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#good-luck-pizza-co > Good Luck Pizza Co. <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 105 S. 13th St., Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#gran-caffe-l-aquila > Gran Caffe L'Aquila <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1716 Chestnut St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#harp-crown1 > Harp & Crown <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1525 Sansom St, Philadelphia, PA, 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#independence-beer-garden > Independence Beer Garden <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 100 S Independence Mall W, Philadelphia, PA 19106 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#ladder-15 > Ladder 15 <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1528 Sansom St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#lascalas > LaScala's Fire <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 615 Chestnut St, Philadelphia, PA 19106 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#marathon-16th-sansom > Marathon 16th & Sansom <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 121 S 16th St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#misconduct-tavern > Misconduct Tavern <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1801 John F Kennedy Blvd, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#misconduct-tavern8 > Misconduct Tavern <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1511 Locust St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#moriarty-s-restaurant > Moriarty's Restaurant <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1116 Walnut St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#the-mulberry-on-arch > The Mulberry on Arch <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1835 Arch St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#paganos-market-and-bar > Pagano's Market and Bar <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 2001 Market St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#picanha-brazilian-steakhouse > Picanha Brazilian Steakhouse <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1111 Locust St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#prunella > Prunella <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 112 S 13th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#sampan7 > Sampan <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 124 S 13th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#sueno > Sueno <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 114 S. 12th St., Philadelphia PA, 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#tequilas-restaurant > Tequilas Restaurant <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1602 Locust St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#time-restaurant > Time Restaurant <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1315 Sansom St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#top-tomato-bar-pizza > Top Tomato Bar & Pizza <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 116 S 11th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#tradesman-s > Tradesman's <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1322 Chestnut Street, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#u-bahn > U-Bahn <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1320 Chestnut St, Philadephia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#uptown-beer-garden > Uptown Beer Garden <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1735 John F Kennedy Blvd, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#veda > Veda <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1920 Chestnut St., Philadelphia PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#via-locust > Via Locusta <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1723 Locust St,  Philadelphia PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#vintage-wine-bar-bistro > Vintage Wine Bar & Bistro <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 129 S 13th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#the-wayward-canopy > The Wayward <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1170 Ludlow St., Philadelphia, PA <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#wrap-shack > Wrap Shack <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 112 S 11th St., Philadelphia, PA 19107 <\/p>"],null,["1028 Yamitsuki Sushi &amp; Ramen","1225 Raw Sushi and Sake Lounge","1518 Bar and Grill","Air Grille Garden at Dilworth Park","Aki Nom Nom","ArtBar","Balcony Bar at the Kimmel Center","Bank and Bourbon","Bar Bombon","Bar-Ly Chinatown","Barbuzzo","Bellini","Blume","Brü Craft &amp; Wurst","Bud &amp; Marilyn's","Butcher Bar","Capriccio Café and Bar","Cavanaugh's Rittenhouse","City Tap House Logan Square","City Winery","Clementine's Stable Cafe","Con Murphy's Irish Pub","Continental Midtown","Craftsman Row Saloon","Dim Sum House by Jane G's","Double Knot","Drinker's Pub","Drury Beer Garden","Finn McCools Ale House","Gabi","Giuseppe and Sons","The Goat Rittenhouse","Good Luck Pizza Co.","Gran Caffe L'Aquila","Harp &amp; Crown","Independence Beer Garden","Ladder 15","LaScala's Fire","Marathon 16th &amp; Sansom","Misconduct Tavern","Misconduct Tavern","Moriarty's Restaurant","The Mulberry on Arch","Pagano's Market and Bar","Picanha Brazilian Steakhouse","Prunella","Sampan","Sueno","Tequilas Restaurant","Time Restaurant","Top Tomato Bar &amp; Pizza","Tradesman's","U-Bahn","Uptown Beer Garden","Veda","Via Locusta","Vintage Wine Bar &amp; Bistro","The Wayward","Wrap Shack"],{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"style":{"font-family":"Red Hat Text, sans-serif","font-size":"1.2em"},"className":"","sticky":true},null,null]},{"method":"addProviderTiles","args":["CartoDB.Positron",null,null,{"errorTileUrl":"","noWrap":false,"detectRetina":false}]}],"limits":{"lat":[39.9467935,39.9645357],"lng":[-75.1749899,-75.150981]}},"evals":[],"jsHooks":[]}</script>

### Setting the map view

``` r
leaflet(data = specials, 
        width = "100%", 
        height = "850px",
        # https://stackoverflow.com/a/42170340
        options = tileOptions(minZoom = 15,
                              maxZoom = 19)) %>%
  # add map markers ----
  addCircles(
    lat = ~ specials$Latitude, 
    lng = ~ specials$Longitude, 
    fillColor = "#009E91", #olivedrab goldenrod
    fillOpacity = 0.6, 
    stroke = F,
    radius = 12, 
    popup = popInfoCircles,
    label = ~ Name,
    labelOptions = labelOptions(
      style = list(
        "font-family" = "Red Hat Text, sans-serif",
        "font-size" = "1.2em")
      )) %>%
  # add map tiles in the background ----
  addProviderTiles(providers$CartoDB.Positron) %>%
  # set the map view
  setView(mean(specials$Longitude), 
          mean(specials$Latitude), 
          zoom = 16)
```

<div id="htmlwidget-aa64de12e57fb3f0636c" style="width:100%;height:850px;" class="leaflet html-widget"></div>
<script type="application/json" data-for="htmlwidget-aa64de12e57fb3f0636c">{"x":{"options":{"minZoom":15,"maxZoom":19,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false},"calls":[{"method":"addCircles","args":[[39.9535423,39.9500363,39.9501977,39.9526642,39.9488888,39.9527827,39.9467935,39.9517476,39.9506007,39.9543618,39.9500062,39.9490852,39.9482475,39.950472,39.9477828,39.9520312,39.9554292,39.9511145,39.9557898,39.9524665,39.9645357,39.9557404,39.9519308,39.9491023,39.9518233,39.9497054,39.9521221,39.95006,39.949742,39.9592359,39.9504997,39.9510645,39.9504002,39.9512789,39.9505301,39.9502943,39.9502786,39.9496281,39.9503869,39.9543944,39.9486272,39.9485658,39.9556688,39.9539205,39.9477453,39.9499506,39.9495269,39.9498662,39.9485127,39.9500493,39.9495688,39.950494,39.9505038,39.9539766,39.9517805,39.9489914,39.9495639,39.9509174,39.9497121],[-75.1574552,-75.1614924,-75.1666453,-75.1649353,-75.1611295,-75.1703617,-75.165297,-75.1602294,-75.1703389,-75.1578357,-75.1621608,-75.1678993,-75.1666834,-75.1625679,-75.1621493,-75.1749899,-75.1664549,-75.17157,-75.1697556,-75.1562495,-75.160513,-75.1683553,-75.1704529,-75.1543329,-75.173394,-75.1621847,-75.1720716,-75.162397,-75.160578,-75.1617433,-75.1666931,-75.1713807,-75.1616684,-75.1695181,-75.1668181,-75.150981,-75.1669645,-75.1518931,-75.1671925,-75.16985,-75.1666453,-75.1598508,-75.1708177,-75.1736121,-75.159542,-75.1621737,-75.1622446,-75.1604892,-75.1680322,-75.1624957,-75.1589615,-75.162746,-75.1625185,-75.1696621,-75.1729152,-75.1701493,-75.1617091,-75.1596095,-75.1588397],12,null,null,{"interactive":true,"className":"","stroke":false,"color":"#03F","weight":5,"opacity":0.5,"fill":true,"fillColor":"#009E91","fillOpacity":0.6},["<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#1028-yamitsuki-sushi-ramen > 1028 Yamitsuki Sushi & Ramen <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1028 Arch Street, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#1225-raw-sushi-and-sake-lounge > 1225 Raw Sushi and Sake Lounge <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1225 Sansom St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#1518-bar-and-grill > 1518 Bar and Grill <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1518 Sansom St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#air-grill-garden-dilworth-park > Air Grille Garden at Dilworth Park <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1 S 15th St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#aki-nom-nom > Aki Nom Nom <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1210 Walnut St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#artbar > ArtBar <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1800 Market St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#balcony-bar-at-the-kimmel-center > Balcony Bar at the Kimmel Center <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 300 S Broad St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#bank-and-bourbon > Bank and Bourbon <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1200 Market St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#bar-bombon > Bar Bombon <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 133 S 18th St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#bar-ly-chinatown > Bar-Ly Chinatown <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 101 N. 11th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#barbuzzo > Barbuzzo <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 110 S 13th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#bellini > Bellini <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 220 S 16th St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#blume > Blume <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1500 Locust Street, Philadelphia, PA, 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#brü-craft-wurst > Brü Craft & Wurst <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1318 Chestnut St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#bud-marilyns > Bud & Marilyn's <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1234 Locust St, Philadephia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#butcher-bar > Butcher Bar <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 2034 Chestnut St, Philadelphia PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#capriccio-café-and-bar > Capriccio Café and Bar <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 110 N 16th St, Philadelphia PA, 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#cavanaugh-s-rittenhouse > Cavanaugh's Rittenhouse <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1823 Sansom St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#city-tap-house-logan-square > City Tap House Logan Square <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 2 Logan Square, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#city-winery > City Winery <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 990 Filbert St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#clementine-s-stable-cafe > Clementine's Stable Cafe <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 631 N. Broad St, Philadelphia, PA 19123 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#con-murphy-s-irish-pub > Con Murphy's Irish Pub <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1700 Ben Franklin Pkwy, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#continental-midtown-2 > Continental Midtown <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1801 Chestnut St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#craftsman-row-saloon > Craftsman Row Saloon <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 112 S. 8th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#dim-sum-house-by-jane-g-s > Dim Sum House by Jane G's <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1930 Chestnut St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#doubleknot > Double Knot <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 120 S 13th St. , Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#drinker-s-pub > Drinker's Pub <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1903 Chestnut St., Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#drury-beer-garden > Drury Beer Garden <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1311 Sansom St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#finn-mccools-ale-house > Finn McCools Ale House <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 118 S 12th Street, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#gabi > Gabi <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 339 North Broad St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#giuseppe-and-sons > Giuseppe and Sons <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1523 Sansom St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#the-goat-rittenhouse > The Goat Rittenhouse <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1907 Sansom St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#good-luck-pizza-co > Good Luck Pizza Co. <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 105 S. 13th St., Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#gran-caffe-l-aquila > Gran Caffe L'Aquila <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1716 Chestnut St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#harp-crown1 > Harp & Crown <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1525 Sansom St, Philadelphia, PA, 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#independence-beer-garden > Independence Beer Garden <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 100 S Independence Mall W, Philadelphia, PA 19106 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#ladder-15 > Ladder 15 <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1528 Sansom St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#lascalas > LaScala's Fire <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 615 Chestnut St, Philadelphia, PA 19106 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#marathon-16th-sansom > Marathon 16th & Sansom <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 121 S 16th St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#misconduct-tavern > Misconduct Tavern <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1801 John F Kennedy Blvd, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#misconduct-tavern8 > Misconduct Tavern <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1511 Locust St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#moriarty-s-restaurant > Moriarty's Restaurant <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1116 Walnut St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#the-mulberry-on-arch > The Mulberry on Arch <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1835 Arch St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#paganos-market-and-bar > Pagano's Market and Bar <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 2001 Market St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#picanha-brazilian-steakhouse > Picanha Brazilian Steakhouse <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1111 Locust St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#prunella > Prunella <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 112 S 13th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#sampan7 > Sampan <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 124 S 13th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#sueno > Sueno <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 114 S. 12th St., Philadelphia PA, 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#tequilas-restaurant > Tequilas Restaurant <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1602 Locust St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#time-restaurant > Time Restaurant <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1315 Sansom St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#top-tomato-bar-pizza > Top Tomato Bar & Pizza <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 116 S 11th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#tradesman-s > Tradesman's <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1322 Chestnut Street, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#u-bahn > U-Bahn <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1320 Chestnut St, Philadephia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#uptown-beer-garden > Uptown Beer Garden <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1735 John F Kennedy Blvd, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#veda > Veda <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1920 Chestnut St., Philadelphia PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#via-locust > Via Locusta <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1723 Locust St,  Philadelphia PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#vintage-wine-bar-bistro > Vintage Wine Bar & Bistro <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 129 S 13th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#the-wayward-canopy > The Wayward <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1170 Ludlow St., Philadelphia, PA <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#wrap-shack > Wrap Shack <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 112 S 11th St., Philadelphia, PA 19107 <\/p>"],null,["1028 Yamitsuki Sushi &amp; Ramen","1225 Raw Sushi and Sake Lounge","1518 Bar and Grill","Air Grille Garden at Dilworth Park","Aki Nom Nom","ArtBar","Balcony Bar at the Kimmel Center","Bank and Bourbon","Bar Bombon","Bar-Ly Chinatown","Barbuzzo","Bellini","Blume","Brü Craft &amp; Wurst","Bud &amp; Marilyn's","Butcher Bar","Capriccio Café and Bar","Cavanaugh's Rittenhouse","City Tap House Logan Square","City Winery","Clementine's Stable Cafe","Con Murphy's Irish Pub","Continental Midtown","Craftsman Row Saloon","Dim Sum House by Jane G's","Double Knot","Drinker's Pub","Drury Beer Garden","Finn McCools Ale House","Gabi","Giuseppe and Sons","The Goat Rittenhouse","Good Luck Pizza Co.","Gran Caffe L'Aquila","Harp &amp; Crown","Independence Beer Garden","Ladder 15","LaScala's Fire","Marathon 16th &amp; Sansom","Misconduct Tavern","Misconduct Tavern","Moriarty's Restaurant","The Mulberry on Arch","Pagano's Market and Bar","Picanha Brazilian Steakhouse","Prunella","Sampan","Sueno","Tequilas Restaurant","Time Restaurant","Top Tomato Bar &amp; Pizza","Tradesman's","U-Bahn","Uptown Beer Garden","Veda","Via Locusta","Vintage Wine Bar &amp; Bistro","The Wayward","Wrap Shack"],{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"style":{"font-family":"Red Hat Text, sans-serif","font-size":"1.2em"},"className":"","sticky":true},null,null]},{"method":"addProviderTiles","args":["CartoDB.Positron",null,null,{"errorTileUrl":"","noWrap":false,"detectRetina":false}]}],"limits":{"lat":[39.9467935,39.9645357],"lng":[-75.1749899,-75.150981]},"setView":[[39.9512667101695,-75.1645457186441],16,[]]},"evals":[],"jsHooks":[]}</script>

### Adding a marker at the center

``` r
leaflet(data = specials, 
        width = "100%", 
        height = "850px",
        # https://stackoverflow.com/a/42170340
        options = tileOptions(minZoom = 15,
                              maxZoom = 19)) %>%
  # add map markers ----
  addCircles(
    lat = ~ specials$Latitude, 
    lng = ~ specials$Longitude, 
    fillColor = "#009E91", #olivedrab goldenrod
    fillOpacity = 0.6,
    stroke = F,
    radius = 12, 
    popup = popInfoCircles,
    label = ~ Name,
    labelOptions = labelOptions(
      style = list(
        "font-family" = "Red Hat Text, sans-serif",
        "font-size" = "1.2em")
      )) %>%
  # add map tiles in the background ----
  addProviderTiles(providers$CartoDB.Positron) %>%
  # set the map view
  setView(mean(specials$Longitude), 
          mean(specials$Latitude), 
          zoom = 16) %>%
  # add marker at the center ----
  addAwesomeMarkers(
    icon = awesome,
    lng = mean(specials$Longitude), 
    lat = mean(specials$Latitude), 
    label = "Center City District Sips 2022",
    labelOptions = labelOptions(
      style = list(
        "font-family" = "Red Hat Text, sans-serif",
        "font-size" = "1.2em")
      ),
    popup = popInfoMarker,
    popupOptions = popupOptions(maxWidth = 250))
```

<div id="htmlwidget-a5d8780506d0193d3b96" style="width:100%;height:850px;" class="leaflet html-widget"></div>
<script type="application/json" data-for="htmlwidget-a5d8780506d0193d3b96">{"x":{"options":{"minZoom":15,"maxZoom":19,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false},"calls":[{"method":"addCircles","args":[[39.9535423,39.9500363,39.9501977,39.9526642,39.9488888,39.9527827,39.9467935,39.9517476,39.9506007,39.9543618,39.9500062,39.9490852,39.9482475,39.950472,39.9477828,39.9520312,39.9554292,39.9511145,39.9557898,39.9524665,39.9645357,39.9557404,39.9519308,39.9491023,39.9518233,39.9497054,39.9521221,39.95006,39.949742,39.9592359,39.9504997,39.9510645,39.9504002,39.9512789,39.9505301,39.9502943,39.9502786,39.9496281,39.9503869,39.9543944,39.9486272,39.9485658,39.9556688,39.9539205,39.9477453,39.9499506,39.9495269,39.9498662,39.9485127,39.9500493,39.9495688,39.950494,39.9505038,39.9539766,39.9517805,39.9489914,39.9495639,39.9509174,39.9497121],[-75.1574552,-75.1614924,-75.1666453,-75.1649353,-75.1611295,-75.1703617,-75.165297,-75.1602294,-75.1703389,-75.1578357,-75.1621608,-75.1678993,-75.1666834,-75.1625679,-75.1621493,-75.1749899,-75.1664549,-75.17157,-75.1697556,-75.1562495,-75.160513,-75.1683553,-75.1704529,-75.1543329,-75.173394,-75.1621847,-75.1720716,-75.162397,-75.160578,-75.1617433,-75.1666931,-75.1713807,-75.1616684,-75.1695181,-75.1668181,-75.150981,-75.1669645,-75.1518931,-75.1671925,-75.16985,-75.1666453,-75.1598508,-75.1708177,-75.1736121,-75.159542,-75.1621737,-75.1622446,-75.1604892,-75.1680322,-75.1624957,-75.1589615,-75.162746,-75.1625185,-75.1696621,-75.1729152,-75.1701493,-75.1617091,-75.1596095,-75.1588397],12,null,null,{"interactive":true,"className":"","stroke":false,"color":"#03F","weight":5,"opacity":0.5,"fill":true,"fillColor":"#009E91","fillOpacity":0.6},["<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#1028-yamitsuki-sushi-ramen > 1028 Yamitsuki Sushi & Ramen <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1028 Arch Street, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#1225-raw-sushi-and-sake-lounge > 1225 Raw Sushi and Sake Lounge <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1225 Sansom St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#1518-bar-and-grill > 1518 Bar and Grill <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1518 Sansom St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#air-grill-garden-dilworth-park > Air Grille Garden at Dilworth Park <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1 S 15th St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#aki-nom-nom > Aki Nom Nom <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1210 Walnut St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#artbar > ArtBar <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1800 Market St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#balcony-bar-at-the-kimmel-center > Balcony Bar at the Kimmel Center <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 300 S Broad St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#bank-and-bourbon > Bank and Bourbon <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1200 Market St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#bar-bombon > Bar Bombon <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 133 S 18th St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#bar-ly-chinatown > Bar-Ly Chinatown <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 101 N. 11th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#barbuzzo > Barbuzzo <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 110 S 13th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#bellini > Bellini <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 220 S 16th St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#blume > Blume <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1500 Locust Street, Philadelphia, PA, 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#brü-craft-wurst > Brü Craft & Wurst <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1318 Chestnut St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#bud-marilyns > Bud & Marilyn's <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1234 Locust St, Philadephia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#butcher-bar > Butcher Bar <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 2034 Chestnut St, Philadelphia PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#capriccio-café-and-bar > Capriccio Café and Bar <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 110 N 16th St, Philadelphia PA, 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#cavanaugh-s-rittenhouse > Cavanaugh's Rittenhouse <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1823 Sansom St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#city-tap-house-logan-square > City Tap House Logan Square <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 2 Logan Square, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#city-winery > City Winery <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 990 Filbert St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#clementine-s-stable-cafe > Clementine's Stable Cafe <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 631 N. Broad St, Philadelphia, PA 19123 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#con-murphy-s-irish-pub > Con Murphy's Irish Pub <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1700 Ben Franklin Pkwy, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#continental-midtown-2 > Continental Midtown <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1801 Chestnut St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#craftsman-row-saloon > Craftsman Row Saloon <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 112 S. 8th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#dim-sum-house-by-jane-g-s > Dim Sum House by Jane G's <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1930 Chestnut St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#doubleknot > Double Knot <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 120 S 13th St. , Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#drinker-s-pub > Drinker's Pub <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1903 Chestnut St., Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#drury-beer-garden > Drury Beer Garden <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1311 Sansom St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#finn-mccools-ale-house > Finn McCools Ale House <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 118 S 12th Street, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#gabi > Gabi <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 339 North Broad St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#giuseppe-and-sons > Giuseppe and Sons <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1523 Sansom St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#the-goat-rittenhouse > The Goat Rittenhouse <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1907 Sansom St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#good-luck-pizza-co > Good Luck Pizza Co. <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 105 S. 13th St., Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#gran-caffe-l-aquila > Gran Caffe L'Aquila <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1716 Chestnut St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#harp-crown1 > Harp & Crown <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1525 Sansom St, Philadelphia, PA, 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#independence-beer-garden > Independence Beer Garden <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 100 S Independence Mall W, Philadelphia, PA 19106 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#ladder-15 > Ladder 15 <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1528 Sansom St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#lascalas > LaScala's Fire <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 615 Chestnut St, Philadelphia, PA 19106 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#marathon-16th-sansom > Marathon 16th & Sansom <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 121 S 16th St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#misconduct-tavern > Misconduct Tavern <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1801 John F Kennedy Blvd, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#misconduct-tavern8 > Misconduct Tavern <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1511 Locust St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#moriarty-s-restaurant > Moriarty's Restaurant <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1116 Walnut St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#the-mulberry-on-arch > The Mulberry on Arch <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1835 Arch St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#paganos-market-and-bar > Pagano's Market and Bar <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 2001 Market St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#picanha-brazilian-steakhouse > Picanha Brazilian Steakhouse <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1111 Locust St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#prunella > Prunella <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 112 S 13th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#sampan7 > Sampan <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 124 S 13th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#sueno > Sueno <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 114 S. 12th St., Philadelphia PA, 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#tequilas-restaurant > Tequilas Restaurant <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1602 Locust St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#time-restaurant > Time Restaurant <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1315 Sansom St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#top-tomato-bar-pizza > Top Tomato Bar & Pizza <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 116 S 11th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#tradesman-s > Tradesman's <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1322 Chestnut Street, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#u-bahn > U-Bahn <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1320 Chestnut St, Philadephia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#uptown-beer-garden > Uptown Beer Garden <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1735 John F Kennedy Blvd, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#veda > Veda <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1920 Chestnut St., Philadelphia PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#via-locust > Via Locusta <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1723 Locust St,  Philadelphia PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#vintage-wine-bar-bistro > Vintage Wine Bar & Bistro <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 129 S 13th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#the-wayward-canopy > The Wayward <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1170 Ludlow St., Philadelphia, PA <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#wrap-shack > Wrap Shack <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 112 S 11th St., Philadelphia, PA 19107 <\/p>"],null,["1028 Yamitsuki Sushi &amp; Ramen","1225 Raw Sushi and Sake Lounge","1518 Bar and Grill","Air Grille Garden at Dilworth Park","Aki Nom Nom","ArtBar","Balcony Bar at the Kimmel Center","Bank and Bourbon","Bar Bombon","Bar-Ly Chinatown","Barbuzzo","Bellini","Blume","Brü Craft &amp; Wurst","Bud &amp; Marilyn's","Butcher Bar","Capriccio Café and Bar","Cavanaugh's Rittenhouse","City Tap House Logan Square","City Winery","Clementine's Stable Cafe","Con Murphy's Irish Pub","Continental Midtown","Craftsman Row Saloon","Dim Sum House by Jane G's","Double Knot","Drinker's Pub","Drury Beer Garden","Finn McCools Ale House","Gabi","Giuseppe and Sons","The Goat Rittenhouse","Good Luck Pizza Co.","Gran Caffe L'Aquila","Harp &amp; Crown","Independence Beer Garden","Ladder 15","LaScala's Fire","Marathon 16th &amp; Sansom","Misconduct Tavern","Misconduct Tavern","Moriarty's Restaurant","The Mulberry on Arch","Pagano's Market and Bar","Picanha Brazilian Steakhouse","Prunella","Sampan","Sueno","Tequilas Restaurant","Time Restaurant","Top Tomato Bar &amp; Pizza","Tradesman's","U-Bahn","Uptown Beer Garden","Veda","Via Locusta","Vintage Wine Bar &amp; Bistro","The Wayward","Wrap Shack"],{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"style":{"font-family":"Red Hat Text, sans-serif","font-size":"1.2em"},"className":"","sticky":true},null,null]},{"method":"addProviderTiles","args":["CartoDB.Positron",null,null,{"errorTileUrl":"","noWrap":false,"detectRetina":false}]},{"method":"addAwesomeMarkers","args":[39.9512667101695,-75.1645457186441,{"icon":"map-pin","markerColor":"darkblue","iconColor":"#FFFFFF","spin":false,"squareMarker":false,"iconRotate":0,"font":"monospace","prefix":"fa"},null,null,{"interactive":true,"draggable":false,"keyboard":true,"title":"","alt":"","zIndexOffset":0,"opacity":1,"riseOnHover":false,"riseOffset":250},"<h1 style='padding-top: 0.5em; margin-top: 1em; margin-bottom: 0.5em; font-family: Red Hat Text, sans-serif; font-size: 1.8em; color:#43464C;'> <a style='color: #00857A;' href='https://centercityphila.org/explore-center-city/ccdsips'> Center City District Sips 2022 <\/a><\/h1><p style='color:#9197A6; font-family: Red Hat Text, sans-serif; font-size: 1.5em; padding-bottom: 1em;'> Philadelphia, PA <\/p>",{"maxWidth":250,"minWidth":50,"autoPan":true,"keepInView":false,"closeButton":true,"className":""},null,null,"Center City District Sips 2022",{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"style":{"font-family":"Red Hat Text, sans-serif","font-size":"1.2em"},"className":"","sticky":true},null]}],"limits":{"lat":[39.9467935,39.9645357],"lng":[-75.1749899,-75.150981]},"setView":[[39.9512667101695,-75.1645457186441],16,[]]},"evals":[],"jsHooks":[]}</script>

### Adding fullscreen control

``` r
leaflet(data = specials, 
        width = "100%", 
        height = "850px",
        # https://stackoverflow.com/a/42170340
        options = tileOptions(minZoom = 15,
                              maxZoom = 19)) %>%
  # add map markers ----
  addCircles(
    lat = ~ specials$Latitude, 
    lng = ~ specials$Longitude, 
    fillColor = "#009E91", #olivedrab goldenrod
    fillOpacity = 0.6, 
    stroke = F,
    radius = 12, 
    popup = popInfoCircles,
    label = ~ Name,
    labelOptions = labelOptions(
      style = list(
        "font-family" = "Red Hat Text, sans-serif",
        "font-size" = "1.2em")
      )) %>%
  # add map tiles in the background ----
  addProviderTiles(providers$CartoDB.Positron) %>%
  # set the map view
  setView(mean(specials$Longitude), 
          mean(specials$Latitude), 
          zoom = 16) %>%
  # add marker at the center ----
  addAwesomeMarkers(
    icon = awesome,
    lng = mean(specials$Longitude), 
    lat = mean(specials$Latitude), 
    label = "Center City District Sips 2022",
    labelOptions = labelOptions(
      style = list(
        "font-family" = "Red Hat Text, sans-serif",
        "font-size" = "1.2em")
      ),
    popup = popInfoMarker,
    popupOptions = popupOptions(maxWidth = 250)) %>% 
  # add fullscreen control button ----
  leaflet.extras::addFullscreenControl()
```

<div id="htmlwidget-bfa69b22c225b2a319b4" style="width:100%;height:850px;" class="leaflet html-widget"></div>
<script type="application/json" data-for="htmlwidget-bfa69b22c225b2a319b4">{"x":{"options":{"minZoom":15,"maxZoom":19,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"fullscreenControl":{"position":"topleft","pseudoFullscreen":false}},"calls":[{"method":"addCircles","args":[[39.9535423,39.9500363,39.9501977,39.9526642,39.9488888,39.9527827,39.9467935,39.9517476,39.9506007,39.9543618,39.9500062,39.9490852,39.9482475,39.950472,39.9477828,39.9520312,39.9554292,39.9511145,39.9557898,39.9524665,39.9645357,39.9557404,39.9519308,39.9491023,39.9518233,39.9497054,39.9521221,39.95006,39.949742,39.9592359,39.9504997,39.9510645,39.9504002,39.9512789,39.9505301,39.9502943,39.9502786,39.9496281,39.9503869,39.9543944,39.9486272,39.9485658,39.9556688,39.9539205,39.9477453,39.9499506,39.9495269,39.9498662,39.9485127,39.9500493,39.9495688,39.950494,39.9505038,39.9539766,39.9517805,39.9489914,39.9495639,39.9509174,39.9497121],[-75.1574552,-75.1614924,-75.1666453,-75.1649353,-75.1611295,-75.1703617,-75.165297,-75.1602294,-75.1703389,-75.1578357,-75.1621608,-75.1678993,-75.1666834,-75.1625679,-75.1621493,-75.1749899,-75.1664549,-75.17157,-75.1697556,-75.1562495,-75.160513,-75.1683553,-75.1704529,-75.1543329,-75.173394,-75.1621847,-75.1720716,-75.162397,-75.160578,-75.1617433,-75.1666931,-75.1713807,-75.1616684,-75.1695181,-75.1668181,-75.150981,-75.1669645,-75.1518931,-75.1671925,-75.16985,-75.1666453,-75.1598508,-75.1708177,-75.1736121,-75.159542,-75.1621737,-75.1622446,-75.1604892,-75.1680322,-75.1624957,-75.1589615,-75.162746,-75.1625185,-75.1696621,-75.1729152,-75.1701493,-75.1617091,-75.1596095,-75.1588397],12,null,null,{"interactive":true,"className":"","stroke":false,"color":"#03F","weight":5,"opacity":0.5,"fill":true,"fillColor":"#009E91","fillOpacity":0.6},["<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#1028-yamitsuki-sushi-ramen > 1028 Yamitsuki Sushi & Ramen <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1028 Arch Street, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#1225-raw-sushi-and-sake-lounge > 1225 Raw Sushi and Sake Lounge <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1225 Sansom St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#1518-bar-and-grill > 1518 Bar and Grill <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1518 Sansom St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#air-grill-garden-dilworth-park > Air Grille Garden at Dilworth Park <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1 S 15th St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#aki-nom-nom > Aki Nom Nom <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1210 Walnut St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#artbar > ArtBar <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1800 Market St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#balcony-bar-at-the-kimmel-center > Balcony Bar at the Kimmel Center <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 300 S Broad St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#bank-and-bourbon > Bank and Bourbon <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1200 Market St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#bar-bombon > Bar Bombon <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 133 S 18th St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#bar-ly-chinatown > Bar-Ly Chinatown <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 101 N. 11th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#barbuzzo > Barbuzzo <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 110 S 13th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#bellini > Bellini <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 220 S 16th St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#blume > Blume <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1500 Locust Street, Philadelphia, PA, 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#brü-craft-wurst > Brü Craft & Wurst <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1318 Chestnut St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#bud-marilyns > Bud & Marilyn's <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1234 Locust St, Philadephia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#butcher-bar > Butcher Bar <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 2034 Chestnut St, Philadelphia PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#capriccio-café-and-bar > Capriccio Café and Bar <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 110 N 16th St, Philadelphia PA, 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#cavanaugh-s-rittenhouse > Cavanaugh's Rittenhouse <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1823 Sansom St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#city-tap-house-logan-square > City Tap House Logan Square <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 2 Logan Square, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=1#city-winery > City Winery <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 990 Filbert St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#clementine-s-stable-cafe > Clementine's Stable Cafe <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 631 N. Broad St, Philadelphia, PA 19123 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#con-murphy-s-irish-pub > Con Murphy's Irish Pub <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1700 Ben Franklin Pkwy, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#continental-midtown-2 > Continental Midtown <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1801 Chestnut St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#craftsman-row-saloon > Craftsman Row Saloon <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 112 S. 8th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#dim-sum-house-by-jane-g-s > Dim Sum House by Jane G's <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1930 Chestnut St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#doubleknot > Double Knot <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 120 S 13th St. , Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#drinker-s-pub > Drinker's Pub <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1903 Chestnut St., Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#drury-beer-garden > Drury Beer Garden <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1311 Sansom St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#finn-mccools-ale-house > Finn McCools Ale House <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 118 S 12th Street, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#gabi > Gabi <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 339 North Broad St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#giuseppe-and-sons > Giuseppe and Sons <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1523 Sansom St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#the-goat-rittenhouse > The Goat Rittenhouse <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1907 Sansom St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#good-luck-pizza-co > Good Luck Pizza Co. <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 105 S. 13th St., Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#gran-caffe-l-aquila > Gran Caffe L'Aquila <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1716 Chestnut St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#harp-crown1 > Harp & Crown <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1525 Sansom St, Philadelphia, PA, 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#independence-beer-garden > Independence Beer Garden <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 100 S Independence Mall W, Philadelphia, PA 19106 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#ladder-15 > Ladder 15 <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1528 Sansom St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#lascalas > LaScala's Fire <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 615 Chestnut St, Philadelphia, PA 19106 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#marathon-16th-sansom > Marathon 16th & Sansom <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 121 S 16th St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=2#misconduct-tavern > Misconduct Tavern <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1801 John F Kennedy Blvd, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#misconduct-tavern8 > Misconduct Tavern <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1511 Locust St, Philadelphia, PA 19102 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#moriarty-s-restaurant > Moriarty's Restaurant <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1116 Walnut St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#the-mulberry-on-arch > The Mulberry on Arch <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1835 Arch St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#paganos-market-and-bar > Pagano's Market and Bar <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 2001 Market St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#picanha-brazilian-steakhouse > Picanha Brazilian Steakhouse <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1111 Locust St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#prunella > Prunella <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 112 S 13th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#sampan7 > Sampan <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 124 S 13th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#sueno > Sueno <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 114 S. 12th St., Philadelphia PA, 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#tequilas-restaurant > Tequilas Restaurant <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1602 Locust St, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#time-restaurant > Time Restaurant <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1315 Sansom St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#top-tomato-bar-pizza > Top Tomato Bar & Pizza <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 116 S 11th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#tradesman-s > Tradesman's <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1322 Chestnut Street, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#u-bahn > U-Bahn <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1320 Chestnut St, Philadephia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#uptown-beer-garden > Uptown Beer Garden <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1735 John F Kennedy Blvd, Philadelphia, PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#veda > Veda <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1920 Chestnut St., Philadelphia PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#via-locust > Via Locusta <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1723 Locust St,  Philadelphia PA 19103 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#vintage-wine-bar-bistro > Vintage Wine Bar & Bistro <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 129 S 13th St, Philadelphia, PA 19107 <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#the-wayward-canopy > The Wayward <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 1170 Ludlow St., Philadelphia, PA <\/p>","<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#43464C;'> <a style='color: #00857A;' href= https://centercityphila.org/explore-center-city/ccd-sips/sips-list-view?page=3#wrap-shack > Wrap Shack <\/a><\/h2> <p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'> 112 S 11th St., Philadelphia, PA 19107 <\/p>"],null,["1028 Yamitsuki Sushi &amp; Ramen","1225 Raw Sushi and Sake Lounge","1518 Bar and Grill","Air Grille Garden at Dilworth Park","Aki Nom Nom","ArtBar","Balcony Bar at the Kimmel Center","Bank and Bourbon","Bar Bombon","Bar-Ly Chinatown","Barbuzzo","Bellini","Blume","Brü Craft &amp; Wurst","Bud &amp; Marilyn's","Butcher Bar","Capriccio Café and Bar","Cavanaugh's Rittenhouse","City Tap House Logan Square","City Winery","Clementine's Stable Cafe","Con Murphy's Irish Pub","Continental Midtown","Craftsman Row Saloon","Dim Sum House by Jane G's","Double Knot","Drinker's Pub","Drury Beer Garden","Finn McCools Ale House","Gabi","Giuseppe and Sons","The Goat Rittenhouse","Good Luck Pizza Co.","Gran Caffe L'Aquila","Harp &amp; Crown","Independence Beer Garden","Ladder 15","LaScala's Fire","Marathon 16th &amp; Sansom","Misconduct Tavern","Misconduct Tavern","Moriarty's Restaurant","The Mulberry on Arch","Pagano's Market and Bar","Picanha Brazilian Steakhouse","Prunella","Sampan","Sueno","Tequilas Restaurant","Time Restaurant","Top Tomato Bar &amp; Pizza","Tradesman's","U-Bahn","Uptown Beer Garden","Veda","Via Locusta","Vintage Wine Bar &amp; Bistro","The Wayward","Wrap Shack"],{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"style":{"font-family":"Red Hat Text, sans-serif","font-size":"1.2em"},"className":"","sticky":true},null,null]},{"method":"addProviderTiles","args":["CartoDB.Positron",null,null,{"errorTileUrl":"","noWrap":false,"detectRetina":false}]},{"method":"addAwesomeMarkers","args":[39.9512667101695,-75.1645457186441,{"icon":"map-pin","markerColor":"darkblue","iconColor":"#FFFFFF","spin":false,"squareMarker":false,"iconRotate":0,"font":"monospace","prefix":"fa"},null,null,{"interactive":true,"draggable":false,"keyboard":true,"title":"","alt":"","zIndexOffset":0,"opacity":1,"riseOnHover":false,"riseOffset":250},"<h1 style='padding-top: 0.5em; margin-top: 1em; margin-bottom: 0.5em; font-family: Red Hat Text, sans-serif; font-size: 1.8em; color:#43464C;'> <a style='color: #00857A;' href='https://centercityphila.org/explore-center-city/ccdsips'> Center City District Sips 2022 <\/a><\/h1><p style='color:#9197A6; font-family: Red Hat Text, sans-serif; font-size: 1.5em; padding-bottom: 1em;'> Philadelphia, PA <\/p>",{"maxWidth":250,"minWidth":50,"autoPan":true,"keepInView":false,"closeButton":true,"className":""},null,null,"Center City District Sips 2022",{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"style":{"font-family":"Red Hat Text, sans-serif","font-size":"1.2em"},"className":"","sticky":true},null]}],"limits":{"lat":[39.9467935,39.9645357],"lng":[-75.1749899,-75.150981]},"setView":[[39.9512667101695,-75.1645457186441],16,[]]},"evals":[],"jsHooks":[]}</script>

## Creating the map with Quarto

The first time around, I created a standalone map by first running an R
script with the necessary code, and then exporting the HTML output as a
webpage. This worked well enough, except that I realized:

1.  The title of the map webpage (the name that is displayed on a
    browser tab) was just "map" because the name of the HTML file was
    `map.html`. I wanted something more descriptive.
2.  The map wasn't mobile-responsive. In other words, the map markers
    and text looked too small when viewed on a mobile device.

### Changing the webpage title

The webpage title was a quick one to fix thanks to a Stack Overflow
response to a [question about turning off the title in an R Markdown
document](https://stackoverflow.com/questions/59668347/rmarkdown-turn-off-title).
The `pagetitle` YAML option lets you set the HTML's title tag
independently of the document title:

``` yaml
pagetitle: "Philly CCD Sips 2022 Map"
```

### Fixing the mobile-responsiveness

The mobile-responsiveness issue could be solved by adding metadata to
the map HTML, but I would need to be able to blend HTML with R code. I
have been practicing using [Quarto](https://quarto.org/) and figured I
could make a standalone map from a Quarto document (`.qmd`) rather than
an R Markdown one (`.Rmd` or `.Rmarkdown`). You can find the map's
Quarto document [alongside this blog
post](https://github.com/spcanelon/silvia/blob/main/content/blog/2022-05-31-ccd-sips/map.qmd).

According to the [Leaflet library
documentation](https://leafletjs.com/examples/mobile/) and [this Stack
Overflow answer](https://stackoverflow.com/a/42796918), fixing the map
to be mobile-responsive required adding the following metadata to the
HTML code:

``` html
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
```

I used the [metathis](https://pkg.garrickadenbuie.com/metathis) R
package to add this metadata to an R code chunk in my Quarto document
using the `meta_viewport()` function:

``` r
# make mobile-responsive
meta_viewport(
  width = "device-width",
  initial_scale = "1.0",
  maximum_scale = "1.0",
  user_scalable = "no"
  )
```

> Update: In the process of updating this post I'm noticing that
> specifying the viewport metadata tag doesn't seem to be necessary
> anymore, and I don't understand why 🤔 ...so I'll leave the step as
> is, just in case it's helpful to anyone 🤷🏽‍♀️

### Adding social media tags

Then I added more metadata. I was particularly interested in adding
social media tags so that if I (or anyone else) shared this map webpage,
[an informative preview would display as a social
card](https://twitter.com/spcanelon/status/1531644079687229441).

I used the `meta_social()` function to add these tags:

``` r
# tags for social media
meta_social(
  title = "Philly CCD Sips 2022 Interactive Map",
  url = "https://www.silviacanelon.com/blog/2022-ccd-sips/map.html",
  image = "https://github.com/spcanelon/silvia/blob/main/content/blog/2022-05-31-ccd-sips/featured.png?raw=true",
  image_alt = "Map of Philly's Center City with a pop-up saying Center City District Sips 2022",
  og_type = "website",
  og_author = "Silvia Canelón",
  twitter_card_type = "summary_large_image",
  twitter_creator = "@spcanelon"
)
```

Great, I had added all of the metadata I was interested in! Except that
because I was using Quarto, and not one of the [more common
outputs](https://pkg.garrickadenbuie.com/metathis/index.html#works-in) I
had a couple of extra steps to take:

1.  Write my metadata tags to an HTML file, using the `write_meta()`
    function:

    ::: {.cell}

    ``` r
    # write meta tags to file
    write_meta(path = "meta-map.html")
    ```

    :::

2.  Manually include this HTML in my webpage via the Quarto file. The
    [`include-in-header`](https://quarto.org/docs/output-formats/html-basics.html#includes)
    Quarto YAML option helped me here:

    ``` yaml
    include-in-header: meta-map.html
    ```

### Making the map fullscreen

A side effect of creating the map from a Quarto (or R Markdown) document
is that the output is styled by default to fit within the width of an
article (in this case 900 pixels). I wanted the map to take up the whole
width of the page, so I made use of the
[`page-layout`](https://quarto.org/docs/interactive/layout.html#full-page-layout)
Quarto YAML option:

``` yaml
format: 
  html:
    page-layout: custom
```

Another option that worked pretty well was to use the `column: screen`
code chunk option built into Quarto. The Quarto documentation even shows
an [example to display a Leaflet
map](https://quarto.org/docs/authoring/article-layout.html#screen-column)
I but it left a thin margin at the top margin, and I wanted the map to
be flush against the top edge of the webpage.

### Rendering the standalone map

Lastly, I added one more option to the YAML that would render the Quarto
document into a [self-contained
HTML](https://quarto.org/docs/output-formats/html-publishing.html#standalone-html)
with all of the content needed to create the map.

``` yaml
format:
  html:
    page-layout: custom
    self-contained: true
```
