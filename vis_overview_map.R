## Median Overview
# evtl: filter(IDshort != "3FDA")

gwsStats |> st_transform(3857) |> 

ggplot()+
  basemap_gglayer(ext = gwsHeader |> st_buffer(dist = 100), map_service = "carto", map_type = "light_no_labels")+
  scale_fill_identity()+
  coord_sf(datum = st_crs(3857))+
  geom_sf(data = gwsStats, aes(color = GWS_rel_median, size = abs(GWS_rel_median)),
          shape = 19, fill = 'white')+
  scale_size(guide = "none")+
  scale_color_continuous_divergingx(name = "Median GWS [cm]",palette = "RdBu")+
            gg_theme_report+
            theme(legend.position = 'bottom', axis.title = element_blank())+
  theme(plot.margin=grid::unit(c(0,0,0,0), "mm"))


ggsave("plots/overview_median_gws.png", width = 15, units = "cm")




# Median Differenz zu Soll

bm <- basemap_terra(ext = gwsHeader |> st_buffer(dist = 100), map_service = "carto", map_type = "light_no_labels")
gwsStats |> st_transform(3857) |> 
ggplot()+
  geom_spatraster_rgb(data = bm)+
  coord_sf(datum = st_crs(3857))+
  geom_sf(data = gwsStats, aes(color = GWS_abs_defizit, size = GWS_abs_defizit),
          shape = 19, fill = 'white')+
            scale_size(guide = "none")+
  scale_colour_binned_divergingx(name = "GWS Differenz \n zu Soll [cm]",palette = "RdBu", rev = TRUE, na.value = "grey80")+
            gg_theme_report+
            theme(legend.position = 'bottom', axis.title = element_blank())+
  theme(plot.margin=grid::unit(c(0,0,0,0), "mm"))


ggsave("plots/overview_defizit_gws.png", width = 15, units = "cm")




# Schwankungen (sd)

gwsStats |> st_transform(3857) |> 
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

ggsave("plots/overview_schwankung_gws.png", width = 15, units = "cm")




