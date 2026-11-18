tabItem(
  tabName = "about",
  
  
  
  #main heading size text
  h1("Meet the Authors"), 
  
  #create horizontal row with columns
  fluidRow(
    
    column(
      width = 6,
      #third level heading size text
      h3("Brenna Luczak"),
      #display image, src is giving the source to specify image location
      img(
        src = "authors/Brenna.jpeg",
        #setting height andwidth
        height = "200px",
        width = "200px",
        #fifty makes circular by completely rounding corners, 
        #cover fills spec size, crops and maintain original proportions
        style = "border-radius: 50%; object-fit: cover;"
      ),
      #paragraph size text
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
      p("Originally from Indiana, I'm a biology major with a poverty and human capability minor 
                on the pre-med track. At home, I have a golden retriever named Arlo!")
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
      p("I grew up in Harrisonburg, Virginia and am a Biology major 
                with a minor in education. I have a golden retriever at home named Goose!")
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
      p("From Staten Island, New York, I am a Biology and Music double major on the pre-med track. 
                I love dogs and would love to have a Labrador Retriever!")
    )
    
  )
)


      