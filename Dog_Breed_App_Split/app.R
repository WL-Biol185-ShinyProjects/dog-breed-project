# ================================================================
# DOG MATCHING SHINY APP
# ================================================================


# PACKAGES --------------------------------------------------------

library(shiny)

library(tidyverse)

library(readxl)

library(bslib)

library(shinydashboard)

library(plotly)

#Make pictures show in our about section
shiny::addResourcePath(
  prefix = "authors",
  directoryPath = normalizePath("ui/www")
)

# Make our custom CSS file accessible to Shiny.
shiny::addResourcePath(
  prefix = "styles",
  directoryPath = normalizePath("ui/www")
)


source("R/data_setup.R", local = TRUE)

# USER INTERFACE (UI) ---------------------------------------------

# GLOBAL PAW CURSOR --------------------------------------

# GLOBAL PAW CURSOR
paw_svg <- r"(<svg xmlns='http://www.w3.org/2000/svg' width='40' height='40' viewBox='0 0 32 32'><g fill='%2375462F' stroke='white' stroke-width='1'><ellipse cx='16' cy='21' rx='8' ry='6.5'/><circle cx='6' cy='13' r='3.2'/><circle cx='12' cy='7' r='3.4'/><circle cx='20' cy='7' r='3.4'/><circle cx='26' cy='13' r='3.2'/></g></svg>)"

paw_css <- paste0(
  "html, body, body *:not(input):not(textarea), ",
  ".leaflet-container, .leaflet-container * {",
  "cursor: url(\"data:image/svg+xml;utf8,",
  paw_svg,
  "\") 12 12, auto !important;",
  "}"
)


ui <- dashboardPage(
  
  
  # HEADER ---------------------------------------------------------------
  
  # This is the bar across the top of the app.
  # The title also appears at the top of the sidebar.
  
  dashboardHeader(
    title = "Dog Breed Explorer"
  ),
  
  
  # SIDEBAR --------------------------------------------------------------
  
  # This creates the permanent navigation bar on the left side.
  
  dashboardSidebar(
    
    sidebarMenu(
      
      # HOME
      # tabName tells Shiny which page this button should open.
      menuItem(
        "Home",
        tabName = "home",
        icon = icon("house")
      ),
      
      # BREED EXPLORER
      menuItem(
        "Breed Explorer",
        tabName = "breed_explorer",
        icon = icon("dog")
      ),
      
      # TRAITS & TRENDS
      menuItem(
        "Traits & Trends",
        tabName = "traits",
        icon = icon("chart-column")
      ),
      
      # COMPARE BREEDS
      menuItem(
        "Compare Breeds",
        tabName = "compare",
        icon = icon("scale-balanced")
      ),
      
      # FIND A BREED
      menuItem(
        "Find a Breed",
        tabName = "find_breed",
        icon = icon("magnifying-glass")
      ),
      
      # What dog are you questionnaire
      menuItem(
        "Soul Dog",
        tabName = "souldog",
        icon = icon("heart")
      ),
      
      # ABOUT
      menuItem(
        "About Us",
        tabName = "about",
        icon = icon("circle-info")
      ),
      
      #References
      menuItem(
        "References",
        tabName = "references",
        icon = icon("book")
      )
      
    )
  ),
  
  # BODY -----------------------------------------------------------------
  
  # This is the large area on the right.
  # The content displayed here changes when someone clicks
  # a page in the sidebar.
  
  dashboardBody(
    
    # Load our universal CSS stylesheet.
    # Shiny will apply these styles to every page.
    tags$head(
      tags$link(
        rel = "stylesheet",
        type = "text/css",
        href = "styles/style.css"
      )
    ),
    
# Additional global cursor styling
tags$style(HTML(paste0(
  "html, body, body *:not(input):not(textarea), ",
  ".leaflet-container, .leaflet-container * {",
  "cursor: url('data:image/svg+xml;utf8,",
  paw_svg,
  "') 12 12, auto !important;}"
)))

    ),

    
# Apply the paw cursor to the entire website

  tags$head(
  tags$style(HTML(paw_css))
    ),
    tabItems(
      
      # HOME PAGE
      source("ui/home.R", local = TRUE)$value,
      
      # EXPLORE PAGE
      source("ui/breed_explorer.R", local = TRUE)$value,
      
      # TRAITS & TRENDS ---------------------------------------------------
      
      source("ui/traits.R", local = TRUE)$value,
      
      
      # COMPARE BREEDS ----------------------------------------------------
      
      # tabItem() creates the page that appears when the user
      # selects "Compare Breeds" from the sidebar
      source("ui/compare.R", local = TRUE)$value,
      
      # FIND A BREED ------------------------------------------------------
      
      source("ui/find_breed.R", local = TRUE)$value,
      
      
      # SOUL DOG QUESTIONNAIRE
      source("ui/soul_dog.R", local = TRUE)$value,
      
      # ABOUT -------------------------------------------------------------
      
      source("ui/about.R", local = TRUE)$value,
      
      # References -------------------------------------------------------------
      
      source("ui/references.R", local = TRUE)$value
      
      # Close tabItems()
    )
    
    # Close dashboardBody()
  )
  
  # Close dashboardPage()

# SERVER ----------------------------------------------------------

# The server controls what the app DOES behind the scenes.
#
# Eventually this is where we will:
#   - Read answers users give us
#   - Filter the dog dataset
#   - Calculate dog matches
#   - Create graphs
#   - Update information based on user selections
#

server <- function(input, output, session) {
  
  source("server/breed_explorer.R", local = TRUE)
  source("server/compare.R", local = TRUE)
  source("server/soul_dog.R", local = TRUE)
  source("server/find_breed.R", local = TRUE)
  source("server/references.R", local = TRUE)
}


# RUN THE APP -----------------------------------------------------

# This combines the UI and server and tells R to launch
# the Shiny application.

shinyApp(
  ui = ui,
  server = server
)
# change test

      