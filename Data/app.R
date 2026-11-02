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

# Traits used by the Soul Dog questionnaire
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

# Convert questionnaire traits to numeric values
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
        
        
        # TRAIT COMPARISON VISUALIZATION ---------------------------------
        
        # Create a full-width dashboard box for the interactive comparison
        box(
          
          # Use all 12 columns so the visualization spans the page
          width = 12,
          
          # Title displayed in the box header
          title = "Trait Showdown",
          
          # Use the dashboard's primary styling for now
          status = "primary",
          solidHeader = TRUE,
          
          
          # HEADER ROW ----------------------------------------------------
          
          # Put the explanation and category selector on the same row
          fluidRow(
            
            
            # LEFT SIDE: explanation
            
            column(
              width = 8,
              
              # Explain what the visualization represents
              p(
                "Compare the two breeds across key characteristics. All traits are rated from 1 to 5."
              )
            ),
            
            
            # RIGHT SIDE: trait category selector
            
            column(
              width = 4,
              
              # selectInput() lets the user decide which group of
              # characteristics they want to compare
              selectInput(
                
                # We will access this selection in the server using
                # input$trait_category
                inputId = "trait_category",
                
                # Label displayed above the dropdown
                label = "Compare:",
                
                # These are the three categories the user can choose
                choices = c(
                  "Personality",
                  "Social",
                  "Care & Lifestyle"
                ),
                
                # Personality will be shown when the page first opens
                selected = "Personality"
              )
            )
            
          ),
          
          
          # INTERACTIVE GRAPH ---------------------------------------------
          
          # This creates the space where our Plotly graph will appear.
          # It connects to output$trait_comparison in the server.
          plotlyOutput(
            outputId = "trait_comparison",
            height = "420px"
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
 
 # Close tabItems()
      )
 
 # Close dashboardBody()
    )
 
 # Close dashboardPage()
  )
 
 # Close the overall ui <- dashboardPage() expression
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
         
         # Minimum lifespan
         selected_breed_data()[["min_life (yrs)"]],
         
         "–",
         
         # Maximum lifespan
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
   
   # Create the data that will be used in the comparison graph.
   #
   # Because this is reactive(), it will automatically recalculate
   # whenever:
   #   1. Breed 1 changes
   #   2. Breed 2 changes
   #   3. The trait category changes
   comparison_traits <- reactive({
     
     
     # Store each selected breed's row in a shorter variable
     breed1 <- compare_breed_1_data()
     breed2 <- compare_breed_2_data()
     
     
     # PERSONALITY TRAITS ---------------------------------------------
     
     # If the user chooses "Personality" from the dropdown,
     # compare traits related to activity and behavior.
     if (input$trait_category == "Personality") {
       
       # Create readable labels for the graph
       trait_names <- c(
         "Energy",
         "Trainability",
         "Playfulness",
         "Adaptability",
         "Mental Stimulation"
       )
       
       # These are the actual column names in our dataset
       trait_columns <- c(
         "energy.level",
         "trainability.level",
         "playfulness.level",
         "adaptability.level",
         "mental.stimulation.needs"
       )
       
     }
     
     
     # SOCIAL TRAITS --------------------------------------------------
     
     # If the user chooses "Social", compare characteristics
     # related to interactions with people and other dogs.
     else if (input$trait_category == "Social") {
       
       trait_names <- c(
         "Family Affection",
         "Good With Children",
         "Good With Dogs",
         "Stranger Friendliness",
         "Protectiveness"
       )
       
       trait_columns <- c(
         "affectionate.with.family",
         "good.with.young.children",
         "good.with.other.dogs",
         "openness.to.strangers",
         "watchdog.protective.nature"
       )
       
     }
     
     
     # CARE & LIFESTYLE TRAITS ----------------------------------------
     
     # Otherwise, the user selected "Care & Lifestyle".
     else {
       
       trait_names <- c(
         "Shedding",
         "Grooming Needs",
         "Drooling",
         "Barking"
       )
       
       trait_columns <- c(
         "shedding.level",
         "coat.grooming.frequency",
         "drooling.level",
         "barking.level"
       )
       
     }
     
     
     # CREATE GRAPH DATA ----------------------------------------------
     
     # data.frame() creates a small temporary dataset specifically
     # for our graph.
     data.frame(
       
       # Readable trait names displayed on the graph
       Trait = trait_names,
       
       
       # Extract the selected columns for Breed 1.
       #
       # breed1[1, trait_columns] selects:
       #   - row 1
       #   - the trait columns selected above
       #
       # unlist() turns those values into a simple vector.
       #
       # as.numeric() ensures Plotly receives numbers.
       Breed1 = as.numeric(
         unlist(breed1[1, trait_columns])
       ),
       
       
       # Do exactly the same thing for Breed 2
       Breed2 = as.numeric(
         unlist(breed2[1, trait_columns])
       )
       
     )
     
   })
   
   
   # INTERACTIVE TRAIT COMPARISON GRAPH -------------------------------
   
   # renderPlotly() creates the interactive graph that is displayed
   # by plotlyOutput("trait_comparison") in the UI.
   output$trait_comparison <- renderPlotly({
     
     
     # Retrieve the comparison dataset created above
     comparison_data <- comparison_traits()
     
     
     # Reverse the order of the trait names.
     #
     # Plotly draws horizontal bar charts from bottom to top,
     # so reversing the levels makes the traits appear in the
     # same order that we listed them in our code.
     comparison_data$Trait <- factor(
       comparison_data$Trait,
       levels = rev(comparison_data$Trait)
     )
     
     
     # Start building the Plotly graph
     plot_ly(
       
       # Tell Plotly which dataset to use
       data = comparison_data,
       
       # Trait names appear on the vertical axis
       y = ~Trait,
       
       # Create a horizontal bar chart
       type = "bar",
       orientation = "h"
       
     ) |>
       
       
       # BREED 1 BARS -------------------------------------------------
     
     add_trace(
       
       # Breed 1's rating determines the length of each bar
       x = ~Breed1,
       
       # Use the selected breed's name in the legend
       name = input$compare_breed_1,
       
       # Create custom hover text.
       #
       # paste0() combines the breed name, trait name,
       # and score into one message.
       text = ~paste0(
         input$compare_breed_1,
         "<br>",
         Trait,
         ": ",
         Breed1,
         " / 5"
       ),
       
       # Only display our custom text when the user hovers
       hoverinfo = "text"
       
     ) |>
       
       
       # BREED 2 BARS -------------------------------------------------
     
     add_trace(
       
       x = ~Breed2,
       
       name = input$compare_breed_2,
       
       text = ~paste0(
         input$compare_breed_2,
         "<br>",
         Trait,
         ": ",
         Breed2,
         " / 5"
       ),
       
       hoverinfo = "text"
       
     ) |>
       
       
       # GRAPH LAYOUT -------------------------------------------------
     
     layout(
       
       # Put the two breeds beside each other for each trait
       barmode = "group",
       
       
       # Remove unnecessary empty space around the graph
       margin = list(
         l = 140,
         r = 30,
         t = 30,
         b = 50
       ),
       
       
       # HORIZONTAL RATING AXIS
       xaxis = list(
         
         # Axis title
         title = "Trait Rating",
         
         # Every trait is measured from 1 to 5
         range = c(0, 5),
         
         # Display whole-number ratings
         tickvals = c(1, 2, 3, 4, 5),
         
         # Add subtle grid lines to make comparisons easier
         showgrid = TRUE,
         
         # Remove the heavy axis line
         zeroline = FALSE
       ),
       
       
       # VERTICAL TRAIT AXIS
       yaxis = list(
         
         # No additional title is necessary
         title = "",
         
         # Prevent Plotly from automatically rearranging
         # our factor levels
         categoryorder = "array",
         
         categoryarray = levels(comparison_data$Trait)
       ),
       
       
       # LEGEND
       legend = list(
         
         # Display breed names horizontally
         orientation = "h",
         
         # Position the legend above the visualization
         x = 0,
         y = 1.12
       ),
       
       
       # Make the graph background transparent so that it
       # blends into the dashboard card
       paper_bgcolor = "rgba(0,0,0,0)",
       plot_bgcolor = "rgba(0,0,0,0)"
       
     ) |>
       
       
       # config() changes Plotly's interactive controls
       config(
         
         # Remove the Plotly logo from the toolbar
         displaylogo = FALSE,
         
         # Remove buttons that aren't useful for this graph
         modeBarButtonsToRemove = c(
           "zoom2d",
           "pan2d",
           "select2d",
           "lasso2d",
           "autoScale2d"
         )
       )
     
   })
   

#SOULDOG
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


# RUN THE APP -----------------------------------------------------

# This combines the UI and server and tells R to launch
# the Shiny application.

shinyApp(
  ui = ui,
  server = server
)
#change