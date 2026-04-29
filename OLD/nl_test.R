## NL one Logger


table(nl$id_fil)
logger = nl |> filter(DateTime >= ymd("2024-01-01"))






ggplot(logger, aes(x = DateTime, y = LoggerHead, color = FilterNo))+
  geom_line()
table(nl$NITGCode, nl$FilterNo)




ggplot(logger, aes(x = DateTime, y = LoggerHead))+
  geom_point(size = 0.2)+
  facet_wrap(.~id_fil)





gwsheader = readRDS("data/gwsHeader.RDS")
gwsheader = st_as_sf(gwsheader, coords = c("Easting", "Northing"), crs = 25832)
# bugfix: throw out sensor 244E7B0000004584. it has wrong easting
gwsheader = gwsheader[gwsheader$ID != "244E7B0000004584",]

mapview::mapview(nlmeta) + mapview::mapview(gwsheader)
