  # BREED EXPLORER IMAGE SERVER ---------------------------------------
  # Match the selected breed to its photo URL in breed_temperament.csv.
  selected_breed_image <- reactive({
    req(input$selected_breed)
    
    normalize_name <- function(x) {
      gsub("[^a-z0-9]", "", tolower(trimws(as.character(x))))
    }
    
    index <- match(
      normalize_name(input$selected_breed),
      normalize_name(breed_images$Name)
    )
    
    if (is.na(index)) return("")
    url <- breed_images$Image[index]
    if (is.na(url) || !grepl("^https?://", url)) return("")
    url
  })
  
  output$breed_image <- renderUI({
    photo <- selected_breed_image()
    if (!nzchar(photo)) {
      return(p("No image available for this breed."))
    }
    
    tags$img(
      src = photo,
      alt = paste("Photo of", input$selected_breed),
      style = paste(
        "width:100%; max-width:400px; height:250px;",
        "object-fit:cover; border-radius:12px;",
        "margin:15px 0; box-shadow:0 4px 10px rgba(0,0,0,0.15);"
      )
    )
  })
  
  observeEvent(input$view_photo, {
    photo <- selected_breed_image()
    if (!nzchar(photo)) {
      showNotification("No image available for this breed.", type = "warning")
      return()
    }
    
    showModal(modalDialog(
      title = input$selected_breed,
      tags$img(src = photo, alt = input$selected_breed,
               style = "width:100%;height:auto;"),
      easyClose = TRUE,
      footer = modalButton("Close"),
      size = "l"
    ))
  })
  # END BREED EXPLORER IMAGE SERVER -----------------------------------
  
  
  
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
        selected_breed_data()[["min_life..yrs."]],
        
        "–",
        
        # Maximum lifespan
        selected_breed_data()[["max_life..yrs."]],
        
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
  
