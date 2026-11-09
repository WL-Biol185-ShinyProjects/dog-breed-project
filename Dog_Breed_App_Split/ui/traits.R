      #DOG BREED WORLD MAP -----------------
      
      # Packages used for map 
      library(leaflet)
      library(dplyr)
      library(tidyr)
      library(readr)
      library(sf)
      library(rnaturalearth)
      # Packages for pawprint cursor
      library(htmlwidgets)
      library(htmltools)
      
      # Code for interactive dog breed world map 
      fci_breeds_clean <- read_csv("Data/fci_breeds_clean.csv")
      map_breed_images <- read_csv(
        "Data/breed_images.csv",
        show_col_types = FALSE
      )        
      
      breeds_by_country <- fci_breeds_clean %>%
        
      # attach Wikipedia photo links to each country's popup 
        
        left_join(map_breed_images, by = "breed") %>%                    
        separate_rows(country, sep = ",\\s*") %>%
        mutate(
          country = toupper(trimws(country)),
          country = recode(country,
                           "GREAT BRITAIN"       = "UNITED KINGDOM",
                           "THE NETHERLANDS"     = "NETHERLANDS",
                           "RUSSIAN FEDERATION"  = "RUSSIA",
                           "CZECHOSLOVAKIA"      = "CZECHIA",
                           "CENTRAL AFRICA"      = "CENTRAL AFRICAN REPUBLIC",
                           "TIBET (CHINA)"       = "CHINA",
                           "KOREA (REPUBLIC OF)" = "SOUTH KOREA"),
          
          # Show just one photo + name block per breed in the country popup 
          breed_html = paste0(
            "<div style='display:flex; align-items:center; margin:4px 0;'>",
            ifelse(is.na(image_url), "",
                   paste0("<img src='", image_url, "' width='60' height='60' loading='lazy' ",
                          "style='object-fit:cover; border-radius:6px; margin-right:8px;' ",
                          "onerror=\"this.style.display='none'\">")),
            "<span>", breed, "</span></div>")
        )                 %>%
        arrange(breed)    %>%                                           
        group_by(country) %>%
             summarise(n_breeds   = n_distinct(breed),
                       breed_list = paste(unique(breed_html), collapse = ""))   
      
      world <- ne_countries(scale = "medium", returnclass = "sf") %>%
                 mutate(join_name = toupper(admin))
      
      print(setdiff(breeds_by_country$country, world$join_name))
      
      world_breeds <- left_join(world, breeds_by_country, by = c("join_name" = "country"))
      
        # Map specifications 
      dog_map <- leaflet(world_breeds) %>%
        addTiles() %>%
        addPolygons(
          fillColor   = ~ifelse(is.na(breed_list), "grey", "orange"),
          fillOpacity = 0.5,
          weight      = 1,
          color       = "white",
          highlightOptions = highlightOptions(weight = 3, color = "#75462F",
                                              fillColor = "#E08E45", fillOpacity = 0.9,
                                              bringToFront = TRUE),
          label = ~ifelse(is.na(n_breeds),
                          paste0(name, ": no breeds recorded"),
                          paste0(name, ": ", n_breeds, ifelse(n_breeds == 1, " breed", " breeds"))),
          popup = ~paste0(
            "<b>", name, "</b><br>",
            "<div style='max-height:300px; overflow-y:auto; min-width:220px;'>",   
            ifelse(is.na(breed_list), "No data", breed_list),
            "</div>"),
          popupOptions = popupOptions(maxWidth = 320)                              
        )
      
      # code for cursor 
      paw_svg <- r"(<svg xmlns='http://www.w3.org/2000/svg' width='25' height='25' viewBox='0 0 32 32'><g fill='%2375462F' stroke='white' stroke-width='1'><ellipse cx='16' cy='21' rx='8' ry='6.5'/><circle cx='6' cy='13' r='3.2'/><circle cx='12' cy='7' r='3.4'/><circle cx='20' cy='7' r='3.4'/><circle cx='26' cy='13' r='3.2'/></g></svg>)"
      
      paw_css <- paste0(
        ".leaflet-container, .leaflet-grab, .leaflet-dragging .leaflet-grab, ",
        ".leaflet-interactive, .leaflet-marker-icon, .leaflet-control a {",
        "cursor: url(\"data:image/svg+xml;utf8,", paw_svg, "\") 12 12, auto !important;}"
      )
      
      dog_map <- dog_map %>% prependContent(tags$style(HTML(paw_css)))
      
      # TRAITS & TRENDS PAGE -------------------------
      
      tabItem(
        tabName = "traits",
        
        h1("Traits & Trends"),
        
        p("Explore dog breeds by country of origin."),
        
        dog_map
      )
      
      