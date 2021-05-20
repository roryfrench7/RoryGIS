library(sf)
library(spbabel)
library(rgeos)
library(raster)
setwd("C:/Users/Rory's PC/Desktop/Mikes_Coconuts/Dissolved_Islands")

island_set = list.files(getwd(), pattern = ".shp")
island_list = list()

for (i in seq_len(length(island_set)))
{
  island_input = island_set[i]
  island_shapefile = shapefile(island_input)
  measure_area = area(island_shapefile)/1000000
  simplified_area = round(measure_area, digits = 6)
  
  island_output = paste0(substr(island_set[[i]], 1, nchar(island_set[[i]])-8), "_",  simplified_area)
  island_list[i] = island_output
  
}
print(island_list)

