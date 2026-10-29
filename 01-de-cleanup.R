# Element Export consistency


library(tidyverse)
library(sf)

element_files = list.files("raw/element_exports/", full.names = TRUE, pattern = ".csv$")

element = lapply(element_files, function(x){

 f = read.csv(x, skip = 1)
 f$MS.Nr = NULL
  
  return(f)


})


# Combine all measurements to one dataframe and remove duplicated rows
# These rows stem from overlapping export dates
element = bind_rows(element) |> distinct()



## MEASUREMENT TABLE

element_measurements = element |> select(
  Datum_Zeit,
  GWS_abs,
  GWS_rel,
  GWS_Diff,
  Abstand,
  SRSSI_Signalstaerke,
  SRC_Echoguete,
  ID
)


element_measurements$GWS_abs = round(element_measurements$GWS_abs, digits = 0)




## META TABLE

element_meta = element |> select(
  ID,
  Easting,
  Northing,
  Hoehe_absolut,
  Polder.Nummer,
  GWS_Soll,
  gueltig_ab
) |> distinct()


element_meta = element_meta |> filter(!is.na(Easting)) |> filter(!is.na(Hoehe_absolut))


element_meta$IDshort = str_sub(element_meta$ID, -4)
element_meta = element_meta |> rename(GWS_Soll_abs = GWS_Soll)
element_meta = element_meta |> rename(Hoehe_abs = Hoehe_absolut)
element_meta$Betreiber = "Zwillbrock"


# PATCH: 244E7B0000004584 is in twice, it has wrong coordinates
element_meta = element_meta |> filter(Northing != 359866.777)

# PATCH: 408a has wrong unit
element_meta$GWS_Soll_abs[element_meta$GWS_Soll_abs == 43.7] <- 4370






# filter measurements to only include Sensors with full metadata available
element_measurements = element_measurements |> filter(ID %in% element_meta$ID)





### -------------------

# Temporal Cleanup: Keep only data after "gueltig_ab" 

element_measurements$Datum_Zeit = lubridate::as_datetime(str_sub(element_measurements$Datum_Zeit, start = 1, end = 18), format = "%Y-%m-%d %H:%M:%S")


element_meta$gueltig_ab = lubridate::as_datetime(element_meta$gueltig_ab, format = "%Y-%m-%d")
element_meta$gueltig_ab[is.na(element_meta$gueltig_ab)] <- lubridate::as_datetime("2025-01-01 00:00:00", format = "%Y-%m-%d %H:%M:%S")

element_measurements = element_measurements |> left_join(element_meta[,c("ID", "gueltig_ab")]) |> filter(Datum_Zeit > gueltig_ab) |> select(-gueltig_ab)
# -----



# Ungenaue Werte Rausschmeissen
element_measurements = element_measurements[element_measurements$SRSSI_Signalstaerke == 10,]
element_measurements = element_measurements[element_measurements$SRC_Echoguete == 10,]

element_measurements$SRSSI_Signalstaerke = NULL
element_measurements$SRC_Echoguete = NULL


## Zwischenstand speichern: alle guten messwerte

element_measurements$IDshort = str_sub(element_measurements$ID, -4) |> as.factor()
element_measurements = element_measurements |> relocate(ID, IDshort, Datum_Zeit, Abstand)


write.csv(element_measurements, "data/de/de_allMeasurements.csv", row.names = FALSE)





# -----------------------------------------------


## Daily Mean Values
element_measurements$Datum = date(element_measurements$Datum_Zeit)

dailyMeanAbs = element_measurements |> group_by(ID, Datum) |> summarise(GWS_abs = round(mean(GWS_abs), digits = 0))
dailyMeanRel = element_measurements |> group_by(ID, Datum) |> summarise(GWS_rel = round(mean(GWS_rel), digits = 0))
dailyDiff = element_measurements |> group_by(ID, Datum) |> summarise(GWS_def = round(mean(GWS_Diff), digits = 0))





## Create full dataset with missing values
sensors = unique(element_measurements$ID)
dates = seq(min(element_measurements$Datum), max(element_measurements$Datum))
gws = expand.grid(ID = sensors, Datum = dates)
gws$IDshort = str_sub(gws$ID, -4) |> as.factor()
gws = gws |> relocate(ID, IDshort, Datum)

gws = left_join(gws, dailyMeanAbs, by = join_by(ID, Datum))
gws = left_join(gws, dailyMeanRel, by = join_by(ID, Datum))
gws = left_join(gws, dailyDiff, by = join_by(ID, Datum))


element_meta = sf::st_as_sf(element_meta, coords = c("Easting", "Northing"), crs = 25832)

write.csv(gws, "data/de/de_gwsDaily.csv")
saveRDS(gws, "data/de/de_gwsDaily.RDS")
sf::write_sf(element_meta, "data/de/de_gwsHeader.gpkg")




