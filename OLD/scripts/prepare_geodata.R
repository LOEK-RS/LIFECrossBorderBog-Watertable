

dams = read_sf("data/HuendfelderMoor_Daemme/HuendfelderMoor_Daemme.shp") |> st_transform(4326)
dams = dams[,"Nr"]
st_write(dams, "appdata/dams.geojson")
