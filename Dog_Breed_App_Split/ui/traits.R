      tabItem(
        tabName = "traits",
        
        h1("Traits & Trends"),
        p("Interactive data visualizations will go here.")
      )

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
      breed_images     <- read_csv("Data/breed_images.csv")         
      
      breeds_by_country <- fci_breeds_clean %>%
        
      # attach Wikipedia photo links to each country's popup 
        
        left_join(breed_images, by = "breed") %>%                    
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
      
      dog_map
      
      # Code to search Wikipedia for dog breed images for map popups
      
      # Packages for search
      library(readr)
      library(dplyr)
      library(httr2)
      library(stringr)
      
      # Search code
      ua <- "DogBreedMap/1.0 (student class project; lhertzler@mail.wlu.edu)"
      
      `%||%` <- function(a, b) if (is.null(a)) b else a
      
      wiki <- function(...) {
        request("https://en.wikipedia.org/w/api.php") |>
          req_user_agent(ua) |>
          req_url_query(..., format = "json", formatversion = 2) |>
          req_throttle(rate = 0.5) |>                       # at most 1 request / 2 seconds
          req_retry(max_tries = 6,
                    is_transient = function(r) resp_status(r) %in% c(429, 503),
                    backoff = function(i) 10 * i) |>
          req_perform() |>
          resp_body_json()
      }
      
      dog_regex <- "\\bdogs?\\b|hounds?\\b|terrier|spaniel|sheepdog|mastiff|spitz|poodle"
      
      # Turn a dog breed names into possible Wikipedia titles
      clean_names <- function(b) {
        x <- tools::toTitleCase(tolower(b))
        x <- str_replace_all(x, "-\\s+", "-")               # "Wire- Haired" -> "Wire-Haired"
        x <- str_replace_all(x, "\\bSt\\.", "Saint")
        x <- str_replace_all(x, "\\s*&\\s*", " and ")
        inside <- str_match_all(x, "\\(([^)]+)\\)")[[1]][, 2]
        no_par <- str_trim(str_remove_all(x, "\\([^)]*\\)"))
        parts  <- c(no_par, str_split(no_par, "\\s+-\\s+|,\\s*")[[1]], inside)
        unique(parts[nzchar(parts)])
      }
      
      # Dog-specific titles FIRST, plain name last
      # (so "Shikoku (dog)" is tried before "Shikoku", which is an island)
      make_candidates <- function(b) {
        nm <- clean_names(b)
        head(unique(c(paste(nm, "(dog)"), paste(nm, "(dog breed)"),
                      paste(nm, "dog"), nm)), 20)
      }
      
      # Accept a page only if it has a photo, isn't a disambiguation page,
      # and its intro text is about a dog
      valid_page <- function(p) {
        !isTRUE(p$missing) &&
          !is.null(p$thumbnail$source) &&
          is.null(p$pageprops$disambiguation) &&
          !is.null(p$extract) && grepl(dog_regex, p$extract, ignore.case = TRUE)
      }
      
      props <- list(prop = "pageimages|extracts|pageprops", ppprop = "disambiguation",
                    pithumbsize = 200, exintro = 1, explaintext = 1,
                    exchars = 400, exlimit = "max")
      
      find_img <- function(b) {
        tryCatch({
          cands <- make_candidates(b)
          
          # 1) try the title variants in one request
          resp <- do.call(wiki, c(list(action = "query", titles = paste(cands, collapse = "|"),
                                       redirects = 1), props))
          q <- resp$query
          final_title <- function(t) {
            for (m in list(q$normalized, q$redirects))
              for (x in m) if (identical(x$from, t)) t <- x$to
            t
          }
          page_titles <- vapply(q$pages, function(p) p$title, character(1))
          for (cand in cands) {
            idx <- match(final_title(cand), page_titles)
            if (is.na(idx)) next
            p <- q$pages[[idx]]
            if (valid_page(p)) return(p$thumbnail$source)
          }
          
          # 2) fall back to a search, with the same dog check
          resp <- do.call(wiki, c(list(action = "query", generator = "search",
                                       gsrsearch = paste(clean_names(b)[1], "dog breed"),
                                       gsrlimit = 5), props))
          pages <- resp$query$pages
          if (!is.null(pages)) {
            pages <- pages[order(vapply(pages, function(p) p$index %||% 99, numeric(1)))]
            for (p in pages) if (valid_page(p)) return(p$thumbnail$source)
          }
          NA_character_
        }, error = function(e) {
          message("Failed for ", b, ": ", conditionMessage(e))
          NA_character_
        })
      }
      
      
      # run the photo search
      
      fci_breeds_clean <- read_csv("Data/fci_breeds_clean.csv")
      breeds <- unique(fci_breeds_clean$breed)
      
      urls <- character(length(breeds))
      for (i in seq_along(breeds)) {
        urls[i] <- find_img(breeds[i])
        if (i %% 25 == 0) message(i, " of ", length(breeds), " done")
      }
      
      breed_images <- tibble(breed = breeds, image_url = urls)
      
      
      # manual photo fixes
      # Paste in photo links for breeds that Wikipedia search still gets wrong/doesn't have a photo for
      
      manual_fixes <- c(
        "POSAVATZ HOUND" = "https://thumb.wikimedia.org/wikipedia/commons/thumb/b/b9/Posavski_goni%C4%8D_Bonko_07.jpg/120px-Posavski_goni%C4%8D_Bonko_07.jpg",
        "SAARLOOS WOLFHOND" = "https://thumb.wikimedia.org/wikipedia/commons/thumb/5/5c/Saarlooswolfhond_Kajhin.jpg/120px-Saarlooswolfhond_Kajhin.jpg",
        "BOSNIAN BROKEN-HAIRED HOUND - CALLED BARAK" = "https://thumb.wikimedia.org/wikipedia/commons/thumb/9/9e/BIR_Grupp_6-_BOSANSKI_OSTRODLAKI_GONIC-BARAK%2C_Sandy_%2823866392689%29.jpg/120px-BIR_Grupp_6-_BOSANSKI_OSTRODLAKI_GONIC-BARAK%2C_Sandy_%2823866392689%29.jpg",
        "BOSNIAN AND HERZEGOVINIAN - CROATIAN SHEPHERD DOG" = "https://thumb.wikimedia.org/wikipedia/commons/thumb/7/78/Gera062005sed.jpg/120px-Gera062005sed.jpg"
      )
      
      # Clean the links: drop the ?utm tail, use upload.wikimedia.org, use 250px thumbnails
      manual_fixes <- sub("\\?.*$", "", manual_fixes)
      manual_fixes <- sub("thumb.wikimedia.org", "upload.wikimedia.org", manual_fixes, fixed = TRUE)
      manual_fixes <- sub("/120px-", "/250px-", manual_fixes, fixed = TRUE)
      
      # Show any names that don't match the CSV (fix their spelling above)
      setdiff(names(manual_fixes), breed_images$breed)
      
      # Apply the ones that DO match, then save
      ok <- names(manual_fixes) %in% breed_images$breed
      breed_images$image_url[match(names(manual_fixes)[ok], breed_images$breed)] <- unname(manual_fixes[ok])
      
      readr::write_csv(breed_images, "Data/breed_images.csv")
      
      sum(!is.na(breed_images$image_url))                 # breeds with a photo
      breed_images$breed[is.na(breed_images$image_url)]   # breeds still missing
      