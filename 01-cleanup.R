library(tidyverse)
library(sf)


source("01-element-cleanup.R")
source("01-nl-cleanup.R")




deHeader = st_read("data/de_gwsHeader.gpkg")
nlHeader = st_read("data/nl_gwsHeader.gpkg")


cbbHeader = bind_rows(deHeader, nlHeader)

deGws = readRDS("data/de_gws.RDS")
nlGws = readRDS("data/nl_gws.RDS")


cbbGws = bind_rows(deGws, nlGws)


write_sf(cbbHeader, "data/cbb_gwsHeader.gpkg")
saveRDS(cbbGws, "data/cbb_gwsDaily.RDS")








