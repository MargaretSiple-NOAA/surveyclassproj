# Initial VAST fitting attempt
# Using some code from Cecilia's example
library(TMB)               
library(VAST)

packageVersion('FishStatsUtils')
packageVersion('VAST')

# Set species 
Species <- "Gadus_chalcogrammus" #pollock

# Make folder to store results
folder <- paste0(here::here(),"/",Species)
dir.create(folder)

# Load data
# From GOA files
example_data <- load_example(data_set = "EBS_pollock") #?load_example to see species options
Data_Geostat <- example_data$sampling_data


# Load sampling grid ------------------------------------------------------
# source is: VASTGAP/Resources/Extrapolation Grids/EBSThorsonGrid.csv
EBSgrid <- read.csv(here::here("Extrapolation_Grids", "EBSThorsonGrid.csv"))

input_grid <- cbind(Lat = EBSgrid$Lat,
                    Lon = EBSgrid$Lon,
                    Area_km2 = EBSgrid$Shape_Area/1000000)  # Extrapolation grid area is in 
# m^2 & is converted to km^2
gc() #garbage collector