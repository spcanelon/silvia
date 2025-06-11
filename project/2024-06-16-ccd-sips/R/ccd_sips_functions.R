

# Webscraping ---------------------------------------------------

#' Scraping specials from tables posted on the Center City District Sips website
#'
#' @param page_number Pagination number for tables.
#'
#' @return Table with information about CCD Sips specials.
#' 
get_tables <- function(url, page_number) {
  Sys.sleep(2)
  
  url <- paste0(url, "?page=", page_number)
  
  html <- read_html(url)
  
  table <- 
    html |> 
    html_node("table") |>
    html_table()
  
  links <- 
    html |> 
    html_elements(".o-table__tag.ccd-text-link") |> 
    html_attr("href") |> 
    as_tibble()
  
  tableSpecials <<-
    bind_cols(table, links) |> 
    mutate(Specials = paste0(url, value)) |> 
    select(-c(`CCD SIPS Specials`, value))
}

# Metadata ------------------------------------------------------

#' Metadata for a specific CCD Sips year and blog post
#'
#' @param year Year of Center City District Sips
#' @param slug Blog post slug (enclosing folder)
#'
#' @return HTML file containing metadata for the map.
#'
create_metadata <- function(year, slug) {
  
  metathis::meta() |>
    # https://pkg.garrickadenbuie.com/metathis/reference/meta_viewport.html
    metathis::meta_viewport(width = "device-width",
                            initial_scale = "1.0",
                            maximum_scale = "1.0",
                            user_scalable = "no") |>
    # tags for social media
    # https://pkg.garrickadenbuie.com/metathis/reference/meta_social.html
    metathis::meta_social(
      title = paste0("Philly CCD SIPS ", year, " Interactive Map"),
      url = paste0("https://www.silviacanelon.com/project/", slug, paste0("/_", year), "/map.html"),
      image = paste0("https://github.com/spcanelon/silvia/blob/main/content/project/", slug, "/_", year, "/featured.png?raw=true"),
      image_alt = paste("Map of Philly's Center City with a pop-up saying Center City District SIPS", year),
      description = paste("An interactive map showing restaurants participating in Philadelphia's CCD SIPS", year),
      twitter_card_type = "summary_large_image",
      twitter_creator = "@spcanelon",
      og_type = "website",
      og_author = "Silvia Canelón"
    ) |>
    metathis::meta_general(generator = "quarto") |> 
    metathis::meta_name("github-repo" = "spcanelon/silvia") |> 
    # https://pkg.garrickadenbuie.com/metathis/index.html
    # https://pkg.garrickadenbuie.com/metathis/reference/write_meta.html
    metathis::write_meta(path = here::here("project", slug, paste0("_", year), "meta-map.html"))
  
}


# Leaflet pop-ups -----------------------------------------------

#' Address pop-ups
#'
#' @param link_color Hyperlink text color
#' @param text_color Text color
#' @param special_number Numeric vector of specials (e.g. 1:nrow(specials))
#'
#' @return HTML code for leaflet address popups.
#'
create_address_popups <- 
  function(link_color, text_color, special_number) {
    
    htmltools::tagList(
      # heading
      htmltools::h2(
        style = htmltools::css(
          font_family = "Red Hat Text, sans-serif",
          font_size = "1.6em",
          #color = "#5389f7"
        ),
        htmltools::a(specials$Name[special_number],
                     style = htmltools::css(color = link_color),
                     href = specials$Specials[special_number]),
      ),
      
      # paragraph text under heading
      htmltools::p(
        specials$Address[special_number],
        style = htmltools::css(font_family = "Red Hat Text, sans-serif",
                               font_weight = "normal",
                               font_size = "1.5em",
                               color = text_color)
      ),
      
    ) |> 
      # converts list item to character for use in Leaflet argument
      as.character()
    
  }

#' Center icon pop-up
#'
#' @param link_color Hyperlink text color
#' @param text_color Text color
#' @param year Year of CCD Sips
#'
#' @return HTML code for leaflet address popups.
#'
create_center_popup <- 
  function(year, link_color, text_color) {
    
    htmltools::tagList(
      # heading
      htmltools::h1(
        style = htmltools::css(
          font_family = "Red Hat Text, sans-serif",
          font_size = "1.8em",
          #color = "#5389f7"
          padding_top = "0.5em"
        ),
        # link details
        htmltools::a(paste("Center City District SIPS", year),
                     style = htmltools::css(color = link_color),
                     href = "https://centercityphila.org/explore-center-city/ccdsips"), #specials$Specials),
      ),
      
      # paragraph text under heading
      htmltools::p("Philadelphia, PA",
                   style = htmltools::css(font_family = "Red Hat Text, sans-serif",
                                          font_weight = "normal",
                                          font_size = "1.5em",
                                          color = text_color,
                                          padding_bottom = "1em")
      )
    ) |> 
      # converts list item to character for use in Leaflet argument
      as.character()
    
    # # marker icon
    # awesome <-
    #   awesomeIcons(
    #     icon = "map-pin",
    #     library = "fa",
    #     iconColor = "#FFFFFF",
    #     markerColor = marker_color
    #   )
  } 


# Leaflet map ---------------------------------------------------

