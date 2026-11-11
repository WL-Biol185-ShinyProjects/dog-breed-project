      tabItem(
        tabName = "find_breed",
      
        # ----------------------------------------------------------
        # PAGE CONTAINER
        # ----------------------------------------------------------
        # div() groups elements together.
        # style controls appearance using CSS.
        # We use the same colors as the What Dog Am I? tab.
        
        div(
          style = "
      background-color: #F5F1EB;
      padding: 30px;
      border-radius: 15px;
    ",
          
          # --------------------------------------------------------
          # PAGE HEADER
          # --------------------------------------------------------
          
          div(
            style = "
        text-align: center;
        padding: 20px;
        margin-bottom: 20px;
      ",
            
            h1(
              "🐾 Find Your Perfect Pup",
              style = "
          color: #594637;
          font-weight: bold;
        "
            ),
            
            p(
              paste(
                "Tell us about your lifestyle and preferences",
                "to discover your best dog breed matches!"
              ),
              style = "
          color: #75685D;
          font-size: 16px;
        "
            )
          ),
          
          # --------------------------------------------------------
          # SECTION 1: LIFESTYLE
          # --------------------------------------------------------
          # Each section is placed in a white card.
          #
          # selectInput() creates a dropdown menu.
          #
          # inputId: The name used to access the answer in server.
          # label: The question shown to the user.
          # choices: Visible answer labels and their stored values.
          # selected: The default answer.
          #
          # Most traits are scored from 1 to 5, matching the dataset.
          
          div(
            style = "
        background-color: white;
        padding: 20px;
        border-radius: 12px;
        margin-bottom: 15px;
        border: 1px solid #E5DED5;
      ",
            
            h3("1. Your Lifestyle",
               style = "color: #594637;"),
            
            # QUESTION 1: ENERGY LEVEL
            selectInput(
              inputId = "pet_energy",
              label = "How active would you like your dog to be?",
              
              choices = c(
                "Very relaxed" = 1,
                "Mostly laid-back" = 2,
                "Moderately active" = 3,
                "Very active" = 4,
                "Extremely energetic" = 5
              ),
              
              selected = 3
            ),
            
            # QUESTION 2: SIZE
            # Size uses categories rather than the 1-5 scale.
            # We will compare these categories with breed weights.
            
            selectInput(
              inputId = "pet_size",
              label = "What size dog would you prefer?",
              
              choices = c(
                "No preference" = "any",
                "Small (under 20 lb)" = "small",
                "Medium (20-50 lb)" = "medium",
                "Large (50-80 lb)" = "large",
                "Extra large (over 80 lb)" = "xlarge"
              ),
              
              selected = "any"
            ),
            
            # QUESTION 3: TRAINABILITY
            selectInput(
              inputId = "pet_trainability",
              label = "How trainable would you like your dog to be?",
              
              choices = c(
                "Independent is fine" = 1,
                "Somewhat responsive" = 2,
                "Moderately trainable" = 3,
                "Easy to train" = 4,
                "Extremely eager to learn" = 5
              ),
              
              selected = 3
            )
          ),
          
          # --------------------------------------------------------
          # SECTION 2: PERSONALITY
          # --------------------------------------------------------
          
          div(
            style = "
        background-color: white;
        padding: 20px;
        border-radius: 12px;
        margin-bottom: 15px;
        border: 1px solid #E5DED5;
      ",
            
            h3("2. Your Ideal Dog's Personality",
               style = "color: #594637;"),
            
            # QUESTION 4: AFFECTION
            selectInput(
              inputId = "pet_affection",
              label = "How affectionate should your dog be?",
              
              choices = c(
                "Very independent" = 1,
                "Somewhat independent" = 2,
                "A balance" = 3,
                "Very affectionate" = 4,
                "A total cuddle bug!" = 5
              ),
              
              selected = 3
            ),
            
            # QUESTION 5: PLAYFULNESS
            selectInput(
              inputId = "pet_play",
              label = "How playful should your dog be?",
              
              choices = c(
                "Very calm" = 1,
                "Occasionally playful" = 2,
                "Moderately playful" = 3,
                "Very playful" = 4,
                "Always ready for fun!" = 5
              ),
              
              selected = 3
            ),
            
            # QUESTION 6: STRANGER FRIENDLINESS
            selectInput(
              inputId = "pet_strangers",
              label = "How should your dog behave around strangers?",
              
              choices = c(
                "Reserved" = 1,
                "Somewhat cautious" = 2,
                "Neutral" = 3,
                "Friendly" = 4,
                "Extremely outgoing" = 5
              ),
              
              selected = 3
            ),
            
            # QUESTION 7: FAMILY COMPATIBILITY
            # These answers are categories, not numerical scores.
            # The server will use the corresponding dataset columns.
            
            selectInput(
              inputId = "pet_family",
              label = paste(
                "Will your dog regularly interact",
                "with children or other dogs?"
              ),
              
              choices = c(
                "Neither" = "neither",
                "Children" = "children",
                "Other dogs" = "dogs",
                "Both children and dogs" = "both"
              ),
              
              selected = "neither"
            )
          ),
          
          # --------------------------------------------------------
          # SECTION 3: CARE PREFERENCES
          # --------------------------------------------------------
          # These questions measure how much of each characteristic
          # the user is willing to accommodate.
          #
          # Unlike personality traits, LESS shedding, grooming,
          # or barking than requested should not be penalized.
          
          div(
            style = "
        background-color: white;
        padding: 20px;
        border-radius: 12px;
        margin-bottom: 15px;
        border: 1px solid #E5DED5;
      ",
            
            h3("3. Care & Maintenance",
               style = "color: #594637;"),
            
            # QUESTION 8: SHEDDING
            selectInput(
              inputId = "pet_shedding",
              label = "How much shedding are you comfortable with?",
              
              choices = c(
                "Very little" = 1,
                "A little" = 2,
                "Moderate" = 3,
                "Quite a bit" = 4,
                "Any amount" = 5
              ),
              
              selected = 3
            ),
            
            # QUESTION 9: GROOMING
            selectInput(
              inputId = "pet_grooming",
              label = "How much grooming are you willing to do?",
              
              choices = c(
                "Minimal" = 1,
                "Occasional brushing" = 2,
                "Regular brushing" = 3,
                "Frequent grooming" = 4,
                "High-maintenance grooming is fine" = 5
              ),
              
              selected = 3
            ),
            
            # QUESTION 10: BARKING
            selectInput(
              inputId = "pet_barking",
              label = "How much barking are you comfortable with?",
              
              choices = c(
                "Very little" = 1,
                "Occasional barking" = 2,
                "Moderate barking" = 3,
                "Fairly vocal" = 4,
                "Any amount" = 5
              ),
              
              selected = 3
            )
          ),
          
          # --------------------------------------------------------
          # SUBMIT BUTTON
          # --------------------------------------------------------
          # actionButton() creates a clickable button.
          #
          # "pet_match" is the input ID.
          # The server watches input$pet_match and calculates
          # matches when the user clicks the button.
          
          div(
            style = "
        text-align: center;
        padding: 20px;
      ",
            
            actionButton(
              inputId = "pet_match",
              label = "🐾 Find My Match!",
              
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
          
          # --------------------------------------------------------
          # RESULTS SECTION
          # --------------------------------------------------------
          # uiOutput() creates a space that the server can fill
          # with dynamically generated text or other UI elements.
          #
          # tableOutput() creates a space for a results table.
          #
          # These IDs must match the output IDs in the server.
          
          div(
            style = "
        background-color: white;
        padding: 25px;
        border-radius: 12px;
        margin-top: 15px;
        border: 1px solid #E5DED5;
      ",
            
            # Best matching breed
            uiOutput("pet_best_match"),
            
            # Other recommended breeds
            h3(
              "🐶 Your Top 5 Matches",
              style = "color: #594637;"
            ),
            
            tableOutput("pet_other_matches"),
            
            p(
              paste(
                "Matches are based on breed-level characteristics.",
                "Individual dogs may vary in personality and behavior."
              ),
              style = "
          color: #75685D;
          font-size: 13px;
        "
            )
          )
        )
      )
      
      