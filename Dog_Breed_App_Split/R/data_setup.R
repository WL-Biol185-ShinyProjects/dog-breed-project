# LOAD DATA -------------------------------------------------------

# Read the cleaned dog breed CSV into R.
#
# stringsAsFactors = FALSE keeps text columns as text rather
# than automatically converting them into categories.
#
# fileEncoding tells R how the text in this CSV is encoded.
#
# check.names = TRUE converts unusual column names into
# R-friendly names. For example:
# "min_life (yrs)" becomes "min_life..yrs."
# Work whether the app is launched from the project root or Data/.
find_data_file <- function(filename) {
  candidates <- c(filename, file.path("Data", filename))
  existing <- candidates[file.exists(candidates)]
  if (length(existing) == 0) {
    stop(paste("Missing data file:", filename,
               "(looked in the app folder and Data/)"))
  }
  existing[1]
}

dog_data_clean <- read.csv(
  find_data_file("dog_data_clean.csv"),
  stringsAsFactors = FALSE,
  fileEncoding = "UTF-8",
  check.names = TRUE
)

# Image URLs used on the Breed Explorer page.
breed_images <- read.csv(
  find_data_file("breed_temperament.csv"),
  stringsAsFactors = FALSE,
  fileEncoding = "UTF-8",
  check.names = FALSE
)


# Fix weird characters that appeared in some breed descriptions
dog_data_clean$description <- gsub(
  "‚Äî",
  "—",
  dog_data_clean$description,
  fixed = TRUE
)


# Create a second name for the same dataset for use
# in the Soul Dog questionnaire
dog_data <- dog_data_clean

# Traits used by the Soul Dog questionnaire
traits <- c(
  "energy.level",
  "affectionate.with.family",
  "openness.to.strangers",
  "playfulness.level",
  "adaptability.level",
  "trainability.level",
  "mental.stimulation.needs",
  "watchdog.protective.nature"
)

# Convert questionnaire traits to numeric values
for (trait in traits) {
  
  dog_data[[trait]] <- suppressWarnings(
    as.numeric(as.character(dog_data[[trait]]))
  )
  
}

