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
        
        # Displays the selected breed photo; click to see it larger.
        uiOutput("breed_image"),
        actionButton("view_photo", "Enlarge Photo"),
        
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
        
      )
