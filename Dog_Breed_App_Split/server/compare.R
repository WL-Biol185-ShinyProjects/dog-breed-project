  # COMPARE BREEDS ----------------------------------------------------
  
  
  # SELECT DATA FOR BREED 1 ------------------------------------------
  
  # reactive() creates an object that automatically updates
  # whenever the user changes the first breed dropdown.
  compare_breed_1_data <- reactive({
    
    # Start with the complete dog dataset
    dog_data_clean |>
      
      # filter() keeps only the row where the breed name
      # matches the user's selection in the first dropdown.
      #
      # input$compare_breed_1 comes from:
      # selectInput(inputId = "compare_breed_1") in the UI.
      filter(name == input$compare_breed_1)
    
  })
  
  
  # SELECT DATA FOR BREED 2 ------------------------------------------
  
  # This does exactly the same thing for the second dropdown.
  compare_breed_2_data <- reactive({
    
    dog_data_clean |>
      
      # Keep only the selected second breed
      filter(name == input$compare_breed_2)
    
  })
  
  # PHYSICAL CHARACTERISTICS DATA -------------------------------
  
  # reactive() automatically updates this dataset whenever
  # either selected breed changes.
  physical_comparison_data <- reactive({
    
    # Retrieve the selected breeds using our existing functions.
    breed1 <- compare_breed_1_data()
    breed2 <- compare_breed_2_data()
    
    # Make sure both breeds have been found before proceeding.
    req(nrow(breed1) > 0, nrow(breed2) > 0)
    
    # Create a small dataset for our future visualization.
    data.frame(
      
      # Identify the two breeds being compared.
      Breed = rep(
        c(input$compare_breed_1, input$compare_breed_2),
        each = 3
      ),
      
      # Label the three measurements for each breed.
      Measurement = rep(
        c("Height", "Weight", "Lifespan"),
        times = 2
      ),
      
      # Minimum recorded values for each measurement.
      Minimum = c(
        breed1$min_ht_inch,
        breed1$min_wt_lbs,
        breed1[["min_life..yrs."]],
        
        breed2$min_ht_inch,
        breed2$min_wt_lbs,
        breed2[["min_life..yrs."]]
      ),
      
      # Maximum recorded values for each measurement.
      Maximum = c(
        breed1$max_ht_inch,
        breed1$max_wt_lbs,
        breed1[["max_life..yrs."]],
        
        breed2$max_ht_inch,
        breed2$max_wt_lbs,
        breed2[["max_life..yrs."]]
      )
    )
  })
  
  # PHYSICAL CHARACTERISTICS VISUALIZATIONS ---------------------
  
  # This function creates a range chart for any measurement.
  # It accepts the measurement name and the x-axis label.
  make_range_plot <- function(data, measurement, axis_label) {
    
    # Keep only the rows for the requested measurement.
    plot_data <- data |>
      dplyr::filter(Measurement == measurement)
    
    # Define consistent colors for the first and second breed.
    breed_colors <- c("#398A93", "#D58A63")
    
    # Begin with an empty Plotly graph.
    p <- plotly::plot_ly()
    
    # Add one range line for each selected breed.
    for (i in seq_len(nrow(plot_data))) {
      
      breed <- plot_data$Breed[i]
      min_value <- plot_data$Minimum[i]
      max_value <- plot_data$Maximum[i]
      
      # Text displayed when users hover over either endpoint.
      hover_label <- paste0(
        breed, "<br>",
        measurement, ": ",
        min_value, "–", max_value,
        " ", axis_label
      )
      
      # Draw the range and its two endpoints.
      p <- p |>
        plotly::add_trace(
          x = c(min_value, max_value),
          y = c(breed, breed),
          
          type = "scatter",
          mode = "lines+markers",
          
          line = list(
            color = breed_colors[i],
            width = 5
          ),
          
          marker = list(
            color = breed_colors[i],
            size = 11
          ),
          
          text = c(hover_label, hover_label),
          hoverinfo = "text",
          showlegend = FALSE
        )
    }
    
    # Apply consistent formatting to every chart.
    p |>
      plotly::layout(
        xaxis = list(
          title = axis_label,
          rangemode = "tozero",
          zeroline = FALSE
        ),
        
        yaxis = list(
          title = "",
          categoryorder = "array",
          categoryarray = rev(plot_data$Breed)
        ),
        
        showlegend = FALSE,
        
        paper_bgcolor = "rgba(0,0,0,0)",
        plot_bgcolor = "rgba(0,0,0,0)",
        
        margin = list(l = 110, r = 30, t = 20, b = 50)
      )
  }
  
  # HEIGHT CHART ------------------------------------------------
  
  output$height_comparison <- plotly::renderPlotly({
    
    make_range_plot(
      physical_comparison_data(),
      "Height",
      "inches"
    )
    
  })
  
  # WEIGHT CHART ------------------------------------------------
  
  output$weight_comparison <- plotly::renderPlotly({
    
    make_range_plot(
      physical_comparison_data(),
      "Weight",
      "lbs"
    )
    
  })
  
  # LIFESPAN CHART ----------------------------------------------
  
  output$lifespan_comparison <- plotly::renderPlotly({
    
    make_range_plot(
      physical_comparison_data(),
      "Lifespan",
      "years"
    )
    
  })
  
  # BREED CARD TITLES -------------------------------------------------
  
  
  # renderText() creates text that can be sent to a textOutput()
  # element in the UI.
  output$compare_name_1 <- renderText({
    
    # Display whatever breed is currently selected
    # in the first dropdown.
    input$compare_breed_1
    
  })
  
  
  # Do the same thing for Breed 2.
  output$compare_name_2 <- renderText({
    
    input$compare_breed_2
    
  })
  
  # BREED 1 INFORMATION CARD -----------------------------------------
  
  # renderUI() allows us to create several pieces of formatted
  # information and send them together to uiOutput("compare_info_1").
  output$compare_info_1 <- renderUI({
    
    # Save the selected breed's row to a shorter variable called breed.
    #
    # This means we can write breed$group instead of repeatedly
    # writing compare_breed_1_data()$group.
    breed <- compare_breed_1_data()
    
    
    # tagList() groups several UI elements together so they
    # can all be returned by renderUI().
    tagList(
      
      
      # BREED GROUP
      
      # h4() creates a small heading
      h4("Breed Group"),
      
      # p() displays the breed's group as regular paragraph text
      p(breed$group),
      
      
      # TEMPERAMENT
      
      h4("Temperament"),
      
      p(breed$temperament),
      
      
      # LIFESPAN
      
      h4("Typical Lifespan"),
      
      # paste0() joins several pieces of text together
      # without automatically adding spaces.
      p(
        paste0(
          
          # Minimum lifespan from the dataset
          breed[["min_life..yrs."]],
          
          
          # Add a dash between minimum and maximum
          "–",
          
          # Maximum lifespan
          breed[["max_life..yrs."]],
          
          # Add the unit
          " years"
        )
      ),
      
      
      # WEIGHT
      
      h4("Weight"),
      
      p(
        paste0(
          
          # round(..., 1) rounds the weight to one decimal place
          # so we don't display long decimal values.
          round(breed$min_wt_lbs, 1),
          
          "–",
          
          round(breed$max_wt_lbs, 1),
          
          " lbs"
        )
      ),
      
      
      # HEIGHT
      
      h4("Height"),
      
      p(
        paste0(
          
          round(breed$min_ht_inch, 1),
          
          "–",
          
          round(breed$max_ht_inch, 1),
          
          " inches"
        )
      )
      
    )
    
  })
  
  
  # BREED 2 INFORMATION CARD -----------------------------------------
  
  # This works exactly like the Breed 1 information card,
  # but uses compare_breed_2_data().
  output$compare_info_2 <- renderUI({
    
    # Store the selected second breed's row in a shorter variable
    breed <- compare_breed_2_data()
    
    
    # Combine all of the information into one UI output
    tagList(
      
      
      # BREED GROUP
      
      h4("Breed Group"),
      
      p(breed$group),
      
      
      # TEMPERAMENT
      
      h4("Temperament"),
      
      p(breed$temperament),
      
      
      # LIFESPAN
      
      h4("Typical Lifespan"),
      
      p(
        paste0(
          breed[["min_life..yrs."]],
          "–",
          breed[["max_life..yrs."]],
          " years"
        )
      ),
      
      
      # WEIGHT
      
      h4("Weight"),
      
      p(
        paste0(
          round(breed$min_wt_lbs, 1),
          "–",
          round(breed$max_wt_lbs, 1),
          " lbs"
        )
      ),
      
      
      # HEIGHT
      
      h4("Height"),
      
      p(
        paste0(
          round(breed$min_ht_inch, 1),
          "–",
          round(breed$max_ht_inch, 1),
          " inches"
        )
      )
      
    )
    
  })
  
  # TRAIT COMPARISON DATA --------------------------------------------
  
  # Create the data that will be used in the comparison graph.
  #
  # Because this is reactive(), it will automatically recalculate
  # whenever:
  #   1. Breed 1 changes
  #   2. Breed 2 changes
  #   3. The trait category changes
  comparison_traits <- reactive({
    
    
    # Store each selected breed's row in a shorter variable
    breed1 <- compare_breed_1_data()
    breed2 <- compare_breed_2_data()
    
    
    # PERSONALITY TRAITS ---------------------------------------------
    
    # If the user chooses "Personality" from the dropdown,
    # compare traits related to activity and behavior.
    if (input$trait_category == "Personality") {
      
      # Create readable labels for the graph
      trait_names <- c(
        "Energy",
        "Trainability",
        "Playfulness",
        "Adaptability",
        "Mental Stimulation"
      )
      
      # These are the actual column names in our dataset
      trait_columns <- c(
        "energy.level",
        "trainability.level",
        "playfulness.level",
        "adaptability.level",
        "mental.stimulation.needs"
      )
      
    }
    
    
    # SOCIAL TRAITS --------------------------------------------------
    
    # If the user chooses "Social", compare characteristics
    # related to interactions with people and other dogs.
    else if (input$trait_category == "Social") {
      
      trait_names <- c(
        "Family Affection",
        "Good With Children",
        "Good With Dogs",
        "Stranger Friendliness",
        "Protectiveness"
      )
      
      trait_columns <- c(
        "affectionate.with.family",
        "good.with.young.children",
        "good.with.other.dogs",
        "openness.to.strangers",
        "watchdog.protective.nature"
      )
      
    }
    
    
    # CARE & LIFESTYLE TRAITS ----------------------------------------
    
    # Otherwise, the user selected "Care & Lifestyle".
    else {
      
      trait_names <- c(
        "Shedding",
        "Grooming Needs",
        "Drooling",
        "Barking"
      )
      
      trait_columns <- c(
        "shedding.level",
        "coat.grooming.frequency",
        "drooling.level",
        "barking.level"
      )
      
    }
    
    
    # CREATE GRAPH DATA ----------------------------------------------
    
    # data.frame() creates a small temporary dataset specifically
    # for our graph.
    data.frame(
      
      # Readable trait names displayed on the graph
      Trait = trait_names,
      
      
      # Extract the selected columns for Breed 1.
      #
      # breed1[1, trait_columns] selects:
      #   - row 1
      #   - the trait columns selected above
      #
      # unlist() turns those values into a simple vector.
      #
      # as.numeric() ensures Plotly receives numbers.
      Breed1 = as.numeric(
        unlist(breed1[1, trait_columns])
      ),
      
      
      # Do exactly the same thing for Breed 2
      Breed2 = as.numeric(
        unlist(breed2[1, trait_columns])
      )
      
    )
    
  })
  
  
  # INTERACTIVE TRAIT COMPARISON GRAPH -------------------------------
  
  # renderPlotly() creates the interactive graph that is displayed
  # by plotlyOutput("trait_comparison") in the UI.
  output$trait_comparison <- renderPlotly({
    
    
    # Retrieve the comparison dataset created above
    comparison_data <- comparison_traits()
    
    
    # Reverse the order of the trait names.
    #
    # Plotly draws horizontal bar charts from bottom to top,
    # so reversing the levels makes the traits appear in the
    # same order that we listed them in our code.
    comparison_data$Trait <- factor(
      comparison_data$Trait,
      levels = rev(comparison_data$Trait)
    )
    
    
    plot_ly(
      
      # Tell Plotly which dataset to use.
      # We are NOT creating any bars yet.
      data = comparison_data,
      
      # Trait names will appear on the vertical axis.
      y = ~Trait
      
    ) |>
      
      
      # BREED 1 BARS -------------------------------------------------
    
    add_trace(
      type = "bar", orientation = "h",
      
      # Breed 1's rating determines the length of each bar
      x = ~Breed1,
      
      # Breed 1 Bar Color to Muted Teal
      
      marker = list(color = "#398A93"),
      
      # Use the selected breed's name in the legend
      name = input$compare_breed_1,
      
      # Create custom hover text.
      #
      # paste0() combines the breed name, trait name,
      # and score into one message.
      text = ~paste0(
        input$compare_breed_1,
        "<br>",
        Trait,
        ": ",
        Breed1,
        " / 5"
      ),
      
      # Do not print the text directly on the bars.
      # Users can still see this information when they hover.
      textposition = "none",
      
      hoverinfo = "text"
      
      
    ) |>
      
      
      # BREED 2 BARS -------------------------------------------------
    
    add_trace(
      type = "bar", orientation = "h",
      
      x = ~Breed2,
      
      # Set Breed 2's bar color to soft terracotta
      
      marker = list(color = "#D58A63"),
      
      name = input$compare_breed_2,
      
      text = ~paste0(
        input$compare_breed_2,
        "<br>",
        Trait,
        ": ",
        Breed2,
        " / 5"
      ),
      
      # Do not print the text directly on the bars.
      # Users can still see this information when they hover.
      textposition = "none",
      
      hoverinfo = "text"
      
      
    ) |>
      
      
      # GRAPH LAYOUT -------------------------------------------------
    
    layout(
      
      # Put the two breeds beside each other for each trait
      barmode = "group",
      
      # Space between different trait categories
      bargap = 0.35,
      
      # Small space between the two breeds within each category
      bargroupgap = 0.08,
      
      
      # Remove unnecessary empty space around the graph
      margin = list(
        l = 140,
        r = 30,
        t = 45,
        b = 50
      ),
      
      
      # HORIZONTAL RATING AXIS
      xaxis = list(
        
        # Axis title
        title = "Trait Rating",
        
        # Every trait is measured from 1 to 5
        range = c(0, 5),
        
        # Display whole-number ratings
        tickvals = c(1, 2, 3, 4, 5),
        
        # Add subtle grid lines to make comparisons easier
        showgrid = TRUE,
        
        # Remove the heavy axis line
        zeroline = FALSE
      ),
      
      
      # VERTICAL TRAIT AXIS
      yaxis = list(
        
        # No additional title is necessary
        title = "",
        
        # Prevent Plotly from automatically rearranging
        # our factor levels
        categoryorder = "array",
        
        categoryarray = levels(comparison_data$Trait)
      ),
      
      
      # LEGEND
      legend = list(
        
        # Keep breed names next to each other
        orientation = "h",
        
      # Center the legend horizontally
      
      x = 0.5,
      xanchor = "center",
      
      #Position the legend just above the bars
      y = 1.02,
      yanchor = "bottom"
      
      ),
      
      
      # Make the graph background transparent so that it
      # blends into the dashboard card
      paper_bgcolor = "rgba(0,0,0,0)",
      plot_bgcolor = "rgba(0,0,0,0)"
      
    ) |>
      
      
      # config() changes Plotly's interactive controls
      config(
        
        # Remove the Plotly logo from the toolbar
        displaylogo = FALSE,
        
        # Remove buttons that aren't useful for this graph
        modeBarButtonsToRemove = c(
          "zoom2d",
          "pan2d",
          "select2d",
          "lasso2d",
          "autoScale2d"
        )
      )
    
  })
  
  
