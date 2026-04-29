# load data



gws = rbind(readRDS("data/de_gws.RDS"),
            readRDS("data/nl_gws.RDS"))


gwsHeader = rbind(readRDS("data/de_gwsHeader.RDS"),
                  readRDS("data/nl_gwsHeader.RDS"))



# patch: remove 3FDA, there is only one faulty measurement

gws = gws[gws$IDshort != "3FDA",]




dem = rast("data/geodata/DGM_Qube640/a2501011_dgm_25cm_cls8_qube640_flug20250221_stand20250313_elev.tif")

dams = read_sf("data/geodata/HuendfelderMoor_Daemme/HuendfelderMoor_Daemme.shp")

