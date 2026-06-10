q = lubridate::quarter(gws$Datum, with_year = TRUE, type = "date_last") |> unique()




bg_shading = data.frame(
  
  xmin=lubridate::quarter(gws$Datum, type = "date_first") |> unique(),
  xmax=lubridate::quarter(gws$Datum, type = "date_last") |> unique(),
  ymin=-Inf,
  ymax=Inf
)
bg_shading$fill = rep(c("grey80", 'white'), length.out = nrow(bg_shading), each = 1)


ggplot(gws, aes(x = Datum, y = GWS_rel))+
  geom_rect(data = bg_shading, mapping = aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax, fill = fill), inherit.aes=FALSE, show.legend = FALSE, alpha = 0.5)+
  scale_fill_manual(values = c("white" = "white", "grey80" = "grey80"))+
  geom_point(size = 0.5, color = "royalblue")+
  geom_line(color = "royalblue2")+
  geom_hline(yintercept = 0)+
  facet_wrap(.~IDshort, ncol = 10)+
  scale_x_date(name = NULL, date_breaks = 'year', date_labels = '%y')+
  ggtitle("GWS Flurabstand [cm]")+
  scale_y_continuous(name = NULL)+
  gg_theme_report+
  theme(plot.margin=grid::unit(c(0,0,0,0), "mm"), panel.grid.major.x = element_line(linetype = "dashed"))

ggsave("plots/zeitreihen_flurabstand.png", width = 60, height = 25, units = "cm")


ggplot(gws, aes(x = Datum, y = GWS_abs))+
  geom_rect(data = bg_shading, mapping = aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax, fill = fill), inherit.aes=FALSE, show.legend = FALSE, alpha = 0.5)+
    scale_fill_manual(values = c("white" = "white", "grey80" = "grey80"))+
  geom_point(size = 0.5, color = "royalblue")+
  geom_line(color = "royalblue2")+
  geom_hline(data = gwsHeader |> filter(IDshort != "3FE7"), aes(yintercept = GWS_Soll_abs), color = "firebrick2", show.legend = FALSE)+
  facet_wrap(.~IDshort, ncol = 10)+
  scale_x_date(name = NULL, date_breaks = 'year', date_labels = '%y')+
  ggtitle("GWS [cm über NN] mit Soll Wasserstand")+
  scale_y_continuous(name = NULL)+
  gg_theme_report+
  theme(plot.margin=grid::unit(c(0,0,0,0), "mm"), panel.grid.major.x = element_line(linetype = "dashed"))

ggsave("plots/zeitreihen_sollist.png", width = 60, height = 25, units = "cm")
