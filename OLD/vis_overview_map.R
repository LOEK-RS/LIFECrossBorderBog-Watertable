# vis overviews

ggplot()+
  geom_spatraster(data = dem, maxcell = 200000)+
  geom_sf(data = dams)+
  geom_sf(data = gwsHeader, size = 2)+
  scale_fill_viridis_c(name = "Geländehöhe [m]", na.value = "transparent")+
  coord_sf(datum = 25832)+
  theme_bw()



## Betreiber


gwsHeader |> st_transform(3857) |> 

ggplot()+
  basemap_gglayer(ext = gwsHeader |> st_buffer(dist = 100) |> st_transform(3857), map_service = "osm", map_type = "streets_de")+
  scale_fill_identity()+
  coord_sf(datum = 25832)+
  geom_sf(data = gwsHeader, aes(color = Betreiber),
          shape = 21, fill = 'white', size = 2.5)+
            gg_theme_report+
            theme(legend.position = 'bottom', axis.title = element_blank())+
  theme(plot.margin=grid::unit(c(0,0,0,0), "mm"))






ggsave("figures/overview_betreiber.png", width = 15, units = "cm")




## Median Overview


gwsStats |> st_transform(3857) |> 

ggplot()+
  basemap_gglayer(ext = gwsHeader |> st_buffer(dist = 100), map_service = "carto", map_type = "light_no_labels")+
  scale_fill_identity()+
  coord_sf(datum = st_crs(3857))+
  geom_sf(data = gwsStats, aes(color = GWS_rel_median, size = GWS_rel_median),
          shape = 19, fill = 'white')+
  scale_color_continuous_divergingx(name = "Median GWS [cm]",palette = "RdBu")+
            gg_theme_report+
            theme(legend.position = 'bottom', axis.title = element_blank())+
  theme(plot.margin=grid::unit(c(0,0,0,0), "mm"))




bm <- basemap_terra(ext = gwsHeader |> st_buffer(dist = 100), map_service = "carto", map_type = "light_no_labels")



plot_defizit <- gwsStats |> st_transform(3857) |> 
ggplot()+
  geom_spatraster_rgb(data = bm)+
  coord_sf(datum = st_crs(3857))+
  geom_sf(data = gwsStats, aes(color = GWS_abs_defizit, size = GWS_abs_defizit),
          shape = 19, fill = 'white')+
  scale_colour_binned_divergingx(name = "GWS Differenz \n zu Soll [cm]",palette = "RdBu", rev = TRUE, na.value = "grey80")+
            gg_theme_report+
            theme(legend.position = 'bottom', axis.title = element_blank())+
  theme(plot.margin=grid::unit(c(0,0,0,0), "mm"))



plot_defizit = gwsStats |> st_transform(3857) |> 
ggplot()+
  basemap_gglayer(ext = gwsHeader |> st_buffer(dist = 100), map_service = "carto", map_type = "light_no_labels")+
  scale_fill_identity()+
  coord_sf(datum = st_crs(3857))+
  geom_sf(data = gwsStats, aes(color = GWS_abs_defizit, size = GWS_abs_defizit),
          shape = 19, fill = 'white')+
  scale_colour_binned_divergingx(name = "GWS Differenz \n zu Soll [cm]",palette = "RdBu", rev = TRUE, na.value = "grey80")+
            gg_theme_report+
            theme(legend.position = 'bottom', axis.title = element_blank())+
  theme(plot.margin=grid::unit(c(0,0,0,0), "mm"))

ggplotly(plot_defizit, layerData = 1)

ggsave("figures/overview_median_gws.png", width = 15, units = "cm")





## Ist Soll

gwsStats |> st_transform(3857) |> 

ggplot()+
  basemap_gglayer(ext = gwsHeader |> st_buffer(dist = 100), map_service = "carto", map_type = "light_no_labels")+
  scale_fill_identity()+
  coord_sf(datum = st_crs(3857))+
  geom_sf(data = gwsStats, aes(color = GWS_abs_defizit),
          shape = 19, fill = 'white', size = 2.5)+
  scale_color_continuous_divergingx(name = "GWS Differenz \n zu Soll [cm]",palette = "RdBu", rev = TRUE, na.value = "grey80")+
            gg_theme_report+
            theme(legend.position = 'bottom', axis.title = element_blank())+
  theme(plot.margin=grid::unit(c(0,0,0,0), "mm"))

ggsave("figures/overview_istsoll.png", width = 15, units = "cm")




plot_schwankung = gwsStats |> st_transform(3857) |> 
ggplot()+
  basemap_gglayer(ext = gwsHeader |> st_buffer(dist = 100), map_service = "carto", map_type = "light_no_labels")+
  scale_fill_identity()+
  coord_sf(datum = st_crs(3857))+
  geom_sf(data = gwsStats, aes(color = GWS_rel_sd),
          shape = 19, fill = 'white', size = 2.5)+
  scale_colour_binned_sequential(name = "Schwankung der \nGrundwasserstände [cm]",palette = "Viridis", rev = TRUE, na.value = "grey80")+
            gg_theme_report+
            theme(legend.position = 'bottom', axis.title = element_blank())+
  theme(plot.margin=grid::unit(c(0,0,0,0), "mm"))

plot_schwankung



ggplotly(plot_defizit, layerData = 1)

ggsave("figures/overview_schwankung_gws.png", width = 15, units = "cm")

max(gwsStats$GWS_rel_sd, na.rm = T)



gwsStats |> ggplot(aes(x = GWS_abs_defizit))+
  geom_histogram(binwidth = 10, color = "black", fill = "white")+
  scale_y_continuous(name = "Häufigkeit", breaks = c(0,5,10))+
  scale_x_continuous(name = "Defizit zu Soll-Grundwasserstand [cm]")+
    gg_theme_report+
  theme(plot.margin=grid::unit(c(0,0,0,0), "mm"))
  

ggsave("figures/overview_defizit_hist.png", width = 10, units = "cm", height = 5)



