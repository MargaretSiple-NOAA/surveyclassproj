# Initial VAST fitting attempt
# Using some code from Cecilia's example
library(TMB)               
library(VAST)

packageVersion('FishStatsUtils')
packageVersion('VAST')

# Set species 
Species <- "Hippoglossoides_elassodon" #FHS

# Make folder to store results
folder <- paste0(here::here(),"/",Species)
dir.create(folder)

# Load data
# From GOA files
example_data <- load_example(data_set = "GOA_Pcod") #?load_example to see species options
Data_Geostat <- example_data$sampling_data


# Load sampling grid ------------------------------------------------------
# source is: VASTGAP/Resources/Extrapolation Grids/EBSThorsonGrid.csv
EBSgrid <- read.csv(here::here("Extrapolation_Grids", "EBSThorsonGrid.csv"))

