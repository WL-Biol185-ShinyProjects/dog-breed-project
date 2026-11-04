library(leaflet)
library(dplyr)
library(tidyr)
library(readr)
library(sf)
library(rnaturalearth)
library(htmlwidgets)
library(htmltools)

# MAP CODE -------------------------
fci_breeds_clean <- read_csv("Data/fci_breeds_clean.csv")
breed_images     <- read_csv("Data/breed_images.csv")          # NEW

breeds_by_country <- fci_breeds_clean %>%
  left_join(breed_images, by = "breed") %>%                    # NEW: attach photo links
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
    
    # NEW: one photo + name block per breed
    breed_html = paste0(
      "<div style='display:flex; align-items:center; margin:4px 0;'>",
      ifelse(is.na(image_url), "",
             paste0("<img src='", image_url, "' width='60' height='60' loading='lazy' ",
                    "style='object-fit:cover; border-radius:6px; margin-right:8px;' ",
                    "onerror=\"this.style.display='none'\">")),
      "<span>", breed, "</span></div>")
  ) %>%
  arrange(breed) %>%                                           # NEW: A to Z
  group_by(country) %>%
  summarise(n_breeds   = n_distinct(breed),
            breed_list = paste(unique(breed_html), collapse = ""))   # NEW

world <- ne_countries(scale = "medium", returnclass = "sf") %>%
  mutate(join_name = toupper(admin))

print(setdiff(breeds_by_country$country, world$join_name))

world_breeds <- left_join(world, breeds_by_country, by = c("join_name" = "country"))

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
      "<div style='max-height:300px; overflow-y:auto; min-width:220px;'>",   # NEW
      ifelse(is.na(breed_list), "No data", breed_list),
      "</div>"),
    popupOptions = popupOptions(maxWidth = 320)                              # NEW
  )

paw_svg <- r"(<svg xmlns='http://www.w3.org/2000/svg' width='25' height='25' viewBox='0 0 32 32'><g fill='%2375462F' stroke='white' stroke-width='1'><ellipse cx='16' cy='21' rx='8' ry='6.5'/><circle cx='6' cy='13' r='3.2'/><circle cx='12' cy='7' r='3.4'/><circle cx='20' cy='7' r='3.4'/><circle cx='26' cy='13' r='3.2'/></g></svg>)"

paw_css <- paste0(
  ".leaflet-container, .leaflet-grab, .leaflet-dragging .leaflet-grab, ",
  ".leaflet-interactive, .leaflet-marker-icon, .leaflet-control a {",
  "cursor: url(\"data:image/svg+xml;utf8,", paw_svg, "\") 12 12, auto !important;}"
)

dog_map <- dog_map %>% prependContent(tags$style(HTML(paw_css)))

dog_map

# CODE TO SEARCH WIKIPEDIA FOR IMAGES
library(readr)
library(dplyr)
library(httr2)

fci_breeds_clean <- read_csv("Data/fci_breeds_clean.csv")

breeds <- unique(fci_breeds_clean$breed)
titles <- tools::toTitleCase(tolower(breeds))   # "BORDER TERRIER" -> "Border Terrier"

ua <- "DogBreedMap/1.0 (student class project; lhertzler@mail.wlu.edu)"

# Looks up up to 40 titles in ONE request
wiki_batch <- function(tt) {
  resp <- request("https://en.wikipedia.org/w/api.php") |>
    req_user_agent(ua) |>
    req_url_query(action = "query", titles = paste(tt, collapse = "|"),
                  prop = "pageimages", format = "json",
                  pithumbsize = 200, pilimit = 50, redirects = 1) |>
    req_retry(max_tries = 6,
              is_transient = function(r) resp_status(r) %in% c(429, 503),
              backoff = function(i) 10 * i) |>     # waits 10s, 20s, 30s...
    req_perform() |>
    resp_body_json()
  
  q <- resp$query
  
  # page title -> thumbnail link
  thumbs <- vapply(q$pages, function(p)
    if (is.null(p$thumbnail$source)) NA_character_ else p$thumbnail$source,
    character(1))
  names(thumbs) <- vapply(q$pages, function(p) p$title, character(1))
  
  # follow Wikipedia's renaming/redirects back to the page title
  follow <- function(t) {
    for (m in list(q$normalized, q$redirects))
      for (x in m) if (x$from == t) t <- x$to
    t
  }
  
  out <- vapply(tt, function(t) {
    k <- follow(t)
    if (k %in% names(thumbs)) thumbs[[k]] else NA_character_
  }, character(1))
  unname(out)
}

# Split into groups of 40 and pause between groups
groups <- split(titles, ceiling(seq_along(titles) / 40))
urls <- character(0)
for (g in groups) {
  urls <- c(urls, wiki_batch(g))
  Sys.sleep(3)
}

breed_images <- tibble(breed = breeds, image_url = urls)
write_csv(breed_images, "Data/breed_images.csv")

sum(!is.na(breed_images$image_url))                  # breeds that got a photo
breed_images$breed[is.na(breed_images$image_url)]    # breeds with no photo