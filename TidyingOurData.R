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

