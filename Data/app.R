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

# LOAD DATA -------------------------------------------------------

# Read the cleaned dog breed CSV into R.
#
# stringsAsFactors = FALSE keeps text columns as text rather
# than automatically converting them into categories.
#
# fileEncoding tells R how the text in this CSV is encoded.
#
# check.names = TRUE converts unusual column names into
# R-friendly names. For example:
# "min_life (yrs)" becomes "min_life..yrs."
dog_data_clean <- read.csv(
  "dog_data_clean.csv",
  stringsAsFactors = FALSE,
  fileEncoding = "Windows-1252",
  check.names = TRUE
)


# Fix weird characters that appeared in some breed descriptions
dog_data_clean$description <- gsub(
  "‚Äî",
  "—",
  dog_data_clean$description,
  fixed = TRUE
)


# Create a second name for the same dataset for use
# in the Soul Dog questionnaire
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



#Convert questionnaire traits to numeric



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
        
        # Display the breed description
        textOutput("breed_description"),
        
        br(),
        
        # Display temperament separately because it is longer text
        h4("Temperament"),
        textOutput("breed_temperament"),
        
        br(),
        
        # Quick facts section
        h3("Quick Facts"),
        
        # Put four quick facts in boxes across one row
        fluidRow(
          
          valueBoxOutput("breed_group_box", width = 3),
          
          valueBoxOutput("breed_lifespan_box", width = 3),
          
          valueBoxOutput("breed_weight_box", width = 3),
          
          valueBoxOutput("breed_height_box", width = 3)
          
        )
        
      ), 
      
      
      # TRAITS & TRENDS ---------------------------------------------------
      
      tabItem(
        tabName = "traits",
        
        h1("Traits & Trends"),
        p("Interactive data visualizations will go here.")
      ),
      
      
      # COMPARE BREEDS ----------------------------------------------------
      
      # tabItem() creates the page that appears when the user
      # selects "Compare Breeds" from the sidebar
      tabItem(
        tabName = "compare",
        
        
        # PAGE INTRODUCTION -----------------------------------------------
        
        # Main title displayed at the top of the page
        h1("Compare Breeds"),
        
        # Brief instructions explaining what the page does
        p("Choose two breeds to see how their size, lifespan, temperament, and key traits compare."),
        
        # br() adds a small amount of vertical space
        br(),
        
        
        # BREED SELECTION -------------------------------------------------
        
        # fluidRow() creates a horizontal row.
        # Shiny divides each row into 12 columns.
        fluidRow(
          
          
          # FIRST BREED DROPDOWN
          
          # Give the first dropdown 5 of the 12 available columns
          column(
            width = 5,
            
            # selectInput() creates a dropdown menu
            selectInput(
              
              # This ID allows us to access the user's selection
              # in the server using input$compare_breed_1
              inputId = "compare_breed_1",
              
              # Label displayed above the dropdown
              label = "First Breed",
              
              # Use every breed name in our dataset as an option.
              # sort() puts the breed names in alphabetical order.
              choices = sort(dog_data_clean$name),
              
              # Automatically select the first breed alphabetically
              # when the app first loads
              selected = sort(dog_data_clean$name)[1]
            )
          ),
          
          
          # VS LABEL
          
          # Use the middle 2 columns for the VS text
          column(
            width = 2,
            
            # div() creates an HTML container that we can style
            div(
              
              # Center VS and move it down so it lines up
              # more closely with the dropdown menus
              style = "text-align: center; padding-top: 25px;",
              
              # h3() displays VS as a heading
              h3("VS")
            )
          ),
          
          
          # SECOND BREED DROPDOWN
          
          # Give the second dropdown the final 5 columns
          column(
            width = 5,
            
            selectInput(
              
              # We access this selection in the server using
              # input$compare_breed_2
              inputId = "compare_breed_2",
              
              label = "Second Breed",
              
              # Use the same alphabetical breed list
              choices = sort(dog_data_clean$name),
              
              # Start with the second breed alphabetically so that
              # the app initially compares two different breeds
              selected = sort(dog_data_clean$name)[2]
            )
          )
          
        ),
        
        
        # Add some space before the breed summary cards
        br(),
        
        
        # BREED SUMMARY CARDS ---------------------------------------------
        
        # Put the two breed summaries side-by-side
        fluidRow(
          
          
          # FIRST BREED SUMMARY
          
          # box() creates a shinydashboard content card
          box(
            
            # Give this card half of the 12-column row
            width = 6,
            
            # textOutput() tells Shiny that the server will dynamically
            # provide the title using output$compare_name_1
            title = textOutput("compare_name_1"),
            
            # "primary" gives the box the dashboard's primary accent color
            status = "primary",
            
            # TRUE fills the header with the accent color
            solidHeader = TRUE,
            
            # uiOutput() creates a space where the server can insert
            # several pieces of HTML/text about Breed 1
            uiOutput("compare_info_1")
          ),
          
          
          # SECOND BREED SUMMARY
          
          box(
            width = 6,
            
            # This connects to output$compare_name_2 in the server
            title = textOutput("compare_name_2"),
            
            status = "primary",
            solidHeader = TRUE,
            
            # This connects to output$compare_info_2 in the server
            uiOutput("compare_info_2")
          )
          
        ),
        
        
        # TRAIT COMPARISON ------------------------------------------------
        
        # Create one full-width box for the interactive visualization
        box(
          
          # width = 12 makes the box span the entire page
          width = 12,
          
          # Title displayed in the box header
          title = "Trait Showdown",
          
          status = "primary",
          solidHeader = TRUE,
          
          # Explain how to interpret the visualization
          p("Compare the two breeds across key behavioral and lifestyle traits. Each trait is rated from 1 to 5."),
          
          # plotlyOutput() reserves space for the interactive graph
          # that we will create in the server.
          #
          # The name "trait_comparison" must match
          # output$trait_comparison in the server.
          plotlyOutput(
            outputId = "trait_comparison",
            height = "500px"
          )
          
        )
        
      ),
      
      
      # FIND A BREED ------------------------------------------------------
      
      tabItem(
        tabName = "find_breed",
        
        h1("Find a Breed"),
        p("Breed filtering tools will go here.")
      ),
      
      
      
      # SOUL DOG QUESTIONNAIRE
      
      # SOUL DOG QUESTIONNAIRE
      tabItem(
        tabName = "souldog",
        
        div(
          style = "
      background-color: #F5F1EB;
      padding: 30px;
      border-radius: 15px;
    ",
          
          # PAGE HEADER
          div(
            style = "
        text-align: center;
        padding: 20px;
        margin-bottom: 20px;
      ",
            h1(
              "🐾 What Dog Breed Are You?",
              style = "
          color: #594637;
          font-weight: bold;
        "
            ),
            p(
              "Answer eight questions to discover your dog breed personality match.",
              style = "
          color: #75685D;
          font-size: 16px;
        "
            )
          ),
          
          # QUESTION 1
          div(
            style = "
        background-color: white;
        padding: 20px;
        border-radius: 12px;
        margin-bottom: 15px;
        border: 1px solid #E5DED5;
      ",
            h3("1. How active are you?",
               style = "color: #594637;"),
            radioButtons("energy", NULL, choices = c(
              "I prefer relaxing" = 1,
              "I'm fairly laid-back" = 2,
              "I enjoy a balance of activity and rest" = 3,
              "I enjoy being active" = 4,
              "I'm always on an adventure!" = 5
            ))
          ),
          
          # QUESTION 2
          div(
            style = "
        background-color: white;
        padding: 20px;
        border-radius: 12px;
        margin-bottom: 15px;
        border: 1px solid #E5DED5;
      ",
            h3("2. How affectionate are you?",
               style = "color: #594637;"),
            radioButtons("affection", NULL, choices = c(
              "I keep my feelings to myself" = 1,
              "I'm affectionate with a few people" = 2,
              "I show affection in my own way" = 3,
              "I'm caring and supportive" = 4,
              "I'm extremely affectionate!" = 5
            ))
          ),
          
          # QUESTION 3
          div(
            style = "
        background-color: white;
        padding: 20px;
        border-radius: 12px;
        margin-bottom: 15px;
        border: 1px solid #E5DED5;
      ",
            h3("3. How do you feel about meeting new people?",
               style = "color: #594637;"),
            radioButtons("social", NULL, choices = c(
              "I prefer familiar people" = 1,
              "I'm shy around new people" = 2,
              "It depends on the situation" = 3,
              "I enjoy meeting new people" = 4,
              "I love meeting new people!" = 5
            ))
          ),
          
          # QUESTION 4
          div(
            style = "
        background-color: white;
        padding: 20px;
        border-radius: 12px;
        margin-bottom: 15px;
        border: 1px solid #E5DED5;
      ",
            h3("4. How playful are you?",
               style = "color: #594637;"),
            radioButtons("play", NULL, choices = c(
              "I'm quiet and relaxed" = 1,
              "I enjoy occasional fun" = 2,
              "I like a balance" = 3,
              "I love games and activities" = 4,
              "I'm always ready for fun!" = 5
            ))
          ),
          
          # QUESTION 5
          div(
            style = "
        background-color: white;
        padding: 20px;
        border-radius: 12px;
        margin-bottom: 15px;
        border: 1px solid #E5DED5;
      ",
            h3("5. How do you handle unexpected changes?",
               style = "color: #594637;"),
            radioButtons("adaptability", NULL, choices = c(
              "I prefer familiar routines" = 1,
              "I need time to adjust" = 2,
              "I adapt with preparation" = 3,
              "I'm comfortable with change" = 4,
              "I thrive in new situations!" = 5
            ))
          ),
          
          # QUESTION 6
          div(
            style = "
        background-color: white;
        padding: 20px;
        border-radius: 12px;
        margin-bottom: 15px;
        border: 1px solid #E5DED5;
      ",
            h3("6. How do you approach learning something new?",
               style = "color: #594637;"),
            radioButtons("trainability", NULL, choices = c(
              "I prefer figuring things out myself" = 1,
              "I need time and patience" = 2,
              "I learn with some guidance" = 3,
              "I enjoy clear instructions" = 4,
              "I love learning new skills!" = 5
            ))
          ),
          
          # QUESTION 7
          div(
            style = "
        background-color: white;
        padding: 20px;
        border-radius: 12px;
        margin-bottom: 15px;
        border: 1px solid #E5DED5;
      ",
            h3("7. How much do you enjoy mental challenges?",
               style = "color: #594637;"),
            radioButtons("mental", NULL, choices = c(
              "I prefer relaxing activities" = 1,
              "I enjoy occasional challenges" = 2,
              "I like moderate challenges" = 3,
              "I enjoy puzzles" = 4,
              "I love complex problems!" = 5
            ))
          ),
          
          # QUESTION 8
          div(
            style = "
        background-color: white;
        padding: 20px;
        border-radius: 12px;
        margin-bottom: 15px;
        border: 1px solid #E5DED5;
      ",
            h3("8. How protective are you of loved ones?",
               style = "color: #594637;"),
            radioButtons("protective", NULL, choices = c(
              "I avoid conflict" = 1,
              "I offer support when needed" = 2,
              "I look out for loved ones" = 3,
              "I'm very protective" = 4,
              "I'm fiercely loyal!" = 5
            ))
          ),
          
          # SUBMIT BUTTON
          div(
            style = "
        text-align: center;
        padding: 20px;
      ",
            actionButton(
              "match",
              "🐾 Find My Dog Breed!",
              style = "
          background-color: #A47755;
          color: white;
          font-size: 18px;
          font-weight: bold;
          border: none;
          border-radius: 10px;
          padding: 12px 30px;
        "
            )
          ),
          
          # RESULTS SECTION
          div(
            style = "
        background-color: white;
        padding: 25px;
        border-radius: 12px;
        margin-top: 15px;
        border: 1px solid #E5DED5;
      ",
            uiOutput("breed_result"),
            
            h3(
              "🐶 Your Top 3 Matches",
              style = "color: #594637;"
            ),
            
            tableOutput("other_matches")
          )
        )
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
   
   # Display temperament
   output$breed_temperament <- renderText({
     
     selected_breed_data()$temperament
     
   })
   
   
   # QUICK FACT BOXES -------------------------------------------------
   
   
   # Breed group box
   output$breed_group_box <- renderValueBox({
     
     valueBox(
       value = selected_breed_data()$group,
       subtitle = "Breed Group",
       icon = icon("dog")
     )
     
   })
   
   
   # Lifespan box
   output$breed_lifespan_box <- renderValueBox({
     
     valueBox(
       value = paste0(
         selected_breed_data()[["min_life (yrs)"]],
         "–",
         selected_breed_data()[["max_life (yrs)"]],
         " years"
       ),
       subtitle = "Typical Lifespan",
       icon = icon("heart")
     )
     
   })
   
   
   # Weight box
   output$breed_weight_box <- renderValueBox({
     
     valueBox(
       value = paste0(
         round(selected_breed_data()$min_wt_lbs, 1),
         "–",
         round(selected_breed_data()$max_wt_lbs, 1),
         " lbs"
       ),
       subtitle = "Weight",
       icon = icon("weight")
     )
     
   })
   
   
   # Height box
   output$breed_height_box <- renderValueBox({
     
     valueBox(
       value = paste0(
         round(selected_breed_data()$min_ht_inch, 1),
         "–",
         round(selected_breed_data()$max_ht_inch, 1),
         " in"
       ),
       subtitle = "Height",
       icon = icon("arrows-alt-v")
     )
     
   })
   
   # COMPARE BREEDS ----------------------------------------------------
   
   
   # SELECT DATA FOR BREED 1 ------------------------------------------
   
   # reactive() creates an object that automatically updates
   # whenever the user changes the first breed dropdown.
   compare_breed_1_data <- reactive({
     
     # Start with the complete dog dataset
     dog_data_clean |>
       
       # filter() keeps only the row where the breed name
       # matches the user's selection in the first dropdown.
       #
       # input$compare_breed_1 comes from:
       # selectInput(inputId = "compare_breed_1") in the UI.
       filter(name == input$compare_breed_1)
     
   })
   
   
   # SELECT DATA FOR BREED 2 ------------------------------------------
   
   # This does exactly the same thing for the second dropdown.
   compare_breed_2_data <- reactive({
     
     dog_data_clean |>
       
       # Keep only the selected second breed
       filter(name == input$compare_breed_2)
     
   })


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