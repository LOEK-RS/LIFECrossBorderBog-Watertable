



## Time Series















ggplot(gws, aes(x = Datum, y = GWS_abs))+
  geom_point(size = 0.1)+
  geom_hline(data = gwsHeader, mapping = aes(yintercept = GWS_Soll_abs))+
  #geom_vline(aes(xintercept = input$dateSelect), color = "firebrick3", lwd = 1)+
  facet_wrap(.~ID)




## Detailed views --------------


sensor = "244E7B0000004775"
sensor = "244E7B0000003F54"

onesensor = gwsheader |> filter(ID == sensor)
onedam = dams |> filter(Nr == onesensor$Polder.Nummer)
onedem = crop(dem, onedam |> st_buffer(dist = 20))
onedam = st_crop(dams, onedem)
onegws = gws |> filter(ID == sensor)

ggplot()+
  geom_spatraster(data = onedem, maxcell = 200000)+
  geom_sf(data = onedam)+
  geom_sf(data = onesensor, size = 3, color = "orange")+
  scale_fill_viridis_c(name = "Elevation \n[m a.s.l.]")+
  coord_sf(datum = 25832)+
  theme_bw()



ggplot(onegws, aes(x = Datum, y = GWSrel))+
  geom_point(size = 1)+
  geom_line()+
  geom_hline(yintercept = 0)


ggplot(onegws, aes(x = Datum, y = GWSabs))+
  geom_point(size = 1)+
  geom_hline(data = onesensor, mapping = aes(yintercept = GWS_Soll))











