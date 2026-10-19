library(lubridate)
library(tidyverse)
library(sf)
library(flexdashboard)
library(htmlwidgets)
library(mapview)
library(terra)
library(tidyterra)
library(basemaps)
library(ggiraph)
library(patchwork)
library(colorspace)
library(leafpop)



gg_theme_report <- theme(text = element_text(color = "black"), line = element_line(color = "black"), 
                         panel.background = element_blank(), 
                         axis.text = element_text(color = "black"), axis.ticks = element_blank(),
                         panel.grid = element_blank(), panel.grid.major.y = element_line(color = "grey60"))


