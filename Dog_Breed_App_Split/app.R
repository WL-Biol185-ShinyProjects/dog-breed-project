# ================================================================
# DOG MATCHING SHINY APP
# ================================================================
#   1. UI = what the user sees
#   2. Server = what the app does behind the scenes
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

source("R/data_setup.R", local = TRUE)

# USER INTERFACE (UI) ---------------------------------------------

# USER INTERFACE ----------------------------------------------------------

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
        "About",
        tabName = "about",
        icon = icon("circle-info")
      )
      
    )
  ),
  
  # BODY -----------------------------------------------------------------
  
  # This is the large area on the right.
  # The content displayed here changes when someone clicks
  # a page in the sidebar.
  
  dashboardBody(
    
    #Stylizing our website!
    
    tags$head(
      tags$style(HTML("

    /* GENERAL BACKGROUND */
    .content-wrapper, .right-side {
      background-color: #F5F3ED;
    }

    /* TOP HEADER */
    .main-header .logo {
      background-color: #354A3C;
      color: white;
      font-weight: bold;
    }

    .main-header .navbar {
      background-color: #526B52;
    }

    /* SIDEBAR */
    .main-sidebar {
      background-color: #354A3C;
    }

    .sidebar-menu > li > a {
      color: #FFFFFF;
      font-size: 15px;
    }

    .sidebar-menu > li.active > a {
      background-color: #526B52;
      border-left-color: #D8C7A3;
      color: white;
    }

    /* HEADINGS */
    h1, h2, h3, h4 {
      color: #354A3C;
      font-weight: bold;
    }

    /* BUTTONS */
    .btn-primary {
      background-color: #526B52;
      border-color: #526B52;
    }

    .btn-primary:hover {
      background-color: #354A3C;
    }

    /* PANELS */
    .box {
      border-radius: 8px;
      border-top: 3px solid #526B52;
      box-shadow: 0 2px 5px rgba(0,0,0,0.08);
    }
      
      /* IMPORT FONTS */
@import url('https://fonts.googleapis.com/css2?family=Lato:wght@400;500;600;700&family=Playfair+Display:wght@600;700&display=swap');

/* GENERAL TEXT */
body {
  font-family: 'Lato', sans-serif;
  color: #333333;
  font-size: 15px;
  line-height: 1.6;
}

/* MAIN HEADINGS */
h1, h2 {
  font-family: 'Playfair Display', serif;
  color: #354A3C;
  font-weight: 700;
}

/* SUBHEADINGS */
h3, h4, h5 {
  font-family: 'Lato', sans-serif;
  color: #526B52;
  font-weight: 700;
}

/* SIDEBAR NAVIGATION */
.sidebar-menu > li > a {
  font-family: 'Lato', sans-serif;
  font-size: 15px;
  font-weight: 600;
}

/* APP TITLE */
.main-header .logo {
  font-family: 'Playfair Display', serif;
  font-size: 19px;
  font-weight: 700;
}

/* BUTTONS */
.btn {
  font-family: 'Lato', sans-serif;
  font-weight: 600;
  letter-spacing: 0.2px;
}

/* PARAGRAPHS */
p {
  font-family: 'Lato', sans-serif;
  font-size: 15px;
  line-height: 1.7;
    }

  "))
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
      
      source("ui/about.R", local = TRUE)$value
      
      # Close tabItems()
    )
    
    # Close dashboardBody()
  )
  
  # Close dashboardPage()
)


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
}


# RUN THE APP -----------------------------------------------------

# This combines the UI and server and tells R to launch
# the Shiny application.

shinyApp(
  ui = ui,
  server = server
)
# change test
      