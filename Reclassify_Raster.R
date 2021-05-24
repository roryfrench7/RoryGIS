library(sf)
library(spbabel)
library(raster)

## Reclassify negative pixels to NA data points in rasters

island_set <- list.files("D:/Github/RoryGIS", pattern = ".tif")


for (i in 1:length(island_set)) {
  
  old_tif <- stack(island_set[i])
  
  
  new_tif <- reclassify(old_tif, cbind(-Inf, 0, NA))
  
  island_output <- paste0(substr(island_set[[i]], 1, nchar(island_set[[i]])-4), "_mosaic_resampled.tif")
  writeRaster(new_tif, island_output, overwrite =TRUE)
  
  island_list[i] <- island_output
  print(paste0("finished resampling count ", i, ": ",  island_set[i], " at ", Sys.time()))
}


