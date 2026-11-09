      tabItem(
        tabName = "about",
        
    
          
        h1("About this Project"),
        p("Made by four dog-loving seniors enrolled in an introductory 
          data science course at Washginton and Lee University, this app seeks to
          provide users a fun way to interact with data regarding dogs."),
        h2("Meet the Authors"), 

          
          fluidRow(
            
            column(
              width = 6,
              h3("Brenna Luczak"),
              img(
                src = "authors/Brenna.jpeg",
                height = "200px",
                width = "200px",
                style = "border-radius: 50%; object-fit: cover;"
              ),
              p("From Richmond, Virginia, I study biology and philosophy on the 
                pre-optometry track. I have three dogs who reside at my parents'
                house!")
            ),
            
            column(
              width = 6,
              h3("Lydia Harvey"),
              img(
                src = "authors/Lydia.jpeg",
                height = "200px",
                width = "200px",
                style = "border-radius: 50%; object-fit: cover;"
              ),
              p("Write Author 2's biography here.")
            ),
            
            column(
              width = 6,
              h3("Loren Hertzler"),
              img(
                src = "authors/Loren.jpeg",
                height = "200px",
                width = "200px",
                style = "border-radius: 50%; object-fit: cover;"
              ),
              p("Write Author 2's biography here.")
            ),
            
            column(
              width = 6,
              h3("Daniel Volodarsky"),
              img(
                src = "authors/Danny.JPG",
                height = "200px",
                width = "200px",
                style = "border-radius: 50%; object-fit: cover;"
              ),
              p("Write Author 2's biography here.")
            )
            
          )
        )

      