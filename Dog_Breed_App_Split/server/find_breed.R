

# ------------------------------------------------------------
# STEP 1: CALCULATE MATCHES WHEN THE BUTTON IS CLICKED
# ------------------------------------------------------------

# eventReactive() creates a reactive calculation that only
# updates when a particular event occurs.
#
# input$pet_match refers to the submit button in the UI.
#
# Unlike a regular reactive(), eventReactive() does not
# recalculate every time someone changes a dropdown.
#
# This means users can answer all the questions before
# their results are calculated.

pet_results <- eventReactive(input$pet_match, {
  
  # Create a local copy of our dataset.
  # This prevents our calculations from modifying the
  # original dog_data_clean object.
  
  breeds <- dog_data_clean
  
  
  # ----------------------------------------------------------
  # STEP 2: IDENTIFY THE DATASET COLUMNS
  # ----------------------------------------------------------
  
  # Each questionnaire trait corresponds to a column
  # in our cleaned dog dataset.
  #
  # The name on the LEFT is our short internal name.
  # The name on the RIGHT is the actual dataset column.
  
  trait_cols <- c(
    energy = "energy.level",
    trainability = "trainability.level",
    affection = "affectionate.with.family",
    play = "playfulness.level",
    strangers = "openness.to.strangers",
    shedding = "shedding.level",
    grooming = "coat.grooming.frequency",
    barking = "barking.level"
  )
  
  
  # ----------------------------------------------------------
  # STEP 3: CHECK THAT THE REQUIRED COLUMNS EXIST
  # ----------------------------------------------------------
  
  # c() combines column names into one vector.
  #
  # unname() removes the short names from trait_cols,
  # leaving only the actual dataset column names.
  
  required_cols <- c(
    "name",
    unname(trait_cols),
    "min_wt_lbs",
    "max_wt_lbs",
    "good.with.young.children",
    "good.with.other.dogs"
  )
  
  # setdiff() identifies any required columns that
  # are missing from the dataset.
  
  missing_cols <- setdiff(required_cols, names(breeds))
  
  # validate() and need() display an error message
  # in Shiny if a required condition is not met.
  
  validate(
    need(
      length(missing_cols) == 0,
      paste(
        "Missing dataset columns:",
        paste(missing_cols, collapse = ", ")
      )
    )
  )
  
  
  # ----------------------------------------------------------
  # STEP 4: COLLECT THE USER'S ANSWERS
  # ----------------------------------------------------------
  
  # input$ accesses values selected in the questionnaire.
  #
  # as.numeric() converts the dropdown responses from
  # character strings into numbers.
  #
  # We use the same short names as trait_cols so that
  # the user's answers can be matched to dataset columns.
  
  desired <- c(
    energy = as.numeric(input$pet_energy),
    trainability = as.numeric(input$pet_trainability),
    affection = as.numeric(input$pet_affection),
    play = as.numeric(input$pet_play),
    strangers = as.numeric(input$pet_strangers),
    shedding = as.numeric(input$pet_shedding),
    grooming = as.numeric(input$pet_grooming),
    barking = as.numeric(input$pet_barking)
  )
  
  
  # ----------------------------------------------------------
  # STEP 5: ASSIGN IMPORTANCE WEIGHTS
  # ----------------------------------------------------------
  
  # Not all traits are equally important when choosing a pet.
  #
  # These weights determine how strongly each trait
  # influences the final compatibility score.
  #
  # For example:
  # Energy has weight 0.20 (20%).
  # Playfulness has weight 0.05 (5%).
  #
  # Therefore, an energy mismatch matters four times
  # as much as an equally sized playfulness mismatch.
  #
  # Size and family compatibility are added separately.
  
  weights <- c(
    energy = 0.20,
    trainability = 0.15,
    affection = 0.10,
    play = 0.05,
    strangers = 0.05,
    shedding = 0.10,
    grooming = 0.10,
    barking = 0.05
  )
  
  # These weights add to 0.80.
  #
  # The remaining possible weights are:
  # Size = 0.15
  # Family compatibility = 0.05
  #
  # Total possible weight = 1.00.
  
  
  # ----------------------------------------------------------
  # STEP 6: PREPARE TO CALCULATE SCORES
  # ----------------------------------------------------------
  
  # nrow() counts the number of breeds in the dataset.
  
  n <- nrow(breeds)
  
  # Create one starting score for each breed.
  #
  # rep(0, n) produces a vector of n zeros.
  #
  # score stores the total weighted mismatch.
  # weight_used stores how much usable information
  # was available for each breed.
  
  score <- rep(0, n)
  weight_used <- rep(0, n)
  
  
  # ----------------------------------------------------------
  # STEP 7: CREATE A HELPER FUNCTION
  # ----------------------------------------------------------
  
  # This function adds a trait's mismatch penalty to
  # the running score for each breed.
  #
  # A penalty of 0 means a perfect match for that trait.
  # A penalty of 1 means the largest possible mismatch.
  #
  # is.finite() checks that the value is a usable number.
  # Missing values (NA) are skipped.
  #
  # <<- updates variables in the surrounding calculation.
  # We use it here because this helper function needs
  # to update score and weight_used.
  
  add_penalty <- function(penalty, weight) {
    
    valid <- is.finite(penalty)
    
    score[valid] <<- score[valid] +
      penalty[valid] * weight
    
    weight_used[valid] <<- weight_used[valid] +
      weight
  }
  
  
  # ----------------------------------------------------------
  # STEP 8: COMPARE NUMERICAL TRAITS
  # ----------------------------------------------------------
  
  # A for loop repeats the same calculation for each trait.
  #
  # names(trait_cols) gives:
  # energy, trainability, affection, etc.
  
  for (trait in names(trait_cols)) {
    
    # Extract the breed's actual trait score.
    #
    # [[ ]] accesses a specific column by its name.
    #
    # as.character() followed by as.numeric()
    # helps convert stored values into numbers.
    #
    # suppressWarnings() prevents repeated conversion
    # warnings if a column contains missing values.
    
    actual <- suppressWarnings(
      as.numeric(
        as.character(breeds[[trait_cols[[trait]]]])
      )
    )
    
    
    # --------------------------------------------------------
    # CARE TRAITS: MAXIMUM ACCEPTABLE LEVEL
    # --------------------------------------------------------
    
    # Shedding, grooming, and barking are treated differently.
    #
    # Suppose someone accepts shedding up to level 3:
    #
    # Breed with shedding 2: no penalty
    # Breed with shedding 3: no penalty
    # Breed with shedding 5: penalty
    #
    # pmax(0, ...) prevents negative penalties.
    #
    # Dividing by 4 scales differences from the
    # dataset's 1-5 range to a 0-1 range.
    
    if (trait %in% c("shedding", "grooming", "barking")) {
      
      penalty <- pmax(
        0,
        actual - desired[[trait]]
      ) / 4
      
    } else {
      
      # ------------------------------------------------------
      # PERSONALITY TRAITS: CLOSEST MATCH
      # ------------------------------------------------------
      
      # For energy, affection, trainability, etc.,
      # we want the breed's score to be as close as
      # possible to the user's desired score.
      #
      # abs() calculates absolute difference.
      #
      # Example:
      # User wants energy 4.
      # Breed has energy 2.
      #
      # abs(2 - 4) / 4 = 0.50
      #
      # A breed with energy 4 receives penalty 0.
      
      penalty <- abs(
        actual - desired[[trait]]
      ) / 4
    }
    
    
    # Add this trait's weighted penalty to each breed.
    
    add_penalty(
      penalty,
      weights[[trait]]
    )
  }
  
  
  # ----------------------------------------------------------
  # STEP 9: COMPARE DOG SIZE
  # ----------------------------------------------------------
  
  # If the user selects "No preference", size is ignored.
  #
  # Otherwise, we compare each breed's typical weight
  # against the selected weight range.
  
  if (input$pet_size != "any") {
    
    # Retrieve minimum and maximum breed weights.
    
    low <- suppressWarnings(
      as.numeric(as.character(breeds$min_wt_lbs))
    )
    
    high <- suppressWarnings(
      as.numeric(as.character(breeds$max_wt_lbs))
    )
    
    # Calculate the midpoint of the breed's weight range.
    #
    # Example:
    # Minimum = 40 lb
    # Maximum = 60 lb
    # Midpoint = 50 lb
    
    midpoint <- (low + high) / 2
    
    
    # switch() chooses a weight range based on
    # the user's selected size category.
    #
    # Inf means infinity, so extra-large dogs
    # have no upper weight limit.
    
    limits <- switch(
      input$pet_size,
      small = c(0, 20),
      medium = c(20, 50),
      large = c(50, 80),
      xlarge = c(80, Inf)
    )
    
    
    # Calculate the size penalty.
    #
    # If the breed's midpoint is inside the chosen range,
    # its penalty is zero.
    #
    # If it falls outside the range, the penalty grows
    # as the distance from the range increases.
    #
    # The divisor 60 controls how quickly the penalty grows.
    
    size_penalty <- ifelse(
      midpoint < limits[1],
      
      (limits[1] - midpoint) / 60,
      
      ifelse(
        midpoint > limits[2],
        (midpoint - limits[2]) / 60,
        0
      )
    )
    
    
    # pmin(1, ...) caps the penalty at 1.
    #
    # Size receives a weight of 0.15.
    
    add_penalty(
      pmin(1, size_penalty),
      0.15
    )
  }
  
  
  # ----------------------------------------------------------
  # STEP 10: FAMILY COMPATIBILITY
  # ----------------------------------------------------------
  
  # Retrieve the user's answer to the family question.
  
  family <- input$pet_family
  
  
  # If the user selected children or both,
  # include the dataset's child compatibility score.
  
  if (family %in% c("children", "both")) {
    
    child <- suppressWarnings(
      as.numeric(
        as.character(breeds$good.with.young.children)
      )
    )
    
    # A breed with child compatibility 5 gets penalty 0.
    # A breed with compatibility 1 gets penalty 1.
    #
    # If both children and dogs were selected,
    # each receives half the total family weight.
    
    add_penalty(
      (5 - child) / 4,
      if (family == "both") 0.025 else 0.05
    )
  }
  
  
  # Repeat the calculation for compatibility with other dogs.
  
  if (family %in% c("dogs", "both")) {
    
    dogs <- suppressWarnings(
      as.numeric(
        as.character(breeds$good.with.other.dogs)
      )
    )
    
    add_penalty(
      (5 - dogs) / 4,
      if (family == "both") 0.025 else 0.05
    )
  }
  
  
  # ----------------------------------------------------------
  # STEP 11: CALCULATE FINAL COMPATIBILITY
  # ----------------------------------------------------------
  
  # We have been adding penalties, meaning lower is better.
  #
  # To make the results easier to interpret, convert the
  # weighted penalty into a score from 0 to 100.
  #
  # Formula:
  #
  # 100 * (1 - total penalty / total usable weight)
  #
  # weight_used adjusts for skipped preferences and
  # missing dataset values.
  #
  # This is a relative similarity score, not a scientifically
  # validated probability of successful dog ownership.
  
  compatibility <- ifelse(
    weight_used > 0,
    100 * (1 - score / weight_used),
    NA_real_
  )
  
  
  # Add the calculated score as a new dataset column.
  #
  # round(..., 1) keeps one decimal place.
  # pmax() and pmin() keep scores between 0 and 100.
  
  breeds$match_score <- round(
    pmax(0, pmin(100, compatibility)),
    1
  )
  
  
  # ----------------------------------------------------------
  # STEP 12: REMOVE INVALID RESULTS
  # ----------------------------------------------------------
  
  # Keep breeds with a valid score and breed name.
  #
  # drop = FALSE ensures the result remains a data frame.
  
  breeds <- breeds[
    !is.na(breeds$match_score) &
      !is.na(breeds$name),
    ,
    drop = FALSE
  ]
  
  
  # ----------------------------------------------------------
  # STEP 13: RANK BREEDS
  # ----------------------------------------------------------
  
  # order() determines the row order.
  #
  # The minus sign before match_score means descending:
  # highest scores appear first.
  #
  # Breed name is used as a tie-breaker.
  
  breeds <- breeds[
    order(-breeds$match_score, breeds$name),
    ,
    drop = FALSE
  ]
  
  
  # ----------------------------------------------------------
  # STEP 14: RETURN THE TOP FIVE
  # ----------------------------------------------------------
  
  # head(breeds, 5) selects the first five rows.
  #
  # This is the final expression in eventReactive(),
  # so Shiny returns it as the result of pet_results().
  
  head(breeds, 5)
  
})