#' Leaflet map of CCD SIPS specials
#'
#' @param df_specials Dataframe with specials
#' @param year Year of CCD Sips event
#' @param address_marker_labels Labels for address marker popups
#' @param address_marker_fill_color Fill color for address markers
#' @param address_marker_color Stroke color for address markers
#' @param center_marker_label Label for center marker popup hover
#'
#' @return Leaflet map of Center City District Sips specials.
#' 
create_leaflet_map <- function(year, df_specials, address_marker_labels, center_marker_label, address_marker_fill_color, address_marker_color, max_popup_width = NULL) {
  
  palette <- viridisLite::viridis(2, begin = 0.6, end = 1, direction = -1)
  # my_palette <- colorFactor(palette, specials_w_inspection$foodborne_cat,
  #                           na.color = "lightgray")
  my_palette <- colorFactor(c("#912b60", "#7AD151"),
                            specials_w_inspection$foodborne_cat,
                            na.color = "lightgray")
  
  df_specials |>
    leaflet::leaflet(
      width = "100%", 
      height = "850px",
      # https://stackoverflow.com/a/42170340
      options = leaflet::tileOptions(minZoom = 15,
                                     maxZoom = 19)) |>
    # add map markers for specials
    leaflet::addCircles(
      group = "Specials only",
      lat = ~ latitude,
      lng = ~ longitude,
      fillColor = address_marker_fill_color,
      # fillColor = c("#7AD151FF", "#912b60", "lightgray"),
      fillOpacity = 1,
      stroke = TRUE,
      color = address_marker_color,
      weight = 3,
      opacity = 1,
      radius = 12,
      popup = address_marker_labels,
      label = ~ name,
      labelOptions = leaflet::labelOptions(
        style = list(
          "font-family" = "Red Hat Text, sans-serif",
          "font-size" = "1.2em")
      )
    ) |>
    # add map markers for foodborne illness violations ----
  leaflet::addCircles(
    group = "Foodborne illness risk factors",
    lat = ~ latitude,
    lng = ~ longitude,
    fillColor = ~my_palette(foodborne_cat),
    fillOpacity = 1,
    stroke = TRUE,
    color = address_marker_color,
    weight = 3,
    opacity = 1,
    radius = 12,
    popup = address_marker_labels,
    label = ~ name,
    labelOptions = leaflet::labelOptions(
      style = list(
        "font-family" = "Red Hat Text, sans-serif",
        "font-size" = "1.2em")
    )
  ) |>
    # add map markers for retail practice violations ----
  leaflet::addCircles(
    group = "Lack of good retail practices",
    lat = ~ latitude,
    lng = ~ longitude,
    fillColor = ~my_palette(retail_cat),
    # fillColor = c("#7AD151FF", "#912b60", "lightgray"),
    fillOpacity = 1,
    stroke = TRUE,
    color = address_marker_color,
    weight = 3,
    opacity = 1,
    radius = 12,
    popup = address_marker_labels,
    label = ~ name,
    labelOptions = leaflet::labelOptions(
      style = list(
        "font-family" = "Red Hat Text, sans-serif",
        "font-size" = "1.2em")
    )
  ) |>
    # add layers control
    addLayersControl(
      overlayGroups = c("Specials only", 
                        "Foodborne illness risk factor",
                        "Lack of good retail practices"),
      options = layersControlOptions(collapsed = FALSE,
                                     position = "topright")
    ) |>
    # set default layers view
    hideGroup(c("Specials only", "Lack of good retail practices")) |>
    # add legend
    addLegend(
      # position = "bottomright", 
      pal = my_palette, 
      values = ~foodborne_cat,
      # group = "Foodborne illness violations",
      title = "Recent food safety<br>inspection violations",
      # labFormat = labelFormat(c("factor")),
      opacity = 1,
      na.label = "Report not found"
    ) |> 
    # add map tiles in the background
    addProviderTiles(
      providers$CartoDB.Positron,
      # add attribution
      options = list(attribution = "Created by <a href='https://silviacanelon.com'>Silvia Canelón</a> | &copy; <a href='https://www.openstreetmap.org/copyright'>OpenStreetMap</a> contributors")
    ) |>
    # use centroid as map view
    leaflet::setView(mean(df_specials$longitude),
                     mean(df_specials$latitude),
                     zoom = 16) |>
    # add center icon
    leaflet::addAwesomeMarkers(
      icon = popup_center_marker_icon,
      lng = mean(df_specials$longitude),
      lat = mean(df_specials$latitude),
      label = paste("Center City District SIPS", year),
      labelOptions = leaflet::labelOptions(
        style = list(
          "font-family" = "Red Hat Text, sans-serif",
          "font-size" = "1.2em")
      ),
      popup = center_marker_label,
      popupOptions = leaflet::popupOptions(maxWidth = max_popup_width)) |>
    # add fullscreen control button
    leaflet.extras::addFullscreenControl()
  
}


# Searchable table ----------------------------------------------

# <a href="https://github.com/rstudio/DT/issues">Github issues</a>

#' Searchable table for happy hour specials
#'
#' @param df Dataframe with CCD SIPS specials 
#'
#' @return Searchable HTML table with links to specials
#'
create_table <- function(df, page_length = 10) {
  
  df |> 
    # create HTML link variable
    dplyr::mutate(link = glue::glue("<a href='{Specials}'>{Name}</a>")) |>
    # select variables to display in table
    dplyr::select(link, Address) |>
    DT::datatable(
      # number of items to include per page
      options = list(pageLength = page_length),
      # remove row names/numbers
      rownames = FALSE,
      # label columns
      colnames = c('Business', 'Address'),
      # allow text to be interpreted as HTML
      escape = FALSE)
  
}
