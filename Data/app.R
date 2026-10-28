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

# LOAD DATA -------------------------------------------------------

# Read our cleaned dog dataset into R.
# Replace the filename below with the EXACT name of the Excel file
# in the Files pane.

dog_data_clean <- read.csv("dog_data_clean.csv",
                           stringsAsFactors = FALSE,
                           check.names = TRUE)

# Make the dataset available to the questionnaire code
dog_data <- dog_data_clean

# Traits used by the questionnaire
traits <- c(
  "energy.level",
  "affectionate.with.family",
  "openness.to.strangers",
  "playfulness.level",
  "adaptability.level",
  "trainability.level",
  "mental.stimulation.needs",
  "watchdog.protective.nature"
)



# APP THEME -------------------------------------------------------

# This creates the visual theme that will be used throughout the app.
# "minty" can be replaced later with another Bootswatch theme.

app_theme <- bs_theme(
  bootswatch = "minty"
)

for (trait in traits) {
  dog_data[[trait]] <- suppressWarnings(
    as.numeric(as.character(dog_data[[trait]]))
  )
}

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
    
    tabItems(
      
      # HOME PAGE
      tabItem(
        tabName = "home",
        
        h1("Dog Breed Explorer"),
        
        h3("Find your new best friend"),
        
        p("Discover breeds that fit your lifestyle, preferences, 
          and personality.")
      ), 
      
  
      
      # EXPLORE PAGE
      tabItem(
        tabName = "breed_explorer",
        
        h1("Breed Explorer"),
        
        # Short instructions
        p("Select a breed below to explore its characteristics."),
        
        # Dropdown menu containing all dog breeds
        selectInput(
          inputId = "selected_breed",
          label = "Choose a breed:",
          choices = sort(dog_data_clean$name)
        ), 
        
        # Displays the name of the breed selected by the user
        h2(textOutput("breed_name")),
        
        #Display the breed description
        textOutput("breed_description"), 
        
        
        #Quick facts about the selected breed
        h3("Quick Facts"), 
        
        textOutput("breed_group"),
        textOutput("breed_temperament"),
        textOutput("breed_lifespan"),
        textOutput("breed_height"),
        textOutput("breed_weight")
        
        
        
      ),
      
      
      # TRAITS & TRENDS ---------------------------------------------------
      
      tabItem(
        tabName = "traits",
        
        h1("Traits & Trends"),
        p("Interactive data visualizations will go here.")
      ),
      
      
      # COMPARE BREEDS ----------------------------------------------------
      
      tabItem(
        tabName = "compare",
        
        h1("Compare Breeds"),
        p("Breed comparison tools will go here.")
      ),
      
      
      # FIND A BREED ------------------------------------------------------
      
      tabItem(
        tabName = "find_breed",
        
        h1("Find a Breed"),
        p("Breed filtering tools will go here.")
      ),
      
      
      
      # SOUL DOG QUESTIONNAIRE
      tabItem(
        tabName = "souldog",
        
        h1("What Dog Breed Are You?"),
        p("Answer eight questions to discover your dog breed personality match."),
        
        h3("1. How active are you?"),
        radioButtons("energy", NULL, choices = c(
          "I prefer relaxing" = 1,
          "I'm fairly laid-back" = 2,
          "I enjoy a balance of activity and rest" = 3,
          "I enjoy being active" = 4,
          "I'm always on an adventure!" = 5
        )),
        
        h3("2. How affectionate are you?"),
        radioButtons("affection", NULL, choices = c(
          "I keep my feelings to myself" = 1,
          "I'm affectionate with a few people" = 2,
          "I show affection in my own way" = 3,
          "I'm caring and supportive" = 4,
          "I'm extremely affectionate!" = 5
        )),
        
        h3("3. How do you feel about meeting new people?"),
        radioButtons("social", NULL, choices = c(
          "I prefer familiar people" = 1,
          "I'm shy around new people" = 2,
          "It depends on the situation" = 3,
          "I enjoy meeting new people" = 4,
          "I love meeting new people!" = 5
        )),
        
        h3("4. How playful are you?"),
        radioButtons("play", NULL, choices = c(
          "I'm quiet and relaxed" = 1,
          "I enjoy occasional fun" = 2,
          "I like a balance" = 3,
          "I love games and activities" = 4,
          "I'm always ready for fun!" = 5
        )),
        
        h3("5. How do you handle unexpected changes?"),
        radioButtons("adaptability", NULL, choices = c(
          "I prefer familiar routines" = 1,
          "I need time to adjust" = 2,
          "I adapt with preparation" = 3,
          "I'm comfortable with change" = 4,
          "I thrive in new situations!" = 5
        )),
        
        h3("6. How do you approach learning something new?"),
        radioButtons("trainability", NULL, choices = c(
          "I prefer figuring things out myself" = 1,
          "I need time and patience" = 2,
          "I learn with some guidance" = 3,
          "I enjoy clear instructions" = 4,
          "I love learning new skills!" = 5
        )),
        
        h3("7. How much do you enjoy mental challenges?"),
        radioButtons("mental", NULL, choices = c(
          "I prefer relaxing activities" = 1,
          "I enjoy occasional challenges" = 2,
          "I like moderate challenges" = 3,
          "I enjoy puzzles" = 4,
          "I love complex problems!" = 5
        )),
        
        h3("8. How protective are you of loved ones?"),
        radioButtons("protective", NULL, choices = c(
          "I avoid conflict" = 1,
          "I offer support when needed" = 2,
          "I look out for loved ones" = 3,
          "I'm very protective" = 4,
          "I'm fiercely loyal!" = 5
        )),
        
        actionButton("match", "Find My Dog Breed!"),
        
        br(),
        br(),
        
        uiOutput("breed_result"),
        
        h3("Your Top 3 Matches"),
        tableOutput("other_matches")
      ),
      
      # ABOUT -------------------------------------------------------------
      
      tabItem(
        tabName = "about",
        
        h1("About"),
        p("Information about the data and project will go here.")
      )
      
    )
  )
  
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
  
  
  # Create the breed name that will appear on the Breed Explorer page
 
  # Filter the dataset to only the breed selected by the user
  selected_breed_data <- reactive({
    
    dog_data_clean |>
      filter(name == input$selected_breed)
    
  })
  
  
  # Display the selected breed's name
  
   output$breed_name <- renderText({
    
    input$selected_breed
    
  })
  
  #Display the description for the selected breed
   output$breed_description <- renderText({
     
     selected_breed_data()$description
     
     
   })
   
   # Display breed group
   output$breed_group <- renderText({
     
     paste("Breed Group:", selected_breed_data()$group)
     
   })
   
   
   # Display temperament
   output$breed_temperament <- renderText({
     
     paste("Temperament:", selected_breed_data()$temperament)
     
   })
   
   
   # Display lifespan
   output$breed_lifespan <- renderText({
     
     paste(
       "Lifespan:",
       selected_breed_data()[["min_life (yrs)"]],
       "-",
       selected_breed_data()[["max_life (yrs)"]],
       "years"
     )
     
   })
   
   
   # Display height
   output$breed_height <- renderText({
     
     paste(
       "Height:",
       selected_breed_data()$min_ht_inch,
       "-",
       selected_breed_data()$max_ht_inch,
       "inches"
     )
     
   })
   
   
   # Display weight
   output$breed_weight <- renderText({
     
     paste(
       "Weight:",
       selected_breed_data()$min_wt_lbs,
       "-",
       selected_breed_data()$max_wt_lbs,
       "lbs"
     )
     
   })
   
