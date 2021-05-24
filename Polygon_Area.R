library(sf)
library(spbabel)
library(rgeos)
library(raster)

## Measure area in km2 of polygons

island_set <- list.files("D:/Github/RoryGIS", pattern = ".shp")
island_list <- list()

for (i in seq_len(length(island_set)))
{
  island_shapefile <- shapefile(island_set[i])
  measure_area <- area(island_shapefile)/1000000
  simplified_area <- round(measure_area, digits = 6)
  
  island_output <- paste0(substr(island_set[[i]], 1, nchar(island_set[[i]])-4), "_",  simplified_area)
  island_list[i] <- island_output
  
}
print(island_list)

