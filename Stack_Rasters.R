""" 
Stack rasters of GLCM bands to rasters of Multispectral bands for the same island rasters. I do not feel
comfortable sharing the files this code ran on, as it satellite imagery purchased by The Nature Conservancy.
For each island, there are 8 individual GLCM rasters and 1 Multispectral raster with 8 bands. Final island
rasters will have 16 bands. 8 GLCM and 8 Multispectral.
"""


library(sf)
library(sp)
library(spbabel)
library(raster)


setwd("D:/Coconut_Imagery/Combined_Rasters")

glcm_set <- list.files("GLCM/", pattern = ".tif") ##read GLCM rasters of islands
ms_set <- list.files("MS/", pattern= ".tif")  ##read multispectral rasters of islands
j = 0 

for (i in seq(1, length(glcm_set), 8)) { #for loop runs in intervals of 8 because there are 8 consecutive GLCM files in folder for each individual island
  
  j = j+1 ##j counter tracks the multispectral raster files
  
  print(paste0("Started aggregating for count ", j, ": ",  glcm_set[i], " at ", Sys.time()))
  
  
  glcm_stack <- stack((file.path("GLCM", glcm_set[i])), (file.path("GLCM", glcm_set[i+1])), (file.path("GLCM", glcm_set[i+2])), (file.path("GLCM", glcm_set[i+3])), (file.path("GLCM", glcm_set[i+4])), (file.path("GLCM", glcm_set[i+5])), (file.path("GLCM", glcm_set[i+6])), (file.path("GLCM", glcm_set[i+7])))
  ##stacks all 8 GLCM rasters into 1 raster named glcm_stack
  
  stack_names <- names(glcm_stack)
  
  if (grepl("contrast", stack_names[1], fixed = TRUE) && grepl("correlation", stack_names[2], fixed = TRUE) && grepl("dissimilarity", stack_names[3], fixed = TRUE) && grepl("entropy", stack_names[4], fixed = TRUE) && grepl("homogeneity", stack_names[5], fixed = TRUE) && grepl("mean", stack_names[6], fixed = TRUE) && grepl("second_moment", stack_names[7], fixed = TRUE) && grepl("variance", stack_names[8], fixed = TRUE)){
    ##use grepl to make sure the 8 GLCM layers all saved in the appropriate order for each island
    print(paste0("GLCM properly stacked for: ",  glcm_set[i]))
    
    
    glcm_bands <- aggregate(glcm_stack, fact = 4, mean) ##glcm bands have resolution of 0.5 m, so aggregate is needed to increase resolution to 2.0m to match Multispectral raster resolution
    
    
    ms_bands <- stack(file.path("MS", ms_set[j])) ##create raster file of multispectral raster
    
    glcm_band_extended <- crop(extend(glcm_bands, ms_bands), ms_bands) ##match glcm_stack to extent of ms_bands
    
    full_band <- stack(ms_bands, glcm_band_extended) ##stack glcm bands to ms_bands
    
    
    island_output <- paste0(substr(ms_set[[j]], 1, nchar(ms_set[[j]])-14), "_combined_bands.tif") ##set output file name
    writeRaster(full_band, island_output, overwrite =TRUE) ##write combined raster of 16 bands to folder
    
    
    print(paste0("finished stacking for count ", j, ": ",  glcm_set[i], " at ", Sys.time())) ##note the time it takes between islands when scripting
  } else {
    print("GLCM improperly stacked")
  }
}


