# Fetch data from oracle:
oracle_data <- read.csv(here::here("data", "pollock.csv"))


nrow(oracle_data)
nrow(example_data$sampling_data)

names(example_data$sampling_data)
names(oracle_data)

colnames(oracle_data) <- c("Catch_KG","Year","Vessel","AreaSwept_km2","Lat","Lon","Pass","Bottom_temp","Surface_temp")

library(tidyverse)
oracle_data <- oracle_data %>%
  select(-Bottom_temp, -Surface_temp)

names(example_data$sampling_data)
names(oracle_data)