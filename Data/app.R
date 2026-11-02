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
   
   # BREED CARD TITLES -------------------------------------------------
   
   
   # renderText() creates text that can be sent to a textOutput()
   # element in the UI.
   output$compare_name_1 <- renderText({
     
     # Display whatever breed is currently selected
     # in the first dropdown.
     input$compare_breed_1
     
   })
   
   
   # Do the same thing for Breed 2.
   output$compare_name_2 <- renderText({
     
     input$compare_breed_2
     
   })
   
   # BREED 1 INFORMATION CARD -----------------------------------------
   
   # renderUI() allows us to create several pieces of formatted
   # information and send them together to uiOutput("compare_info_1").
   output$compare_info_1 <- renderUI({
     
     # Save the selected breed's row to a shorter variable called breed.
     #
     # This means we can write breed$group instead of repeatedly
     # writing compare_breed_1_data()$group.
     breed <- compare_breed_1_data()
     
     
     # tagList() groups several UI elements together so they
     # can all be returned by renderUI().
     tagList(
       
       
       # BREED GROUP
       
       # h4() creates a small heading
       h4("Breed Group"),
       
       # p() displays the breed's group as regular paragraph text
       p(breed$group),
       
       
       # TEMPERAMENT
       
       h4("Temperament"),
       
       p(breed$temperament),
       
       
       # LIFESPAN
       
       h4("Typical Lifespan"),
       
       # paste0() joins several pieces of text together
       # without automatically adding spaces.
       p(
         paste0(
           
           # Minimum lifespan from the dataset
           breed[["min_life (yrs)"]],
           
           # Add a dash between minimum and maximum
           "–",
           
           # Maximum lifespan
           breed[["max_life (yrs)"]],
           
           # Add the unit
           " years"
         )
       ),
       
       
       # WEIGHT
       
       h4("Weight"),
       
       p(
         paste0(
           
           # round(..., 1) rounds the weight to one decimal place
           # so we don't display long decimal values.
           round(breed$min_wt_lbs, 1),
           
           "–",
           
           round(breed$max_wt_lbs, 1),
           
           " lbs"
         )
       ),
       
       
       # HEIGHT
       
       h4("Height"),
       
       p(
         paste0(
           
           round(breed$min_ht_inch, 1),
           
           "–",
           
           round(breed$max_ht_inch, 1),
           
           " inches"
         )
       )
       
     )
     
   })
   
   # BREED 2 INFORMATION CARD -----------------------------------------
   
   # This works exactly like the Breed 1 information card,
   # but uses compare_breed_2_data().
   output$compare_info_2 <- renderUI({
     
     # Store the selected second breed's row in a shorter variable
     breed <- compare_breed_2_data()
     
     
     # Combine all of the information into one UI output
     tagList(
       
       
       # BREED GROUP
       
       h4("Breed Group"),
       
       p(breed$group),
       
       
       # TEMPERAMENT
       
       h4("Temperament"),
       
       p(breed$temperament),
       
       
       # LIFESPAN
       
       h4("Typical Lifespan"),
       
       p(
         paste0(
           breed[["min_life (yrs)"]],
           "–",
           breed[["max_life (yrs)"]],
           " years"
         )
       ),
       
       
       # WEIGHT
       
       h4("Weight"),
       
       p(
         paste0(
           round(breed$min_wt_lbs, 1),
           "–",
           round(breed$max_wt_lbs, 1),
           " lbs"
         )
       ),
       
       
       # HEIGHT
       
       h4("Height"),
       
       p(
         paste0(
           round(breed$min_ht_inch, 1),
           "–",
           round(breed$max_ht_inch, 1),
           " inches"
         )
       )
       
     )
     
   })
   
   # TRAIT COMPARISON DATA --------------------------------------------
   
   # reactive() means this dataset will automatically be rebuilt
   # whenever either selected breed changes.
   comparison_traits <- reactive({
     
     
     # Get the data for each selected breed
     breed1 <- compare_breed_1_data()
     breed2 <- compare_breed_2_data()
     
     
     # data.frame() creates a new small dataset specifically
     # for our comparison graph.
     data.frame(
       
       
       # These are the readable trait names that will appear
       # on the graph instead of the raw dataset column names.
       Trait = c(
         "Energy",
         "Trainability",
         "Playfulness",
         "Adaptability",
         "Affection",
         "Stranger Friendliness",
         "Protectiveness",
         "Mental Stimulation",
         "Barking"
       ),
       
       
       # Pull the corresponding trait scores for Breed 1.
       #
       # as.numeric() makes sure Plotly receives numbers
       # rather than text.
       Breed1 = as.numeric(
         c(
           breed1$energy.level,
           breed1$trainability.level,
           breed1$playfulness.level,
           breed1$adaptability.level,
           breed1$affectionate.with.family,
           breed1$openness.to.strangers,
           breed1$watchdog.protective.nature,
           breed1$mental.stimulation.needs,
           breed1$barking.level
         )
       ),
       
       
       # Pull the same trait scores for Breed 2.
       Breed2 = as.numeric(
         c(
           breed2$energy.level,
           breed2$trainability.level,
           breed2$playfulness.level,
           breed2$adaptability.level,
           breed2$affectionate.with.family,
           breed2$openness.to.strangers,
           breed2$watchdog.protective.nature,
           breed2$mental.stimulation.needs,
           breed2$barking.level
         )
       )
       
     )
     
   })
   
   # TRAIT COMPARISON GRAPH -------------------------------------------
   
   # renderPlotly() creates an interactive Plotly visualization
   # that will be sent to plotlyOutput("trait_comparison") in the UI.
   output$trait_comparison <- renderPlotly({
     
     
     # Get the trait comparison dataset we created above.
     comparison_data <- comparison_traits()
     
     
     # plot_ly() begins creating the interactive graph.
     plot_ly(
       
       # Tell Plotly which dataset to use
       data = comparison_data,
       
       # Put the trait names on the y-axis.
       #
       # ~Trait means "use the Trait column from comparison_data."
       y = ~Trait,
       
       # We are making a bar graph
       type = "bar",
       
       # orientation = "h" makes the bars horizontal
       orientation = "h"
       
     ) |>
       
       
       # FIRST BREED --------------------------------------------------
     
     # add_trace() adds one set of bars to the graph.
     add_trace(
       
       # Use Breed1 scores for the length of the bars
       x = ~Breed1,
       
       # The legend name will automatically display
       # the currently selected breed's name
       name = input$compare_breed_1
       
     ) |>
       
       
       # SECOND BREED -------------------------------------------------
     
     # Add a second set of bars for Breed 2
     add_trace(
       
       x = ~Breed2,
       
       name = input$compare_breed_2
       
     ) |>
       
       
       # GRAPH APPEARANCE ---------------------------------------------
     
     # layout() controls the appearance and organization
     # of the finished graph.
     layout(
       
       # barmode = "group" places the two breeds' bars
       # next to each other rather than stacking them.
       barmode = "group",
       
       
       # Configure the horizontal numeric axis
       xaxis = list(
         
         # Label underneath the axis
         title = "Trait Rating",
         
         # All traits use a 1–5 scale, so keep the graph
         # on the same scale regardless of breed.
         range = c(0, 5),
         
         # Show tick marks at each whole number
         tickvals = c(1, 2, 3, 4, 5)
       ),
       
       
       # Configure the vertical trait-name axis
       yaxis = list(
         
         # We don't need another title because the trait names
         # themselves already explain the axis.
         title = ""
       ),
       
       
       # Put the legend horizontally above the graph
       legend = list(
         orientation = "h",
         x = 0,
         y = 1.1
       )
       
     )
     
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