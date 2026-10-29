# LifeCrossBorderBog Grundwasser

## Data Description

`raw` contains the downloaded water table measurements from different sources: The `element_exports` with the LoRa based measurment wells from Biologische Station Zwillbrock, mainly the German side of the restoration area. `nl_exports` with the official measurement wells from [https://www.broloket.nl/ondergrondgegevens](https://www.broloket.nl/ondergrondgegevens).


The raw data is processed in the scripts `01-cleanup.R` in subscripts for `de` and `nl`, where e.g. low quality measurements are taken out and projects specific variables are calculated. The end result is a analysis ready dataset `data/cbb_gwsDaily.csv` with the following columns:


|   |   |
|---|---|
|  ID | the sensor ID from the LoRa Network or the ondergrondgegevens   |
|  IDshort | the last 4 digits of the LoRa ID  |
| Datum | date|
| GWS_abs | absolute water table in [cm a.s.l.] average of all measurements of the date|
| GWS_rel | relative water table in [cm below surface] average of all measurements of the date |
| GWS_diff | GWS_diff: difference of water table in [cm] compared to the set target water table of the restoration project (see below)
|---|---|


For each ID, there is also a point in the `cbb_gwsHeader.gpkg` with the measurement location and 

|  |  | 
|---|---|
|Hoehe_abs | terrain height [cm a.s.l.] |
| Polder.Nummer | restoration project specific id of the dam | 
| GWS_Soll_abs | set target water table of the restoration project at the location. Used for calculating GWS_diff |
| gueltig_ab | sensor data is valid from this date |
| Betreiber | measurement location operator, either "Zwillbrock" or "Overijssel" |
|---|---|


In addition, `data/de` and `data/nl` contain files with all good quality measurements without the daily aggregation.

## Script Workflow

1. Download data from the ElementsIOT Portal. Use the scheme GW_ALLES. Downloading data from dates that were previously downloaded does not matter as in the next step, data will be checked for uniqueness.
2. Run the script `01-cleanup.R`. This runs two subscripts: `01-de-cleanup.R` will create a dataset of all sensors in the Element Portal (mostly on the German side) with a daily temporal resolution. `01-nl-cleanup.R` will create a dataset of all sensors of the Netherlands from the ondergrondgegevens Portal in the area. Both datasets will be combined to one CrossBorderBog Water Table Depth set.

  - `data/cbb_gwsHeader.gpkg` is the location of the measurment station with associated metadata.
  - `data/cbb_gwsDaily.RDS` are the measurements aggregated to a daily resolution.



## Visualizations

The scripts starting with `vis_` contain various plotting functions. `vis-create-sensor-plots.R` visualizes the full time series of the daily data for all sensors individually in the directory `plots/individual_sensors`. Rendering the `index.qmd`deploys an interactive map in the `docs/` directory which can be accessed here: [https://loek-rs.github.io/LIFECrossBorderBog-Watertable/](https://loek-rs.github.io/LIFECrossBorderBog-Watertable/)
