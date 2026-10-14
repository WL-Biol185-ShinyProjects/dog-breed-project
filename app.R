#Load packages we will need
library(shiny)      # Builds the interactive web app
library(tidyverse)  # Data cleaning, manipulation, and ggplot visualizations
library(readxl)     # Reads the Excel dog dataset
library(bslib)      # Makes it easier to style/theme the Shiny app

#Load cleaned dog dataset

dog_data_clean <- read_csv("data/dog_data_clean")


## TODO: Create the basic Shiny app structure (UI + server)

#UI 

ui <- fluidPage ()

#Server

server <- function(input, output, session) {}

#Runapp

library(shiny)


server <- function(input, output, session) {
  
}

shinyApp(ui, server)



ui <- fluidPage(
  
  # TODO: Give the app a title and short subtitle/description
  #App title
  titlePanel("Find Your Perfect Dog"),
  
  #Short Description
  p("Looking for a new furry friend? Tell us a little bit about yourself
    and we'll use the AKC's comprehensive breed dataset to match you 
    with your perfect pet. Use the tabs to explore breeds and see what 
    makes each dog unique."),
  
  #theme
  theme = app_theme
)



# TODO: Choose a basic Shiny theme/color scheme

app_theme <- bs_theme(
  bootswatch = "minty"
)





# TODO: Create the navigation bar for the site

# TODO: Create an empty Home tab

# TODO: Create an empty "Find Your Dog" quiz tab

# TODO: Create an empty "Explore Breeds" tab

# TODO: Create an empty "Compare Breeds" tab

# TODO: Create an empty "About the Data" tab