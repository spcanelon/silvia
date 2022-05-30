
# Notes -------------------------------------------------------------------

# To save this map as a standalone HTML file:
# Run this script > Viewer > Export > Save as Webpage


# make map mobile-responsive ----------------------------------------------

# https://pkg.garrickadenbuie.com/metathis/reference/meta_viewport.html
metathis::meta_viewport(width = "device-width",
                        initial_scale = "1.0",
                        maximum_scale = "1.0",
                        user_scalable = "no")

## ----setup, include=FALSE-------------------------------------------
xfun::pkg_attach("tidyverse", "rvest", "RSelenium", "robotstxt", "here", "ggmap", "leaflet")


## ----import-map-data, echo=FALSE------------------------------------
# import data
specials <- read_rds(here("content/blog/2022-05-31-ccd-sips/specialsGeocoded.Rds"))


## ----create-map, echo=FALSE-----------------------------------------
# Create the pop-up information with inline css styling ----

# marker for the specials
popInfoCircles<-paste(
  "<h2 style='padding-bottom:4px; margin-bottom:4px;
    font-family: Red Hat Text, sans-serif;
    color:#43464C;'>", "<a style='color: #00857A' href=", specials$Specials, ">", specials$Name, "</a>",
  "<h3 style=font-family: Red Hat Text, sans-serif; font-weight: normal;
    color:#9197A6;'>", specials$Address, "</h3>")

# marker for the center of the map
popInfoMarker<-paste("<h1 style='padding-bottom:4px; margin-bottom:4px;
    font-family: Red Hat Text, sans-serif;
    color:#43464C;'>", "<a href='https://centercityphila.org/explore-center-city/ccdsips'>", 
    "Center City District Sips 2022", "</a></h1>
    <p style='color:#9197A6;'>", "Philadelphia, PA", "</p>")

awesome <-
  makeAwesomeIcon(
    icon = "map-pin",
    iconColor = "#FFFFFF",
    markerColor = "darkblue",
    library = "fa"
  )

# Creating the map
leaflet(data = specials) %>%
  # add map markers
  addCircles(lat = ~ specials$Latitude, 
             lng = ~ specials$Longitude, 
             fillColor = "#009E91", #olivedrab goldenrod
             fillOpacity = 0.6, 
             stroke = F,
             radius = 12, 
             popup = popInfoCircles,
             label = ~ Name) %>%
  # add map tiles in the background
  addProviderTiles(providers$CartoDB.Positron) %>%
  # set the map view
  setView(mean(specials$Longitude), 
          mean(specials$Latitude), 
          zoom=17) %>%
  # add default view marker
  # addMarkers(lng = mean(specials$Longitude), 
  #            lat = mean(specials$Latitude), 
  #            label = "Center City District Sips 2022",
  #            popup = popInfoMarker,
  #            popupOptions = popupOptions(maxWidth = 350)
#) %>% 
  addAwesomeMarkers(icon = awesome,
                    lng = mean(specials$Longitude), 
                    lat = mean(specials$Latitude), 
                    label = "Center City District Sips 2022",
                    popup = popInfoMarker,
                    popupOptions = popupOptions(maxWidth = 350))

