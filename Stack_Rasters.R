library(sf)
library(sp)
library(spbabel)
library(raster)


## Stack GLCM bands to Multispectral bands for island rasters

setwd("D:/Coconut_Imagery/Combined_Rasters")

glcm_set <- list.files("GLCM/", pattern = ".tif")
ms_set <- list.files("MS/", pattern= ".tif")
j = 0 

for (i in seq(1, length(glcm_set), 8)) {
  
  j = j+1
  
  print(paste0("Started aggregating for count ", j, ": ",  glcm_set[i], " at ", Sys.time()))
  
  
  glcm_stack <- stack((file.path("GLCM", glcm_set[i])), (file.path("GLCM", glcm_set[i+1])), (file.path("GLCM", glcm_set[i+2])), (file.path("GLCM", glcm_set[i+3])), (file.path("GLCM", glcm_set[i+4])), (file.path("GLCM", glcm_set[i+5])), (file.path("GLCM", glcm_set[i+6])), (file.path("GLCM", glcm_set[i+7])))
  
  stack_names <- names(glcm_stack)
  
  if (grepl("contrast", stack_names[1], fixed = TRUE) && grepl("correlation", stack_names[2], fixed = TRUE) && grepl("dissimilarity", stack_names[3], fixed = TRUE) && grepl("entropy", stack_names[4], fixed = TRUE) && grepl("homogeneity", stack_names[5], fixed = TRUE) && grepl("mean", stack_names[6], fixed = TRUE) && grepl("second_moment", stack_names[7], fixed = TRUE) && grepl("variance", stack_names[8], fixed = TRUE)){
    
    print(paste0("GLCM properly stacked for: ",  glcm_set[i]))
    
    
    glcm_bands <- aggregate(glcm_stack, fact = 4, mean)
    
    
    ms_bands <- stack(file.path("MS", ms_set[j]))
    
    glcm_band_extended <- crop(extend(glcm_bands, ms_bands), ms_bands)
    
    full_band <- stack(ms_bands, glcm_band_extended)
    
    
    island_output <- paste0(substr(ms_set[[j]], 1, nchar(ms_set[[j]])-14), "_combined_bands.tif")
    writeRaster(full_band, island_output, overwrite =TRUE)
    
    
    print(paste0("finished stacking for count ", j, ": ",  glcm_set[i], " at ", Sys.time()))
  } else {
    print("GLCM improperly stacked")
  }
}


