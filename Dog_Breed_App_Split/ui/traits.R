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
#Packages for popularity slider 
library(ggplot2)
library(stringr)
      
      # Code for interactive dog breed world map 
      fci_breeds_clean <- read_csv("Data/fci_breeds_clean.csv")
      
      cat(
        "MAP DATASET ROWS:",
        nrow(fci_breeds_clean),
        "\n"
      )
      
      cat(
        "TOGO RECORDS:",
        sum(
          toupper(trimws(fci_breeds_clean$country)) == "TOGO",
          na.rm = TRUE
        ),
        "\n"
      )
      
      
      map_breed_images <- read_csv(
        "Data/breed_images.csv",
        show_col_types = FALSE
      )

      # EDITABLE DESCRIPTIONS: change the second column in this CSV whenever needed.
      # The map still opens if the description CSV has not been added yet.
      if (file.exists("Data/breed_descriptions.csv")) {
        breed_descriptions <- read_csv(
          "Data/breed_descriptions.csv",
          show_col_types = FALSE
        ) %>%
          select(breed, description) %>%
          distinct(breed, .keep_all = TRUE)
      } else {
        breed_descriptions <- tibble::tibble(
          breed = character(), description = character()
        )
      }
      
      breeds_by_country <- fci_breeds_clean %>%
        
      # attach Wikipedia photo links to each country's popup 
        
        left_join(map_breed_images, by = "breed") %>%
        left_join(breed_descriptions, by = "breed") %>%
        separate_rows(country, sep = ",\\s*") %>%
        mutate(
          country = toupper(trimws(country)),
          country = recode(country,
                           "GREAT BRITAIN"       = "UNITED KINGDOM",
                           "ENGLAND"             = "UNITED KINGDOM",
                           "THE NETHERLANDS"     = "NETHERLANDS",
                           "RUSSIAN FEDERATION"  = "RUSSIA",
                           "CZECHOSLOVAKIA"      = "CZECHIA",
                           "CZECH REPUBLIC"      = "CZECHIA",
                           "CENTRAL AFRICA"      = "CENTRAL AFRICAN REPUBLIC",
                           "TIBET (CHINA)"       = "CHINA",
                           "KOREA (REPUBLIC OF)" = "SOUTH KOREA"),
          
          # One photo, breed name, and EDITABLE description per breed.
          image_url = dplyr::coalesce(image_url, ""),
          description = dplyr::coalesce(description, ""),
          description = ifelse(
            trimws(description) == "",
            "Description coming soon.",
            description
          ),
          breed_html = paste0(
            "<div style='display:flex;align-items:flex-start;gap:10px;",
            "padding:9px 0;border-bottom:1px solid #e8e8e8;'>",
            ifelse(trimws(image_url) == "", "", paste0(
              "<img src='", htmltools::htmlEscape(image_url, attribute = TRUE),
              "' width='72' height='72' loading='lazy' ",
              "style='width:72px;height:72px;object-fit:cover;",
              "border-radius:8px;flex-shrink:0;' ",
              "onerror=\"this.style.display='none'\">"
            )),
            "<div style='min-width:0;'>",
            "<div style='font-size:13px;font-weight:700;margin-bottom:3px;'>",
            htmltools::htmlEscape(breed), "</div>",
            "<div style='font-size:12px;color:#4b5563;line-height:1.5;",
            "overflow-wrap:break-word;'>",
            htmltools::htmlEscape(description), "</div>",
            "</div></div>"
          )
        )                 %>%
        arrange(breed)    %>%                                           
        group_by(country) %>%
             summarise(n_breeds   = n_distinct(breed),
                       breed_list = paste(unique(breed_html), collapse = ""))   
      
      world <- ne_countries(scale = "medium", returnclass = "sf") %>%
                 mutate(join_name = toupper(admin))
      
      print(setdiff(breeds_by_country$country, world$join_name))
      
      world_breeds <- left_join(world, breeds_by_country, by = c("join_name" = "country"))
      
      # CHECK TOGO IN THE ACTUAL MAP DATA
      cat("\n--- TOGO MAP DIAGNOSTIC ---\n")
      
      print(
        world_breeds |>
          sf::st_drop_geometry() |>
          dplyr::filter(toupper(trimws(admin)) == "TOGO") |>
          dplyr::select(admin, join_name, n_breeds, breed_list)
      )
      
      # color code by continent
      continent_cols <- c(
        "Africa"        = "#E41A1C",  # red
        "Europe"        = "#7B3294",  # purple
        "Asia"          = "#FF7F00",  # orange
        "North America" = "#1F78B4",  # blue
        "South America" = "#33A02C",  # green
        "Oceania"       = "#17BECF"   # teal
      )
      
      continent_pal <- colorFactor(
        palette = unname(continent_cols),
        levels  = names(continent_cols)
      )
        # Map specifications 
      dog_map <- leaflet(world_breeds) %>%
        addTiles() %>%
        addPolygons(
          fillColor   = ~ifelse(is.na(breed_list), "grey", continent_pal(continent)),
          fillOpacity = 0.6,
          weight      = 1,
          color       = "white",
          highlightOptions = highlightOptions(weight = 3, color = "#75462F",
                                              fillOpacity = 0.9,
                                              bringToFront = TRUE),
          label = ~ifelse(is.na(n_breeds),
                          paste0(name, ": no breeds recorded"),
                          paste0(name, ": ", n_breeds, ifelse(n_breeds == 1, " breed", " breeds"))),
          popup = ~paste0(
            "<b>", name, "</b><br>",
            "<div style='max-height:340px; overflow-y:auto; min-width:250px; padding-right:4px;'>",   
            ifelse(is.na(breed_list), "No data", breed_list),
            "</div>"),
          popupOptions = popupOptions(maxWidth = 400)                              
        )
      
      # MAP KEY: uses the same continent_cols and opacity as addPolygons.
      # Colors represent the CONTINENT of countries with recorded breeds,
      # not a different breed category. Gray means no breeds recorded.
      legend_entries <- paste0(
        "<div style='display:flex;align-items:center;gap:6px;white-space:nowrap;'>",
        "<span style='display:inline-block;flex:0 0 12px;width:12px;height:12px;",
        "background:", unname(continent_cols), ";opacity:0.6;",
        "border:1px solid rgba(0,0,0,.15);border-radius:3px;'></span>",
        "<span>", names(continent_cols), "</span></div>"
      )
      map_key_html <- paste0(
        "<div style='background:rgba(255,255,255,.97);color:#202124;",
        "border:1px solid #d1d5db;border-radius:10px;padding:10px 12px;",
        "box-shadow:0 3px 12px rgba(0,0,0,.18);",
        "font-family:Arial,Helvetica,sans-serif;font-size:12px;line-height:1.35;",
        "max-width:230px;'>",
        "<div style='font-weight:700;font-size:14px;margin-bottom:3px;'>Map Key</div>",
        "<div style='font-size:11px;color:#52525b;margin-bottom:8px;'>",
        "Colored countries have recorded native breeds. Color indicates continent.",
        "</div>",
        "<div style='display:grid;grid-template-columns:1fr 1fr;",
        "column-gap:10px;row-gap:6px;'>",
        paste(legend_entries, collapse = ""),
        "</div>",
        "<div style='border-top:1px solid #e5e7eb;margin-top:8px;",
        "padding-top:7px;display:flex;align-items:center;gap:6px;'>",
        "<span style='display:inline-block;width:12px;height:12px;",
        "background:grey;opacity:0.6;border:1px solid rgba(0,0,0,.15);",
        "border-radius:3px;'></span>",
        "<span>No breeds recorded</span></div></div>"
      )
      dog_map <- dog_map %>%
        addControl(
          html = htmltools::HTML(map_key_html),
          position = "bottomleft",
          className = "dog-breed-map-key"
        )
      
      dog_map <- dog_map %>% prependContent()
      
      # BREED RANK FEATURE
      # this should be a slider feature showing the top 10 most popular dog breeds each year - x axis shows year, y axis shows breed rank
      breed_rank_raw <- read_csv("Data/breed_rank_all.csv",
                                 na = c("", "NA"), show_col_types = FALSE)
      breed_top10 <- breed_rank_raw %>%
        select(Breed, ends_with("Rank")) %>%
        pivot_longer(-Breed, names_to = "year", values_to = "rank") %>%
        mutate(year = parse_number(year), Breed = breed_rank_all(Breed)) %>%
        filter(!is.na(rank), rank <= 10) %>%
        arrange(Breed, year) %>%
        group_by(Breed) %>%
        # start a new line segment if a breed leaves the top 10 and comes back
        mutate(run = cumsum(year - lag(year, default = first(year)) > 1)) %>%
        ungroup() %>%
        mutate(grp = paste(Breed, run))
      
      breed_years <- sort(unique(breed_top10$year))
      
      # one fixed color per breed so colors don't change as the slider moves
      breed_pal <- setNames(scales::hue_pal()(n_distinct(breed_top10$Breed)),
                            unique(breed_top10$Breed))
      
      output$breed_plot <- renderPlot({
        d <- filter(breed_top10, year <= input$breed_year)
        
        ggplot(d, aes(x = year, y = rank)) +
          geom_path(aes(group = grp, colour = Breed), linewidth = 1.2, alpha = 0.5) +
          geom_point(aes(fill = Breed), shape = 21, size = 23,
                     colour = "white", stroke = 1) +
          geom_text(aes(label = str_wrap(Breed, 9)),
                    colour = "white", size = 2.4, fontface = "bold",
                    lineheight = 0.85, family = "sans") +
          scale_x_continuous(breaks = breed_years,
                             limits = c(min(breed_years) - 0.5, max(breed_years) + 0.5)) +
          scale_y_reverse(breaks = 1:10, limits = c(10.5, 0.5)) +   # rank 1 at the top
          scale_colour_manual(values = breed_pal) +
          scale_fill_manual(values = breed_pal) +
          guides(colour = "none", fill = "none") +
          labs(x = "Year", y = "Dog Breed Popularity Rank") +
          theme_minimal(base_size = 14) +
          theme(panel.grid.minor = element_blank())
      })
      
      # TRAITS & TRENDS PAGE -------------------------
      
      tabItem(
        tabName = "traits",
        
        h1("Traits & Trends"),
        
        p("Explore dog breeds by country of origin. Colored countries have recorded breeds; their colors indicate continent (see the map key). Hover over a country to see its breed count, then click to view the breed names, photos, and descriptions."),
        
        dog_map, 
        p(em("Data reflects breeds officially recognized by the Fédération Cynologique Internationale"))
      )
      
      h2("Top 10 Most Popular Dog Breeds Over Time"),
      
      p("Use the slider to navigate between years and see how the top 10 most popular dog breeds have shifted over time!"),
      sliderInput(
        "breed_year", "Year",
        min = min(breed_years), max = max(breed_years), value = min(breed_years),
        step = 1, sep = "", width = "100%",
        animate = animationOptions(interval = 900)   # adds a play button
      ),
      plotOutput("breed_plot", height = "800px")
      )

      
      
      