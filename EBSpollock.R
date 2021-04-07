# Initial VAST fitting attempt
# Using some code from Cecilia's example
library(TMB)               
library(VAST)
library(tidyverse)

packageVersion('FishStatsUtils')
packageVersion('VAST')

# Revert to old Matrix version
#devtools::install_version("Matrix", version = "1.2-18", repos = "http://cran.us.r-project.org")

# Set species 
Species <- "Gadus_chalcogrammus" #pollock

# Make folder to store results
folder <- paste0(here::here(),"/",Species)
dir.create(folder)

# Load data
# From GOA files
example_data <- load_example(data_set = "EBS_pollock") #?load_example to see species options

# STRAIGHT FROM ORACLE OPTION - no longer an example dataset
example_data2 <- example_data
example_data2$sampling_data <- oracle_data
example_data <- example_data2

Data_Geostat <- example_data$sampling_data
if(any(is.na(Data_Geostat$AreaSwept_km2))){
print("removing rows with NA for area_swept!")
  Data_Geostat <- Data_Geostat %>% 
  filter(!is.na(AreaSwept_km2))
}
# Define settings ---------------------------------------------------------
settings = make_settings( Version = "VAST_v12_0_0", #.cpp version, not software #e.g., "VAST_v12_0_0"
                          n_x = 60, #knots aka spatial resolution of our estimates
                          Region = "User", #Region = "gulf_of_alaska" , go to ?make_settings for other built in extrapolation grids
                          purpose = "index2", #changes default settings
                          ObsModel= c(2,1)#
                          ##below are default settings that can be adjusted if requested
                          #strata.limits = strata.limits
) 


# Load sampling grid ------------------------------------------------------
# source is: VASTGAP/Resources/Extrapolation Grids/EBSThorsonGrid.csv
EBSgrid <- read.csv(here::here("Extrapolation_Grids", "EBSThorsonGrid.csv"))

input_grid <- cbind(Lat = EBSgrid$Lat,
                    Lon = EBSgrid$Lon,
                    Area_km2 = EBSgrid$Shape_Area/1000000)  # Extrapolation grid area is in 
# m^2 & is converted to km^2
gc() #garbage collector


# Fit the model -----------------------------------------------------------

fit <- fit_model( "settings"= settings, #all of the settings we set up above
                  "Lat_i"= Data_Geostat[,'Lat'], #latitude of observation
                  "Lon_i"= Data_Geostat[,'Lon'],  #longitude of observation
                  "t_i"= Data_Geostat[,'Year'], #time for each observation
                  "c_i"= rep(0,nrow(Data_Geostat)), #categories for multivariate analyses
                  "b_i"= Data_Geostat[,'Catch_KG'], #in kg, raw catch or in CPUE per tow
                  "a_i"= Data_Geostat[,'AreaSwept_km2'], #sampled area for each observation
                  "v_i"= Data_Geostat[,'Vessel'], #ok to leave in because it's all "missing" in data, so no vessel effects
                  "input_grid"= input_grid, #only needed if you have a user input extrapolation grid
                  "optimize_args" =list("lower"=-Inf,"upper"=Inf), #TMB argument (?fit_tmb)
                  "working_dir" = paste0(getwd(),"/",Species,"/"))

# DOES NOT RUN

##
## Plot results
plot( fit )

## ## 
## save the VAST model
saveRDS(fit,file = paste0(getwd(),"/",Species,"/",Species,"VASTfit_60knots.RDS"))
