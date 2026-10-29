library(tidyverse)
library(sf)



if(FALSE){
source("01-element-cleanup.R")
source("01-nl-cleanup.R")
}



deHeader = st_read("data/de/de_gwsHeader.gpkg")
nlHeader = st_read("data/nl/nl_gwsHeader.gpkg")


cbbHeader = bind_rows(deHeader, nlHeader)

deGws = readRDS("data/de/de_gwsDaily.RDS")
nlGws = readRDS("data/nl/nl_gwsDaily.RDS")


cbbGws = bind_rows(deGws, nlGws)

write.csv(cbbGws, "data/cbb_gwsDaily.csv", row.names = FALSE)
write_sf(cbbHeader, "data/cbb_gwsHeader.gpkg")
saveRDS(cbbGws, "data/cbb_gwsDaily.RDS")








