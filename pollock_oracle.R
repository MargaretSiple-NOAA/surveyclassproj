# Fetch data from oracle:
oracle_data <- read.csv(here::here("data", "pollock2.csv"))


nrow(oracle_data)
nrow(example_data$sampling_data)

names(example_data$sampling_data)
names(oracle_data)

#colnames(oracle_data) <- c("Catch_KG","Year","Vessel","AreaSwept_km2","Lat","Lon","Pass","Bottom_temp","Surface_temp")

library(tidyverse)
oracle_data <- oracle_data %>%
  select(-Bottom_temp, -Surface_temp) %>%
  filter(AreaSwept_km2 > 0) %>%
  add_column(Pass = 0) %>%
  mutate(Vessel = "missing")

# Check that they are named properly
all(names(example_data$sampling_data) == names(oracle_data))

# Can't be missing any values in a_i:
any(is.na(oracle_data$AreaSwept_km2))
any(oracle_data$AreaSwept_km2==0)
