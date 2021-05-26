""" 
Reclassify negative pixels to NA data points in rasters. Can be run for individual raster or scripted 
for multiple rasters.The process should reduce filesize of raster
"""


library(sf)
library(spbabel)
library(raster)


island_set <- list.files("D:/Github/RoryGIS", pattern = ".tif") #read rasters


for (i in 1:length(island_set)) {
  
  old_tif <- stack(island_set[i]) #use stack to create multibanded raster file (works for singlebanded rasters too)
  
  
  new_tif <- reclassify(old_tif, cbind(-Inf, 0, NA)) #reclassify all negative pixels to NA
  
  island_output <- paste0(substr(island_set[[i]], 1, nchar(island_set[[i]])-4), "_mosaic_resampled.tif") #set name to save file to 
  writeRaster(new_tif, island_output, overwrite =TRUE) #write reclassified raster to folder
  
  island_list[i] <- island_output
  print(paste0("finished resampling count ", i, ": ",  island_set[i], " at ", Sys.time()))
}


