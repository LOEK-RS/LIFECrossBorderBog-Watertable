# main.R 


source("init.R")


# clean the data downloaded from element IOT

source("01-element-cleanup.R")
rm(list = ls())



# load the data, Germany only for now

gws = readRDS("data/de_gws.RDS")
gwsHeader = readRDS("data/de_gwsHeader.RDS")



ggplot(gws, aes(x = Datum, y = GWS_rel))+
  geom_point()+
  facet_wrap(.~IDshort, scales = "free_y")




source("02-aggregate_statistics.r")

# create Plots
source("vis_interactive_overview.R")

source("vis_all_time_series.R")

source("vis_overview_map.R")







# source("scripts/aggregate_statistics.r")




# create overview figures







# create app data
# ----------------------
# source(app_init.R)



