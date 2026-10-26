library(leaflet)
library(dplyr)
library(tidyr)
library(readr)
library(sf)
library(rnaturalearth)

# 1. Load the data
fci_breeds_clean <- read_csv("Data/fci_breeds_clean.csv")

# 2. Clean the country names
breeds_by_country <- fci_breeds_clean %>%
  separate_rows(country, sep = ",\\s*") %>%        # split "BELGIUM, FRANCE" into two rows
  mutate(country = toupper(trimws(country)),        # make everything upper case
         country = recode(country,
                          "GREAT BRITAIN" = "UNITED KINGDOM",
                          "HOLLAND" = "NETHERLANDS")) %>%
  group_by(country) %>%
  summarise(breed_list = paste(sort(unique(breed)), collapse = "<br>"))

# 3. Get country shapes, make their names upper case too, and join
world <- ne_countries(scale = "medium", returnclass = "sf") %>%
  mutate(join_name = toupper(admin))

world_breeds <- left_join(world, breeds_by_country, by = c("join_name" = "country"))

# 4. Build the map
dog_map <- leaflet(world_breeds) %>%
  addTiles() %>%
  addPolygons(
    fillColor = ~ifelse(is.na(breed_list), "grey", "orange"),
    fillOpacity = 0.5,
    weight = 1,
    color = "white",
    popup = ~paste0("<b>", name, "</b><br>",
                    ifelse(is.na(breed_list), "No data", breed_list))
  )

dog_map
