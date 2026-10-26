
#Reading our Data 



#Libraries

library(dplyr)
library(tidyverse)
library(ggplot2)
library(lubridate)
library(readxl)

#Making our data from .xlsx -> .txt

dog_data_working <- read_excel("dog_data_working.xlsx")

#Lowercasing all Column Names

colnames(dog_data_working) <- tolower(colnames(dog_data_working))

#Removing Certain Columns

dog_data_clean <- subset(dog_data_working, select = -c(umap1, umap2, cluster, coat.type, popularity))

#Removing the _ from the clus_name column

clus_name_fixed <- gsub(pattern = "_", replacement = " ", x = dog_data_clean$clus_name, fixed = TRUE)

dog_data_clean$clus_name <- clus_name_fixed

#Changing cm to inches 

dog_data_clean$min_ht_inch <- ((dog_data_clean$`min_ht (cm)`)/2.54)
dog_data_clean$`min_ht (cm)` <- NULL

dog_data_clean$max_ht_inch <- ((dog_data_clean$`max_ht (cm)`)/2.54)
dog_data_clean$`max_ht (cm)` <- NULL

dog_data_clean$min_wt_lbs <- ((dog_data_clean$`min_wt (kg)`)*2.205)
dog_data_clean$`min_wt (kg)` <- NULL

dog_data_clean$max_wt_lbs <- ((dog_data_clean$`max_wt (kg)`)*2.205)
dog_data_clean$`max_wt (kg)` <- NULL

#Converting 0s into NA

dog_data_clean$`min_life (yrs)`[dog_data_clean$`min_life (yrs)` == 0] <- NA
dog_data_clean$`max_life (yrs)`[dog_data_clean$`max_life (yrs)` == 0] <- NA

dog_data_clean$max_wt_lbs[dog_data_clean$max_wt_lbs == 0] <- NA
dog_data_clean$min_wt_lbs[dog_data_clean$min_wt_lbs == 0] <- NA

#Saving to Data Folder

write.csv(dog_data_clean, "Data/dog_data_clean.csv", row.names = FALSE)


breed_temperament <- read.csv("Data/breed_temperament.csv")

fci_breeds_clean <- read.csv("Data/fci_breeds_clean.csv")

moviesAnalyzed <- read.csv("Data/moviesAnalyzed_cleaned.csv")

breed_rank_all <- read.csv("Data/breed_rank_all.csv")

