#Reading our Data 



#Libraries

library(dplyr)
library(tidyverse)
library(ggplot2)
library(lubridate)
library(readxl)

#Making our data from .xlsx -> .txt

dog_data <- read_excel("dog_data_working.xlsx")



#Lowercasing all Column Names

colnames(dog_data) <- tolower(colnames(dog_data))
