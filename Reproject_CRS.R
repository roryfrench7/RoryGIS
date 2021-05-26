"""
Reproject coordinate system for either raster or vector files. Both can be done for individual files or 
scripted for multiple files. Convert rasters into cloud-optimized geotiffs 
"""



library(sp)
library(raster)
library(rgdal)
library(rgeos)
library(gdalUtilities)

## Reproject vector files into different coordinate system
vector_set <- list.files("D:/Github/RoryGIS/shapefiles", pattern = ".shp")
i=1
for (i in 1:length(vector_set)){

  vector_file <- readOGR(dsn = "D:/Github/RoryGIS/shapefiles", 
                         layer = substr(vector_set[[i]], 1, nchar(vector_set[[i]])-4)) ##read shapefile
  
  reprojected_vector <- spTransform(vector_file, CRS("+init=epsg:3857")) ##Specify targeted coordinate system here
  
  vector_output <- paste0(substr(vector_set[[i]], 1, nchar(vector_set[[i]])-4), "_reprojected.shp")
  writeOGR(reprojected_vector, dsn = "D:/Github/RoryGIS", layer = vector_output, driver = "ESRI Shapefile") ##write reprojected vector file with specified name to specified location
  print(paste0("finished reprojecting count ", i, ": ",  vector_set[i], " at ", Sys.time())) #note the time it takes between shapefiles during scripting

}
## Reproject raster files into different coordinate system
raster_set <- list.files("D:/Github/RoryGIS", pattern = ".tif")
i=1


for (i in 1:length(raster_set)){
  ##Turn rasters into cloud optimized geotiffs
  cloud_optimized_file <- gdal_translate(src_dataset = raster_set[i], 
                                         dst_dataset = paste0(substr(raster_set[[i]], 1, nchar(raster_set[[i]])-4), "_cloud_optimized.tif"),
                                         co = matrix(c("TILED=YES", "COPY_SRC_OVERVIEWS=YES", "COMPRESS=LZW"), ncol=1)) ##convert raster into cloud-optimized geotiff with LZW compression and tiling and create COG file into folder
  
  raster_file <- stack(cloud_optimized_file) ## read cloud optimized geotiff
  
  coord_sys <- "+init=epsg:3857" ## Specify targeted coordinate system here
  
  reprojected_raster <- projectRaster(raster_file, crs = coord_sys) #reproject raster to new coord system
  
  raster_output <- paste0(substr(raster_set[[i]], 1, nchar(raster_set[[i]])-4), "_reprojected.tif")
  writeRaster(reprojected_raster, raster_output, overwrite = TRUE) #write Raster to new location
  print(paste0("finished reprojecting count ", i, ": ",  raster_set[i], " at ", Sys.time())) #note time between rasters for scripting
  
}