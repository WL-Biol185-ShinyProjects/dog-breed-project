# ================================================================
# DOG MATCHING SHINY APP
# ================================================================
#   1. UI = what the user sees
#   2. Server = what the app does behind the scenes
# ================================================================


# PACKAGES --------------------------------------------------------

library(shiny)

library(tidyverse)

library(bslib)

library(shinydashboard)

# LOAD DATA -------------------------------------------------------

# Read our cleaned dog dataset into R.
# Replace the filename below with the EXACT name of the Excel file
# in the Files pane.

dog_data_clean <- read_csv("data/dog_data_clean.csv")



# APP THEME -------------------------------------------------------

# This creates the visual theme that will be used throughout the app.
# "minty" can be replaced later with another Bootswatch theme.

app_theme <- bs_theme(
  bootswatch = "minty"
)



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
        tabName = "souldogog",
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
      
      
      # What dog are you questionnaire --------------------------------------------------------
      
      tabItem(
        tabName = "Soul Dog",
        
        h1("souldog"),
        p("Dog matching questionnaire will go here.")
      ),
      
      
      library(shiny)
      
      ui <- fluidPage(
        
        tags$head(
          tags$style(HTML("
      body {
        background-color: #FFF8F0;
        font-family: Arial, sans-serif;
        color: #40352F;
      }

      .container-fluid {
        max-width: 900px;
        margin: auto;
        padding: 25px;
      }

      .quiz-header {
        background-color: #C98555;
        color: white;
        padding: 30px;
        border-radius: 18px;
        text-align: center;
        margin-bottom: 25px;
      }

      .quiz-header h1 {
        color: white;
      }

      .question-card {
        background-color: white;
        padding: 20px;
        margin-bottom: 18px;
        border-radius: 12px;
        box-shadow: 0 2px 6px rgba(0,0,0,0.08);
      }

      .btn-primary {
        background-color: #A85D38;
        border-color: #A85D38;
        font-size: 17px;
        padding: 12px 25px;
        border-radius: 10px;
      }

      .result-card {
        background-color: #F5E3D2;
        padding: 25px;
        border-radius: 15px;
        margin-top: 25px;
        margin-bottom: 30px;
      }

      h2, h3 {
        color: #75462F;
      }
    "))
        ),
        
        # Header
        div(
          class = "quiz-header",
          h1("What Dog Breed Are You?"),
          h3("Find your canine personality match!"),
          p("Answer eight questions to discover your dog breed match.")
        ),
        
        # Question 1
        div(
          class = "question-card",
          h3("1. How active are you?"),
          radioButtons(
            "energy", NULL,
            choices = c(
              "I prefer relaxing" = 1,
              "I'm fairly laid-back" = 2,
              "I enjoy a balance of activity and rest" = 3,
              "I enjoy being active" = 4,
              "I'm always looking for an adventure!" = 5
            )
          )
        ),
        
        # Question 2
        div(
          class = "question-card",
          h3("2. How affectionate are you?"),
          radioButtons(
            "affection", NULL,
            choices = c(
              "I keep my feelings to myself" = 1,
              "I'm affectionate with a few people" = 2,
              "I show affection in my own way" = 3,
              "I'm caring and supportive" = 4,
              "I'm extremely affectionate!" = 5
            )
          )
        ),
        
        # Question 3
        div(
          class = "question-card",
          h3("3. How do you feel about meeting new people?"),
          radioButtons(
            "social", NULL,
            choices = c(
              "I prefer familiar people" = 1,
              "I'm shy around new people" = 2,
              "It depends on the situation" = 3,
              "I enjoy meeting new people" = 4,
              "I love making new connections!" = 5
            )
          )
        ),
        
        # Question 4
        div(
          class = "question-card",
          h3("4. How playful are you?"),
          radioButtons(
            "play", NULL,
            choices = c(
              "I'm quiet and relaxed" = 1,
              "I enjoy occasional fun" = 2,
              "I like a balance of fun and relaxation" = 3,
              "I love games and activities" = 4,
              "I'm always ready for fun!" = 5
            )
          )
        ),
        
        # Question 5
        div(
          class = "question-card",
          h3("5. How do you handle unexpected changes?"),
          radioButtons(
            "adaptability", NULL,
            choices = c(
              "I prefer familiar routines" = 1,
              "I need time to adjust" = 2,
              "I adapt with some preparation" = 3,
              "I'm comfortable with most changes" = 4,
              "I thrive in new situations!" = 5
            )
          )
        ),
        
        # Question 6
        div(
          class = "question-card",
          h3("6. How do you approach learning something new?"),
          radioButtons(
            "trainability", NULL,
            choices = c(
              "I prefer figuring things out myself" = 1,
              "I need time and patience" = 2,
              "I learn best with some guidance" = 3,
              "I enjoy clear instructions" = 4,
              "I love learning new skills!" = 5
            )
          )
        ),
        
        # Question 7
        div(
          class = "question-card",
          h3("7. How much do you enjoy mental challenges?"),
          radioButtons(
            "mental", NULL,
            choices = c(
              "I prefer relaxing activities" = 1,
              "I enjoy occasional challenges" = 2,
              "I like moderate challenges" = 3,
              "I enjoy puzzles and problem-solving" = 4,
              "I love complex problems!" = 5
            )
          )
        ),
        
        # Question 8
        div(
          class = "question-card",
          h3("8. How protective are you of people you care about?"),
          radioButtons(
            "protective", NULL,
            choices = c(
              "I avoid conflict" = 1,
              "I offer support when needed" = 2,
              "I look out for loved ones" = 3,
              "I'm very protective" = 4,
              "I'm fiercely loyal!" = 5
            )
          )
        ),
        
        # Submit button
        div(
          style = "text-align:center; margin:25px;",
          actionButton(
            "match",
            "Find My Dog Breed!",
            class = "btn-primary"
          )
        ),
        
        # Results
        div(
          class = "result-card",
          uiOutput("breed_result"),
          h3("Your Top 3 Matches"),
          tableOutput("other_matches")
        )
      )
      
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
# We do not need any server instructions yet because our
# webpage is currently just displaying static content.

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
   
  
}
#what dog breed are u

library(shiny)

server <- function(input, output, session) {
  
  # Find the CSV in either possible location
  possible_paths <- c(
    "data/dog_data_clean.csv",
    "dog_data_clean.csv"
  )
  
  csv_path <- possible_paths[
    file.exists(possible_paths)
  ]
  
  if (length(csv_path) == 0) {
    stop(
      paste0(
        "CSV file not found. Expected one of: ",
        paste(possible_paths, collapse = " or "),
        ". Check your GitHub repository structure."
      )
    )
  }
  
  # Read the CSV
  dog_data <- read.csv(
    csv_path[1],
    stringsAsFactors = FALSE,
    check.names = TRUE
  )
  
  # Trait columns used by the questionnaire
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
  
  # Check required columns
  required_columns <- c(
    "name",
    "description",
    "temperament",
    "group",
    traits
  )
  
  missing_columns <- setdiff(
    required_columns,
    names(dog_data)
  )
  
  if (length(missing_columns) > 0) {
    stop(
      paste(
        "These columns are missing from the CSV:",
        paste(missing_columns, collapse = ", "),
        "Check the exact column names in your dataset."
      )
    )
  }
  
  # Convert the trait scores to numbers
  for (trait in traits) {
    dog_data[[trait]] <- suppressWarnings(
      as.numeric(as.character(dog_data[[trait]]))
    )
  }
  
  # Keep breeds with complete trait data
  valid_data <- dog_data[
    complete.cases(dog_data[, traits]),
    ,
    drop = FALSE
  ]
  
  if (nrow(valid_data) == 0) {
    stop("No breeds have complete numerical trait scores.")
  }
  
  # Calculate breed matches
  calculate_matches <- function(answers) {
    
    breed_traits <- as.matrix(
      valid_data[, traits, drop = FALSE]
    )
    
    # Calculate the absolute difference for each trait
    differences <- abs(
      sweep(
        breed_traits,
        MARGIN = 2,
        STATS = answers,
        FUN = "-"
      )
    )
    
    # Add differences across all traits
    distances <- rowSums(differences)
    
    # Maximum difference for eight traits scored 1 to 5
    max_distance <- length(traits) * 4
    
    # Convert differences into similarity percentages
    similarity <- round(
      100 * (1 - distances / max_distance),
      1
    )
    
    # Add scores to the dataset
    results <- valid_data
    results$Distance <- distances
    results$Similarity <- similarity
    
    # Sort from best match to worst match
    results <- results[
      order(results$Distance, results$name),
      ,
      drop = FALSE
    ]
    
    rownames(results) <- NULL
    
    results
  }
  
  # Run matching when the button is clicked
  matches <- eventReactive(input$match, {
    
    # Require all eight questions to be answered
    req(
      input$energy,
      input$affection,
      input$social,
      input$play,
      input$adaptability,
      input$trainability,
      input$mental,
      input$protective
    )
    
    # Match answers to the Excel/CSV trait columns
    answers <- c(
      as.numeric(input$energy),
      as.numeric(input$affection),
      as.numeric(input$social),
      as.numeric(input$play),
      as.numeric(input$adaptability),
      as.numeric(input$trainability),
      as.numeric(input$mental),
      as.numeric(input$protective)
    )
    
    calculate_matches(answers)
  })
  
  # Display the closest breed
  output$breed_result <- renderUI({
    
    req(matches())
    
    results <- matches()
    best_match <- results[1, ]
    
    div(
      h2(
        paste(
          "Your Dog Breed Match:",
          best_match$name
        )
      ),
      
      h4(
        paste0(
          "Personality similarity: ",
          best_match$Similarity,
          "%"
        )
      ),
      
      tags$hr(),
      
      h4("Breed Group"),
      p(best_match$group),
      
      h4("Temperament"),
      p(best_match$temperament),
      
      h4("About This Breed"),
      p(best_match$description),
      
      p(
        style = "font-style:italic;",
        paste(
          "Your match is based on the similarity",
          "between your answers and this breed's",
          "recorded trait scores."
        )
      )
    )
  })
  
  # Display the top three breeds
  output$other_matches <- renderTable({
    
    req(matches())
    
    results <- matches()
    
    top_n <- min(3, nrow(results))
    
    top_matches <- results[
      seq_len(top_n),
      ,
      drop = FALSE
    ]
    
    data.frame(
      Rank = seq_len(top_n),
      Breed = top_matches$name,
      Group = top_matches$group,
      Temperament = top_matches$temperament,
      `Similarity (%)` = top_matches$Similarity,
      check.names = FALSE
    )
  })
}



# RUN THE APP -----------------------------------------------------

# This combines the UI and server and tells R to launch
# the Shiny application.

shinyApp(
  ui = ui,
  server = server
)