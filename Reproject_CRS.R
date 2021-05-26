library(sp)
library(raster)
library(rgdal)
library(rgeos)
## Reproject vector files into different coordinate system
vector_set <- list.files("D:/Github/RoryGIS", pattern = ".shp")
i=1
for (i in 1:length(vector_set)){

  vector_file <- readOGR(dsn = "D:/Github/RoryGIS", layer = substr(vector_set[[i]], 1, nchar(vector_set[[i]])-4))
  
  reprojected_vector <- spTransform(vector_file, CRS("+init=epsg:3857")) ##Specify targeted coordinate system here
  
  vector_output <- paste0(substr(vector_set[[i]], 1, nchar(vector_set[[i]])-4), "_reprojected.shp")
  writeOGR(reprojected_vector, dsn = "D:/Github/RoryGIS", layer = vector_output, driver = "ESRI Shapefile")
  print(paste0("finished reprojecting count ", i, ": ",  vector_set[i], " at ", Sys.time()))

}
## Reproject raster files into different coordinate system
raster_set <- list.files("D:/Github/RoryGIS/rasters/", pattern = ".tif")
i=1
for (i in 1:length(raster_set)){
  
  raster_file <- stack(raster_set[i])
  
  coord_sys <- "+init=epsg:3857" ## Specify targeted coordinate system here
  
  reprojected_raster <- projectRaster(raster_file, crs = coord_sys) 
  
  raster_output <- paste0(substr(raster_set[[i]], 1, nchar(raster_set[[i]])-4), "_reprojected.tif")
  writeRaster(reprojected_raster, raster_output, overwrite = TRUE)
  print(paste0("finished reprojecting count ", i, ": ",  raster_set[i], " at ", Sys.time()))
  
}