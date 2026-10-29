# create NL dataset

library(tidyverse)
library(sf)

nlmeta = read.csv("raw/nl_exports/2025-06-06 14h37m25_Aamsveen_N2000_meta.csv", skip = 8, sep = ";")

nlmeta = nlmeta |> filter(FilterNo == 1)

# only keep latest date of each sensor
nlmeta = nlmeta |> group_by(Name) |> filter(StartDateTime == max(StartDateTime)) |> ungroup()



# harmonize with german metadata
nlmeta = nlmeta |> select(NITGCode, StartDateTime, XCoordinate, YCoordinate, SurfaceLevel) |> 
  rename(ID = NITGCode, Hoehe_abs = SurfaceLevel, gueltig_ab = StartDateTime)

nlmeta$Hoehe_abs = nlmeta$Hoehe_abs * 100


# patch: Soll wasserstände für NL

patch_df = data.frame(ID = c("B35AB080", "B35A0909", "B35A0910", "B35A0975", "B35A0974", "B35A0908", "B35A0904", "B35A0903", "B35A0901"),
                      GWS_Soll_abs = c(4220, 4320, 4220, 4250, 4270, 4250, 4250, 4250, 4325))


nlmeta = left_join(nlmeta, patch_df)


nlmeta$IDshort = nlmeta$ID
nlmeta$Polder.Nummer = NA
nlmeta$Betreiber = "Overijssel"

nlmeta = st_as_sf(nlmeta, coords = c("XCoordinate", "YCoordinate"), crs = 28992) |> st_transform(25832)
nlmeta = nlmeta |> relocate(ID, IDshort, Polder.Nummer, GWS_Soll_abs, Hoehe_abs, gueltig_ab, Betreiber, geometry)
nlmeta$gueltig_ab = lubridate::as_datetime(str_sub(nlmeta$gueltig_ab, start = 1, end = 18), format = "%d-%m-%Y %H:%M")





## Actual data of loggers

nl = read.csv("raw/nl_exports/2025-06-06 14h37m25_Aamsveen_N2000.csv", skip = 1,
              sep = ";")
nl$X = NULL
nl$ManualHead = NULL



nl = nl |> filter(!(NITGCode %in% c("[String]", 'NITGCode')))
nl = nl[nl$FilterNo == 1,]

nl$FilterNo = NULL


nl$DateTime = lubridate::as_datetime(nl$DateTime, format = "%d-%m-%Y %H:%M")
nl$LoggerHead = as.numeric(nl$LoggerHead)

colnames(nl) = c("ID", "DateTime", "GWS_abs")


nl = left_join(nl, nlmeta[,c("ID", "IDshort", "GWS_Soll_abs", "Hoehe_abs")])
nl$GWS_abs = nl$GWS_abs * 100
nl$GWS_rel = round(nl$GWS_abs - nl$Hoehe_abs)
nl$GWS_diff = round(nl$GWS_Soll_abs - nl$GWS_abs)


## Zwischenstand alle Messungen speichern


write.csv(nl, "data/nl/nl_allMeasurements.csv", row.names = FALSE)

###############

# Regular daily data of relevant time frame

nl = nl |> filter(DateTime >= ymd("2024-01-01"))
nl$Datum = date(nl$DateTime)

dailyMeanAbs = nl |> group_by(ID, Datum) |> summarise(GWS_abs = round(mean(GWS_abs), digits = 0),
GWS_rel = round(mean(GWS_rel)),
GWS_diff = round(mean(GWS_diff)))

## Create full dataset with missing values
sensors = unique(nl$ID)
dates = seq(min(nl$Datum), max(nl$Datum))
nlgws = expand.grid(ID = sensors, Datum = dates)

nlgws = left_join(nlgws, dailyMeanAbs, by = dplyr::join_by(ID, Datum))

nlgws$IDshort = nlgws$ID
nlgws = nlgws |> relocate(ID, IDshort, Datum, GWS_abs, GWS_rel, GWS_diff)



write.csv(nlgws, "data/nl/nl_gwsDaily.csv")
saveRDS(nlgws, "data/nl/nl_gwsDaily.RDS")
sf::write_sf(nlmeta, "data/nl/nl_gwsHeader.gpkg")
