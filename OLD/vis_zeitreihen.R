# Volle Zeitreihen aller Sensoren



sensorid = "244E7B0000003F20"
gws |> filter(ID == sensorid) |> filter(month(Datum) %in% c(5,6,7)) |> 
  ggplot(aes(x = Datum, y = GWS_abs))+
  geom_point(size = 1, color = "royalblue")+
  geom_line(color = "royalblue")+
  scale_x_date(position = "top", name = NULL)+
  ylab("Grundwasserstand [cm]")+
  ggtitle("Sensor 3F20")+
  #geom_hline(yintercept = 0)+
  geom_hline(data = gwsHeader |> filter(ID == sensorid), aes(yintercept = GWS_Soll_abs), color = "firebrick2", show.legend = TRUE)+
  theme(text = element_text(color = "black"), line = element_line(color = "black"), 
        panel.background = element_blank(), 
        axis.text = element_text(color = "black"), axis.ticks = element_blank(),
        panel.grid = element_blank(), panel.grid.major.y = element_line(color = "grey60"))+
  theme(plot.margin=grid::unit(c(0,0,0,0), "mm"))


ggsave("figures/zeitreihe_3F20.png", width = 15, units = "cm")




sensorid = "244E7B0000003F1B"
gws |> filter(ID == sensorid) |> filter(month(Datum) %in% c(5,6,7)) |> 
  ggplot(aes(x = Datum, y = GWS_abs))+
  geom_point(size = 1, color = "royalblue")+
  geom_line(color = "royalblue")+
  scale_x_date(position = "top", name = NULL)+
  ylab("Grundwasserstand [cm]")+
   ggtitle("Sensor 3F1B")+
  #geom_hline(yintercept = 0)+
  geom_hline(data = gwsHeader |> filter(ID == sensorid), aes(yintercept = GWS_Soll_abs), color = "firebrick2", show.legend = TRUE)+
  theme(text = element_text(color = "black"), line = element_line(color = "black"), 
        panel.background = element_blank(), 
        axis.text = element_text(color = "black"), axis.ticks = element_blank(),
        panel.grid = element_blank(), panel.grid.major.y = element_line(color = "grey60"))+
  theme(plot.margin=grid::unit(c(0,0,0,0), "mm"))

ggsave("figures/zeitreihe_3F1B.png", width = 15, units = "cm")





sensorid = "244e7b00000040a8"
gws |> filter(ID == sensorid) |> filter(month(Datum) %in% c(7, 8, 9)) |> 
  ggplot(aes(x = Datum, y = GWS_abs))+
  geom_point(size = 1, color = "royalblue")+
  geom_line(color = "royalblue")+
  scale_x_date(position = "top", name = NULL)+
  ylab("Grundwasserstand [cm]")+
  ggtitle("Sensor 40A8")+
  #geom_hline(yintercept = 0)+
  geom_hline(data = gwsHeader |> filter(ID == sensorid), aes(yintercept = GWS_Soll_abs), color = "firebrick2", show.legend = TRUE)+
  theme(text = element_text(color = "black"), line = element_line(color = "black"), 
        panel.background = element_blank(), 
        axis.text = element_text(color = "black"), axis.ticks = element_blank(),
        panel.grid = element_blank(), panel.grid.major.y = element_line(color = "grey60"))+
  theme(plot.margin=grid::unit(c(0,0,0,0), "mm"))

ggsave("figures/zeitreihe_40A8.png", width = 15, units = "cm")


#------ Karte der Einzelsensoren

einzel = gwsHeader |> filter(IDshort %in% c("40a8", "3F1B", "3F20"))

gwsHeader |> st_transform(3857) |> 

ggplot()+
  basemap_gglayer(ext = gwsHeader |> st_buffer(dist = 100) |> st_transform(3857), map_service = "osm", map_type = "streets_de")+
  scale_fill_identity()+
  coord_sf(datum = 25832)+
  geom_sf(data = gwsHeader,
          shape = 21, fill = 'white', size = 2.5)+
            gg_theme_report+
            theme(legend.position = 'bottom', axis.title = element_blank())+
    geom_sf(data = einzel,
          shape = 21, fill = 'black', size = 2.5)+
  geom_sf_label(data = einzel, aes(label = IDshort))+
  theme(plot.margin=grid::unit(c(0,0,0,0), "mm"))

ggsave("figures/zeitreihen_location.png", width = 15, units = "cm")






ggplot(gws, aes(x = Datum, y = GWS_rel))+
  geom_point(size = 1, color = "royalblue")+
  geom_line(color = "royalblue")+
  geom_hline(yintercept = 0)+
  #geom_vline(aes(xintercept = input$dateSelect), color = "firebrick3", lwd = 1)+
  facet_wrap(.~IDshort, ncol = 10)+
  scale_x_date(name = NULL, date_breaks = 'year', date_labels = '%Y')+
  ggtitle("GWS Flurabstand [cm]")+
  scale_y_continuous(name = NULL)+
  gg_theme_report+
  theme(plot.margin=grid::unit(c(0,0,0,0), "mm"))

ggsave("figures/zeitreihen_flurabstand.png", width = 25, height = 25, units = "cm")


ggplot(gws, aes(x = Datum, y = GWS_abs))+
  geom_point(size = 1, color = "royalblue")+
  geom_line(color = "royalblue")+
  geom_hline(data = gwsHeader, aes(yintercept = GWS_Soll_abs), color = "firebrick2", show.legend = TRUE)+
  facet_wrap(.~IDshort, ncol = 10)+
  scale_x_date(name = NULL, date_breaks = 'year', date_labels = '%Y')+
  ggtitle("GWS [cm über NN] mit Soll Wasserstand")+
  scale_y_continuous(name = NULL)+
  gg_theme_report+
  theme(plot.margin=grid::unit(c(0,0,0,0), "mm"))

ggsave("figures/zeitreihen_sollist.png", width = 25, height = 25, units = "cm")







