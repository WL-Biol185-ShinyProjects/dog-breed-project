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

breed_data_paths <- c(
  "Data/dog_data_clean.csv",
  "data/dog_data_clean.csv",
  "dog_data_clean.csv"
)
breed_data_paths <- breed_data_paths[file.exists(breed_data_paths)]
if (length(breed_data_paths) == 0) {
  stop("Missing dog_data_clean.csv (checked Data/, data/, and project root)")
}
dog_data_clean <- read_csv(breed_data_paths[1], show_col_types = FALSE)



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
        
        # Single breed card: photo, measurements, details in place.
        uiOutput("single_breed_card")

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
      
      
      # SOUL DOG QUESTIONNAIRE --------------------------------------------
      # This must be a tabItem, not ui <- fluidPage() inside tabItems().
      tabItem(
        tabName = "souldogog",
        
        tags$head(
          tags$style(HTML("
      #shiny-tab-souldogog {
        background-color: #FFF8F0;
        font-family: Arial, sans-serif;
        color: #40352F;
      }

      #shiny-tab-souldogog .container-fluid {
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

      #shiny-tab-souldogog h2,
      #shiny-tab-souldogog h3 {
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

# Single Shiny server for the breed card and Soul Dog matching questionnaire.
server <- function(input, output, session) {

  # ----- SINGLE BREED CARD (no popups, no comparison) -----
  card_files <- c(
    "Data/breed_temperament.csv",
    "data/breed_temperament.csv",
    "breed_temperament.csv"
  )
  card_file <- card_files[file.exists(card_files)]
  card_images <- if (length(card_file) > 0) {
    read.csv(card_file[1], stringsAsFactors = FALSE,
             check.names = FALSE)
  } else {
    data.frame(Name = character(), Image = character(),
               stringsAsFactors = FALSE)
  }

  card_key <- function(x) {
    gsub("[^a-z0-9]", "", tolower(trimws(as.character(x))))
  }
  card_text <- function(x) {
    if (length(x) == 0 || is.na(x[1]) ||
        !nzchar(trimws(as.character(x[1])))) {
      return("Not available")
    }
    as.character(x[1])
  }
  card_number <- function(b, column) {
    if (!column %in% names(b)) return(NA_real_)
    suppressWarnings(as.numeric(b[[column]][1]))
  }
  card_range <- function(b, min_col, max_col, unit) {
    lo <- card_number(b, min_col)
    hi <- card_number(b, max_col)
    fmt <- function(x) format(round(x, 1), trim = TRUE)
    if (is.na(lo) && is.na(hi)) return("Not available")
    if (is.na(lo)) return(paste("Up to", fmt(hi), unit))
    if (is.na(hi)) return(paste("From", fmt(lo), unit))
    if (lo == hi) return(paste(fmt(lo), unit))
    paste0(fmt(lo), "–", fmt(hi), " ", unit)
  }
  card_score <- function(b, column) {
    n <- card_number(b, column)
    if (is.na(n)) "Not available" else paste0(n, "/5")
  }
  card_fact <- function(label, value) {
    tags$div(class = "one-card-fact",
             tags$span(label), tags$strong(value))
  }

  output$single_breed_card <- renderUI({
    req(input$selected_breed)
    d <- dog_data_clean[
      !is.na(dog_data_clean$name) &
        as.character(dog_data_clean$name) == input$selected_breed,
      , drop = FALSE
    ]
    req(nrow(d) > 0)
    b <- d[1, , drop = FALSE]

    j <- match(card_key(b$name[1]), card_key(card_images$Name))
    photo <- if (!is.na(j)) card_text(card_images$Image[j]) else ""
    photo_tag <- if (grepl("^https?://", photo)) {
      tags$img(class = "one-card-photo", src = photo,
               alt = paste("Photo of", b$name[1]))
    } else {
      tags$div(class = "one-card-placeholder", "🐕")
    }

    # All styling is scoped to this single card only.
    tags$div(
      tags$style(HTML('
        .one-breed-card { width: 100%; max-width: 335px; background: white;
          border-radius: 12px; border: 1px solid #dce7e7;
          overflow: hidden; box-shadow: 0 3px 10px #00000012;
          margin: 12px 0 20px; }
        .one-card-photo { width: 100%; height: 190px;
          object-fit: cover; display: block; }
        .one-card-placeholder { height: 190px; background: #eaf1ef;
          display: flex; justify-content: center; align-items: center;
          font-size: 56px; }
        .one-card-body { padding: 15px; }
        .one-card-group { background: #e3f5ed; color: #236853;
          display: inline-block; padding: 4px 10px; border-radius: 12px;
          font-size: 12px; }
        .one-card-body h3 { margin: 10px 0 5px; font-size: 19px; }
        .one-card-temperament { color: #536966; min-height: 28px;
          font-size: 13px; margin-bottom: 12px; }
        .one-card-fact { display: flex; justify-content: space-between;
          gap: 12px; border-bottom: 1px solid #edf1f1;
          padding: 7px 0; font-size: 13px; }
        .one-card-fact strong { text-align: right; }
        .one-card-button { display: block; cursor: pointer; text-align: center;
          background: #00a65a; color: white; border-radius: 4px;
          padding: 8px; margin-top: 12px; list-style: none; }
        .one-card-button::-webkit-details-marker { display: none; }
        .one-card-more { padding-top: 8px; font-size: 13px; }
        .one-card-more h4 { margin-top: 15px; }
      ')),
      tags$div(class = "one-breed-card",
        photo_tag,
        tags$div(class = "one-card-body",
          tags$span(class = "one-card-group", card_text(b$group)),
          tags$h3(card_text(b$name)),
          tags$p(class = "one-card-temperament", card_text(b$temperament)),
          card_fact("Lifespan", card_range(b,
            "min_life (yrs)", "max_life (yrs)", "years")),
          card_fact("Weight", card_range(b,
            "min_wt_lbs", "max_wt_lbs", "lbs")),
          card_fact("Height", card_range(b,
            "min_ht_inch", "max_ht_inch", "in")),
          tags$details(
            tags$summary(class = "one-card-button", "View Details"),
            tags$div(class = "one-card-more",
              tags$h4("About this breed"),
              tags$p(card_text(b$description)),
              tags$h4("Characteristics (1–5)"),
              card_fact("Energy", card_score(b, "energy.level")),
              card_fact("Trainability", card_score(b, "trainability.level")),
              card_fact("Good with children", card_score(b,
                "good.with.young.children")),
              card_fact("Good with dogs", card_score(b,
                "good.with.other.dogs")),
              card_fact("Shedding", card_score(b, "shedding.level"))
            )
          )
        )
      )
    )
  })
  # ----- END SINGLE BREED CARD -----


  
  # Find the CSV in either possible location
  possible_paths <- c(
    "Data/dog_data_clean.csv",
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