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
          
          
          # INTERACTIVE TRAIT COMPARISON GRAPH --------------------------
          
          plotlyOutput(
            outputId = "trait_comparison",
            height = "500px"
          ),
          
          # KEY DIFFERENCE SUMMARY -------------------------------------
          # Displays a short takeaway below the graph.
          # The text will update when either breed or category changes.
          uiOutput("trait_difference_summary")
          
        )
      )
