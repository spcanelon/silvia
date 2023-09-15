# Notes ---------------------------------------------------------

# To save this map as a standalone HTML file:
# Run this script > Viewer > Export > Save as Webpage

# meta ----------------------------------------------------------

library(metathis)

meta() |>
  # https://pkg.garrickadenbuie.com/metathis/reference/meta_viewport.html
  meta_viewport(width = "device-width",
                initial_scale = "1.0",
                maximum_scale = "1.0",
                user_scalable = "no") |>
  # tags for social media
  # https://pkg.garrickadenbuie.com/metathis/reference/meta_social.html
  meta_social(
    title = "Philly CCD Sips 2023 Interactive Map",
    url = "https://www.silviacanelon.com/blog/2023-ccd-sips/map.html",
    image = "https://github.com/spcanelon/silvia/blob/main/content/blog/2023-06-05-ccd-sips/featured.png?raw=true",
    image_alt = "Map of Philly's Center City with a pop-up saying Center City District Sips 2023",
    description = "An interactive map showing restaurants participating in Philadelphia's CCD Sips 2023",
    twitter_card_type = "summary_large_image",
    twitter_creator = "@spcanelon",
    og_type = "website",
    og_author = "Silvia Canelón"
  ) |>
  meta_general(generator = "quarto") |> 
  meta_name("github-repo" = "spcanelon/silvia") #|> 
  # https://pkg.garrickadenbuie.com/metathis/index.html
  # https://pkg.garrickadenbuie.com/metathis/reference/write_meta.html
  #write_meta(path = here::here("content", "blog", "2023-06-05-ccd-sips", "meta-map.html"))

# setup-map -----------------------------------------------------

xfun::pkg_attach("tidyverse", "here", "leaflet")

knitr::opts_chunk$set(echo = FALSE)

# import-data ---------------------------------------------------

specials <- read_rds(here("content/blog/2023-06-05-ccd-sips/specialsGeocoded.Rds"))

# marker for the specials
popInfoCircles<-paste("<h2 style='font-family: Red Hat Text, sans-serif; font-size: 1.6em; color:#E25D46;'>", "<a style='color: #E25D46;' href=", specials$Specials, ">", specials$Name, "</a></h2>", "<p style='font-family: Red Hat Text, sans-serif; font-weight: normal; font-size: 1.5em; color:#9197A6;'>", specials$Address, "</p>")

# leaflet-markers -----------------------------------------------

# marker for the center of the map
popInfoMarker<-paste("<h1 style='padding-top: 0.5em; margin-top: 1em; margin-bottom: 0.5em; font-family: Red Hat Text, sans-serif; font-size: 1.8em; color:#E25D46;'>", "<a style='color: #E25D46;' href='https://centercityphila.org/explore-center-city/ccdsips'>", "Center City District Sips 2023", "</a></h1><p style='color:#9197A6; font-family: Red Hat Text, sans-serif; font-size: 1.5em; padding-bottom: 1em;'>", "Philadelphia, PA", "</p>")

awesome <-
  makeAwesomeIcon(
    icon = "map-pin",
    iconColor = "#FFFFFF",
    markerColor = "darkblue",
    library = "fa"
  )

# leaflet-map ---------------------------------------------------

specials |>
  leaflet(width = "100%", 
          height = "850px",
          # https://stackoverflow.com/a/42170340
          options = tileOptions(minZoom = 15,
                                maxZoom = 19)) |>
  #add map markers
  addCircles(
    lat = ~ Latitude,
    lng = ~ Longitude,
    fillColor = "#E25D46", # "#E46651",
    fillOpacity = 0.6,
    stroke = F,
    radius = 12,
    popup = popInfoCircles,
    label = ~ Name,
    labelOptions = labelOptions(
      style = list(
        "font-family" = "Red Hat Text, sans-serif",
        "font-size" = "1.2em")
    )) |>
  #add map tiles in the background
  addProviderTiles(
    providers$CartoDB.Positron
  ) |>
  # set the map view
  setView(mean(specials$Longitude),
          mean(specials$Latitude),
          zoom = 16) |>
  addAwesomeMarkers(
    icon = awesome,
    lng = mean(specials$Longitude),
    lat = mean(specials$Latitude),
    label = "Center City District Sips 2023",
    labelOptions = labelOptions(
      style = list(
        "font-family" = "Red Hat Text, sans-serif",
        "font-size" = "1.2em")
    ),
    popup = popInfoMarker,
    popupOptions = popupOptions(maxWidth = 250)) |>
  # add fullscreen control button
  leaflet.extras::addFullscreenControl()
