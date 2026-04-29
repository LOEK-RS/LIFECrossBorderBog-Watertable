# this script runs each time you download data from Element Iot Portal
# It creates the files gws.RDS with the actual water table depth data
# and gwsHeader.RDS with the metadata of the loggers


# MS.NR = Messstelle
# Länge = Koordinate
# PolderNummer = Interne Bezeichnung
# GWS_Soll = Grundwasserstand Soll, also nach der Wiedervernässung
# GWS_abs = Aktuell Gemessener Grundwasserstand über NN
# GWS_diff = GWS_Soll - GWS_abs
# GWS_rel = Grundwasserstand bezogen auf die Sensorhöhe
# SRSSI_Signalstaerke = Qualitätskriterium SOLLTE 10 SEIN
# SRC_Echoguete = Qualitätskriterium SOLLTE 10 SEIN
# Abstand = Sensorhöhe zum Boden ???
# Hoehe_Absolut = Sensorhöhe über NN
# gueltig_ab = Sensorwerte sind gütltig ab



element = read.csv("data/messwerte.csv", skip = 1)



# Ungenaue Werte Rausschmeissen
element = element[element$SRSSI_Signalstaerke == 10,]
element = element[element$SRC_Echoguete == 10,]

# Datum vernünftig formatieren
element$Datum_Zeit = lubridate::as_datetime(str_sub(element$Datum_Zeit, start = 1, end = 18), format = "%Y-%m-%d %H:%M:%S")
element$gueltig_ab = lubridate::as_datetime(element$gueltig_ab, format = "%Y-%m-%d")

# short id
element$IDshort = str_sub(element$ID, -4)



# keep only data with coordinates
element = element[!is.na(element$Easting),]

# round GWS
element$GWS_abs = round(element$GWS_abs, digits = 0)


# BUGFIX: 
element = element[element$ID != "244E7B0000004584",]
element = element |> rename(GWS_Soll_abs = GWS_Soll)
element = element |> rename(Hoehe_abs = Hoehe_absolut)

element$GWS_Soll_abs[element$GWS_Soll_abs == 43.7] <- 4370
element$GWS_Diff[element$ID == "244e7b00000040a8"] <- element$GWS_Diff[element$ID == "244e7b00000040a8"] / 100







# Nur Messdaten nach gueltig_ab behalten
element$gueltig_ab[is.na(element$gueltig_ab)] <- lubridate::as_datetime("2025-01-01 00:00:00", format = "%Y-%m-%d %H:%M:%S")
element = element[element$Datum_Zeit > element$gueltig_ab,]



# Zeilen mit NA raus
#element = element[complete.cases(element),]


# extract Header Data
elementHeader = element[,c("ID", "IDshort", "MS.Nr", "Easting", "Northing",
                           "Polder.Nummer", "GWS_Soll_abs",
                           "Hoehe_abs", "gueltig_ab")] |> unique()
elementHeader$Betreiber = "Biologische Station Zwillbrock"
elementHeader = st_as_sf(elementHeader, coords = c("Easting", "Northing"), crs = 25832)







## Daily Mean Values
element$Datum = date(element$Datum_Zeit)

dailyMeanAbs = element |> group_by(ID, Datum) |> summarise(GWS_abs = round(mean(GWS_abs), digits = 0))
dailyMeanRel = element |> group_by(ID, Datum) |> summarise(GWS_rel = round(mean(GWS_rel), digits = 0))
dailyDiff = element |> group_by(ID, Datum) |> summarise(GWS_def = round(mean(GWS_Diff), digits = 0))





## Create full dataset with missing values
sensors = unique(element$ID)
dates = seq(min(element$Datum), max(element$Datum))
gws = expand.grid(ID = sensors, Datum = dates)
gws$IDshort = str_sub(gws$ID, -4) |> as.factor()
gws = gws |> relocate(ID, IDshort, Datum)

gws = left_join(gws, dailyMeanAbs, by = join_by(ID, Datum))
gws = left_join(gws, dailyMeanRel, by = join_by(ID, Datum))
gws = left_join(gws, dailyDiff, by = join_by(ID, Datum))



saveRDS(elementHeader, "data/de_gwsHeader.RDS")
saveRDS(gws, "data/de_gws.RDS")

# write.csv(elementHeader, "appdata/gwsHeader.csv", row.names = FALSE)
# write.csv(gws, "appdata/gws.csv", row.names = FALSE)



