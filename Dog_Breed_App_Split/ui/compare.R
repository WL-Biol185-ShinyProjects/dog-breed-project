      tabItem(
        tabName = "compare",
        
        
        # PAGE INTRODUCTION -----------------------------------------------
        
        # Main title displayed at the top of the page
        h1("Compare Breeds"),
        
        # Brief instructions explaining what the page does
        p("Choose two breeds to see how their size, lifespan, temperament, and key traits compare."),
        
        # br() adds a small amount of vertical space
        br(),
        
        
        # ==========================================================
        # BREED SELECTION
        # ==========================================================
        
        
        div(
          class = "breed-selection-card",
          
          # Bootstrap divides each row into 12 columns.
          # Each dropdown receives 6 columns (half the row).
          
          fluidRow(
            
            # FIRST BREED SELECTOR
            column(
              width = 6,
              
              selectInput(
                inputId = "compare_breed_1",
                label = "First Breed",
                
                # Alphabetize all available breeds
                choices = sort(dog_data_clean$name),
                
                # Default to the first breed
                selected = sort(dog_data_clean$name)[1],
                
                # Fill the available column width
                width = "100%"
              )
            ),
            
            # SECOND BREED SELECTOR
            column(
              width = 6,
              
              selectInput(
                inputId = "compare_breed_2",
                label = "Second Breed",
                
                choices = sort(dog_data_clean$name),
                
                # Default to the second breed
                selected = sort(dog_data_clean$name)[2],
                
                width = "100%"
              )
            )
          ),
          
          # VS INDICATOR
          # This is decorative and does not affect the selections.
          div(
            class = "breed-vs-container",
            
            div(
              class = "breed-vs-badge",
              "VS"
            )
          )
          
        ),
        
        # Add space before the breed summary cards
        br(),
        
        
        # BREED SUMMARY CARDS ---------------------------------------------
        
        # Put the two breed summaries side-by-side
        fluidRow(
          
          
          # FIRST BREED SUMMARY
          
          box(
            width = 6,
            
            # Assign a class so we can style these cards separately
            class = "breed-summary-card",
            
            # Dynamic breed name displayed inside the card
            div(
              class = "breed-card-heading",
              h3(textOutput("compare_name_1", inline = TRUE))
            ),
            
            
            # Dynamic breed information from our server
            uiOutput("compare_info_1")
          ),
          
          # SECOND BREED SUMMARY
          
          box(
            width = 6,
            
            class = "breed-summary-card",
            
            div(
              class = "breed-card-heading",
              h3(
                textOutput("compare_name_2", inline = TRUE)
              )
            ),
            
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