# Convert the breed traits to numeric values


# Calculate breed matches when the button is clicked
matches <- eventReactive(input$match, {

  answers <- c(
    input$energy,
    input$affection,
    input$social,
    input$play,
    input$adaptability,
    input$trainability,
    input$mental,
    input$protective
  )

  # Require the user to answer all questions
  if (any(sapply(answers, is.null))) {
    showNotification(
      "Please answer all eight questions first!",
      type = "warning"
    )
    return(NULL)
  }

  answers <- as.numeric(answers)

  # Compare the user's answers with each breed's traits
  breed_traits <- as.matrix(
    dog_data[, traits, drop = FALSE]
  )

  differences <- abs(
    sweep(breed_traits, 2, answers, "-")
  )

  distances <- rowSums(differences, na.rm = FALSE)

  # Smaller distances mean closer matches
  valid <- is.finite(distances)

  if (!any(valid)) {
    showNotification(
      "Unable to calculate matches. Check the breed trait data.",
      type = "error"
    )
    return(NULL)
  }

  results <- dog_data[valid, , drop = FALSE]
  results$Distance <- distances[valid]

  results$Similarity <- round(
    100 * (1 - results$Distance / (length(traits) * 4)),
    1
  )

  results <- results[
    order(results$Distance),
    ,
    drop = FALSE
  ]

  results
})

# Display the best-matching breed
output$breed_result <- renderUI({

  results <- matches()
  req(!is.null(results), nrow(results) > 0)

  best <- results[1, ]

  description <- if (
    "description" %in% names(results) &&
    !is.na(best$description) &&
    nzchar(as.character(best$description))
  ) {
    as.character(best$description)
  } else {
    "Your answers most closely match this breed's recorded traits."
  }

  temperament <- if (
    "temperament" %in% names(results) &&
    !is.na(best$temperament)
  ) {
    as.character(best$temperament)
  } else {
    "Not available"
  }

  group <- if (
    "group" %in% names(results) &&
    !is.na(best$group)
  ) {
    as.character(best$group)
  } else {
    "Not available"
  }

  tagList(
    h2(paste("Your Match:", best$name)),
    h4(paste0("Personality similarity: ", best$Similarity, "%")),
    h4("Breed Group"),
    p(group),
    h4("Temperament"),
    p(temperament),
    h4("About This Breed"),
    p(description),
    p(
      style = "font-style:italic;",
      "This is an entertainment-based match, not a scientific personality test."
    )
  )
})

# Display the three closest breed matches
output$other_matches <- renderTable({

  results <- matches()
  req(!is.null(results), nrow(results) > 0)

  top_n <- min(3, nrow(results))
  top <- results[seq_len(top_n), , drop = FALSE]

  data.frame(
    Rank = seq_len(top_n),
    Breed = top$name,
    Similarity = paste0(top$Similarity, "%")
  )
})

}

#ui and server for soul dog questionnaire

# RUN THE APP -----------------------------------------------------

# This combines the UI and server and tells R to launch
# the Shiny application.

shinyApp(
  ui = ui,
  server = server
)
#change