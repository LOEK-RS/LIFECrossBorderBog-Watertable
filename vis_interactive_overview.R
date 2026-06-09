# interactive figure of all gws time series




set_defaults(map_service = "osm", map_type = "topographic")
map_ext = st_bbox(st_buffer(gwsHeader, 150))


map_plot = ggplot() +
  basemap_gglayer(map_ext) +
  scale_fill_identity() +
  coord_sf() +
  geom_sf_interactive(
    data = st_transform(gwsHeader, 3857),
    mapping = aes(tooltip = IDshort, data_id = IDshort)
  ) +
  theme_minimal() +
  theme(text = element_blank())
map_plot




watertable_plot = ggplot(
  gws,
  aes(
    x = Datum,
    y = GWS_rel,
    group = IDshort,
    tooltip = IDshort,
    data_id = IDshort
  )
) +
  geom_line_interactive(color = "royalblue2", alpha = 0.8, lwd = 0.4) +
  geom_hline(yintercept = 0, color = "brown") +
  scale_x_datetime(
    name = "Datum",
    limits = c(as_datetime(min(gws$Datum)), as_datetime(max(gws$Datum)))
  ) +
  scale_y_continuous(name = "relativer Grundwasserstand [m]") +
  theme_minimal()





interactive_plot = watertable_plot + map_plot + plot_layout(widths = c(2, 1))




interactive_plot = girafe(interactive_plot)
interactive_plot = girafe_options(x = interactive_plot, opts_hover(css = "stroke:orange;alpha:1;stroke-width:2"))

htmltools::save_html(interactive_plot, "plots/interaktive_karte.html")



