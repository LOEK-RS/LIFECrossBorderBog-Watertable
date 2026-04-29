# main.R 


source("init.R")


# clean the data downloaded from element IOT

## this produces the files 
##  - gws.RDS with the actual water table depth data for de and nl
##  - gwsHeader.RDS with the metadata of the loggers for de and nl

if(FALSE){
  source("scripts/de_data_cleaning.R")
  source("scripts/nl_data_cleaning.R")
  rm(list = ls())
}


# load combined dataset

source("scripts/load_data.R")

source("scripts/aggregate_statistics.r")

gwsStats
mapview(gwsStats, zcol = "GWS_abs_defizit")


# create overview figures







# create app data
# ----------------------
# source(app_init.R)



