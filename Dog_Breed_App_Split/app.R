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


# Make pictures show on homepage
shiny::addResourcePath(
  prefix = "home",
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
    
    # -------------------------------------------------------
    # GLOBAL STYLESHEET
    # -------------------------------------------------------
    # Load our custom CSS file.
    # This controls colors, fonts, backgrounds, and spacing
    # across all pages of our app.
    
    tags$head(
      tags$link(
        rel = "stylesheet",
        type = "text/css",
        href = "styles/style.css"
      )
    ),
    
    # -------------------------------------------------------
    # PAW CURSOR
    # -------------------------------------------------------
    # Apply our custom paw-shaped cursor throughout the app.
    # paw_css was already defined earlier in app.R.
    # We only need to apply it once here.
    
    tags$head(
      tags$style(HTML(paw_css))
    ),
    
    # -------------------------------------------------------
    # WEBSITE PAGES
    # -------------------------------------------------------
    # Each source() loads the UI for one page.
    # All pages must be inside tabItems(), which itself
    # must be inside dashboardBody().
    
    tabItems(
      
      # Home page
      source("ui/home.R", local = TRUE)$value,
      
      # Breed Explorer
      source("ui/breed_explorer.R", local = TRUE)$value,
      
      # Traits & Trends
      source("ui/traits.R", local = TRUE)$value,
      
      # Compare Breeds
      source("ui/compare.R", local = TRUE)$value,
      
      # Find a Breed
      source("ui/find_breed.R", local = TRUE)$value,
      
      # Soul Dog questionnaire
      source("ui/soul_dog.R", local = TRUE)$value,
      
      # About Us
      source("ui/about.R", local = TRUE)$value,
      
      # References
      source("ui/references.R", local = TRUE)$value
      
    ) # End tabItems()
    
  ), # End dashboardBody()
  
  # -------------------------------------------------------
  # DASHBOARD THEME
  # -------------------------------------------------------
  # shinydashboard requires one of its built-in skins.
  # Our custom CSS will override these default colors.
  
  skin = "green"
  
) # End dashboardPage()
 

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