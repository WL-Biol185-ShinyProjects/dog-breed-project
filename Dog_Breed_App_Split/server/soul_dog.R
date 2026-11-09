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
  
