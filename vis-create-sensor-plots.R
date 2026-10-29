
source("init.R")






sensor_list = gwsHeader$ID


for(i in seq(length(sensor_list))){


p = ggplot(gws[gws$ID == sensor_list[i],], aes(x = Datum, y = GWS_rel))+
  geom_rect(data = bg_shading, mapping = aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax, fill = fill), inherit.aes=FALSE, show.legend = FALSE, alpha = 0.5)+
  scale_fill_manual(values = c("white" = "white", "grey80" = "grey80"))+
  geom_point(size = 0.7, color = "royalblue")+
  geom_line(color = "royalblue2")+
  geom_hline(yintercept = 0)+
  scale_x_date(name = NULL, date_breaks = 'year', date_labels = '%y')+
  ggtitle(paste0("Flurabstand [cm]: Sensor ", sensor_list[i]))+
  scale_y_continuous(name = NULL)+
  gg_theme_report+
  theme(plot.margin=grid::unit(c(0,0,0,0), "mm"), panel.grid.major.x = element_line(linetype = "dashed"))

 

ggsave(plot = p, filename = paste0("plots/individual_sensors/", sensor_list[i], ".png"), width = 20, height = 15, units = "cm")


}










