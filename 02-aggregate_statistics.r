# median groundwater levels








gwsAggregate <- function(gws, y, m){
gws_sub = gws |> filter(year(Datum) %in% y) |> filter(month(Datum) %in% m)

  
gws_statistics = gws_sub |> group_by(IDshort) |> 
  summarise(GWS_rel_median = median(GWS_rel, na.rm = TRUE),
  GWS_rel_sd = sd(GWS_rel, na.rm = TRUE),
  GWS_abs_median = median(GWS_abs, na.rm = TRUE),
  GWS_abs_sd = sd(GWS_abs, na.rm = TRUE))
  return(gws_statistics)

}

gws_median = gwsAggregate(gws, y = c(2024,2025,2026), m = c(1,2,3,4,5,6,7,8,9,10,11,12))


gwsStats = left_join(gwsHeader, gws_median)

gwsStats$GWS_abs_defizit = gwsStats$GWS_Soll_abs - gwsStats$GWS_abs_median




# anzahl tage in denen der Grundwasserstand 




