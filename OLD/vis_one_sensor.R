sensorid = "244E7B0000004775"
sensorid = "244E7B0000003F54"

# integrate weekly grid

gws |> filter(ID == sensorid) |> filter(month(Datum) %in% c(5,6,7)) |> 
  ggplot(aes(x = Datum, y = GWS_rel))+
  geom_point(size = 1, color = "royalblue")+
  geom_line(color = "royalblue")+
  scale_x_date(position = "top", name = NULL)+
  ylab("Grundwasserstand [cm]")+
  geom_hline(yintercept = 0)+
  geom_hline(data = gwsHeader |> filter(ID == sensorid), aes(yintercept = GWS_Soll_rel), color = "firebrick2", show.legend = TRUE)+
  theme(text = element_text(color = "black"), line = element_line(color = "black"), 
        panel.background = element_blank(), 
        axis.text = element_text(color = "black"), axis.ticks = element_blank(),
        panel.grid = element_blank(), panel.grid.major.y = element_line(color = "grey60"))



onesensor = function(sensorid){
  gws |> filter(ID == sensorid) |> 
  ggplot(aes(x = Datum, y = GWS_rel))+
    geom_point(size = 1)+
    geom_line()+
    geom_hline(yintercept = 0)
  
  
  
}



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