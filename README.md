# LifeCrossBorderBog Grundwasser


## Workflow


1. Download data from the ElementsIOT Portal. Use the scheme GW_ALLES. Downloading data from dates that were previously downloaded does not matter as in the next step, data will be checked for uniqueness.
2. Run the script `01-cleanup.R`. This runs two subscripts: `01-element-cleanup.R` will create a dataset of all sensors in the Element Portal (mostly on the German side) with a daily temporal resolution. `01-nl-cleanup.R` will create a dataset of all sensors of the Netherlands from the ondergrondgegevens Portal in the area. Both datasets will be combined to one CrossBorderBog Water Table Depth set.

  - `data/cbb_gwsHeader.gpkg` is the location of the measurment station with associated metadata.
  - `data/cbb_gwsDaily.RDS` are the measurements aggregated to a daily resolution.


