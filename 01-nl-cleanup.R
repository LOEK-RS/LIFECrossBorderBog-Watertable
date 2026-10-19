# create NL dataset

library(tidyverse)
library(sf)

nlmeta = read.csv("nl_exports/2025-06-06 14h37m25_Aamsveen_N2000_meta.csv", skip = 8, sep = ";")

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

nl = read.csv("nl_exports/2025-06-06 14h37m25_Aamsveen_N2000.csv", skip = 1,
              sep = ";")
nl$X = NULL
nl$ManualHead = NULL



nl = nl |> filter(!(NITGCode %in% c("[String]", 'NITGCode')))
nl = nl[nl$FilterNo == 1,]

nl$FilterNo = NULL


nl$DateTime = lubridate::as_datetime(nl$DateTime, format = "%d-%m-%Y %H:%M")
nl$LoggerHead = as.numeric(nl$LoggerHead)

nl = nl |> filter(DateTime >= ymd("2024-01-01"))
nl$Datum = date(nl$DateTime)

colnames(nl) = c("ID", "DateTime", "GWS_abs", "Datum")

dailyMeanAbs = nl |> group_by(ID, Datum) |> summarise(GWS_abs = round(mean(GWS_abs * 100), digits = 0))

## Create full dataset with missing values
sensors = unique(nl$ID)
dates = seq(min(nl$Datum), max(nl$Datum))
nlgws = expand.grid(ID = sensors, Datum = dates)

nlgws = left_join(nlgws, dailyMeanAbs, by = dplyr::join_by(ID, Datum))

nlgws = left_join(nlgws, nlmeta[,c("ID", "Hoehe_abs")])
nlgws$GWS_rel = nlgws$GWS_abs - nlgws$Hoehe_abs
nlgws$geometry = NULL
nlgws$Hoehe_abs = NULL
nlgws$IDshort = nlgws$ID




nlgws = left_join(nlgws, nlmeta[c("ID", "GWS_Soll_abs")])


nlgws$GWS_def = nlgws$GWS_Soll_abs - nlgws$GWS_abs
nlgws$GWS_Soll_abs = NULL


nlgws = nlgws |> relocate(ID, IDshort, Datum, GWS_abs, GWS_rel, GWS_def)
nlgws$geometry = NULL


saveRDS(nlgws, "data/nl_gws.RDS")
saveRDS(nlmeta, "data/nl_gwsHeader.RDS")
write_sf(nlmeta, "data/nl_gwsHeader.gpkg")