# ============================================================
# DISPLAY RESULTS
# ============================================================


# ------------------------------------------------------------
# STEP 15: DISPLAY THE BEST MATCH
# ------------------------------------------------------------

# renderUI() generates UI elements dynamically.
#
# It connects to uiOutput("pet_best_match") in the UI file.
#
# pet_results() retrieves the five highest-scoring breeds.
#
# The first row is the highest-ranked breed.

output$pet_best_match <- renderUI({
  
  matches <- pet_results()
  
  # Check that at least one breed was returned.
  
  validate(
    need(
      nrow(matches) > 0,
      "No breeds could be scored."
    )
  )
  
  # tags$div() creates a container for the result.
  #
  # matches$name[1] retrieves the first breed name.
  # matches$match_score[1] retrieves its score.
  #
  # paste() combines text with a variable.
  # sprintf() formats the score to one decimal place.
  
  tags$div(
    
    h2(
      paste("Your best match:", matches$name[1]),
      style = "color: #594637;"
    ),
    
    p(
      sprintf(
        "Compatibility score: %.1f / 100",
        matches$match_score[1]
      ),
      
      style = "
        color: #A47755;
        font-size: 18px;
        font-weight: bold;
      "
    ),
    
    p(
      paste(
        "Explore your other top matches below",
        "to compare your options."
      )
    )
  )
})


# ------------------------------------------------------------
# STEP 16: DISPLAY THE TOP FIVE MATCHES
# ------------------------------------------------------------

# renderTable() creates a table using an R data frame.
#
# It connects to tableOutput("pet_other_matches")
# in the UI file.
#
# data.frame() creates a smaller results table with
# only the columns we want users to see.

output$pet_other_matches <- renderTable({
  
  matches <- pet_results()
  
  data.frame(
    
    "Breed" = matches$name,
    
    "Compatibility score" = paste0(
      matches$match_score,
      "/100"
    ),
    
    # Prevent R from changing column headings.
    check.names = FALSE
  )
  
},

# Display options for the table:
striped = TRUE,
bordered = FALSE,
spacing = "m"
)