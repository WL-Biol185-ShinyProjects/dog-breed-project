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
      )
      
