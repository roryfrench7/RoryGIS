install.packages("sf")
install.packages("sp")
install.packages("spbabel")
install.packages("rgeos")
install.packages("rgdal")
install.packages("raster")

library(sf)
library(sp)
library(spbabel)
library(rgeos)
library(rgdal)
library(raster)

## Merge shapefiles in a loop

poly_set <- list.files("D:/Github/RoryGIS", pattern = ".shp")
for (a in 1:(length(poly_set)-1)){
  shp1 <- readOGR(poly_set[a])
  shp2 <- readOGR(poly_set[a+1])
  merge_poly <- bind(shp1, shp2)
  writeOGR(merge_poly, "D:/Github/RoryGIS",
           layer = paste0(substr(poly_set[[a]], 1, nchar(poly_set[[a]])-4), "_", a+1,  "_merged"), 
           driver= "ESRI Shapefile", 
           overwrite_layer= T)
  print(paste0("finished merging", ": ",  poly_set[a]," and ", poly_set[a+1], " at ", Sys.time()))
}


##Merge two specific shapefiles
poly_set <- list.files("D:/Github/RoryGIS", pattern = ".shp")
print(poly_set)

i <- 1
j <- 2

poly1 <- readOGR(poly_set[i])
poly2 <- readOGR(poly_set[j])

merge_poly <- bind(poly1,poly2)
writeOGR(merge_poly, "D:/Github/RoryGIS",
         layer = paste0(substr(poly_set[[i]], 1, nchar(poly_set[[i]])-4), "_", j,  "_merged"), 
         driver= "ESRI Shapefile", 
         overwrite_layer= T)

## Merge two specific rasters with same # of bands

raster_set <- list.files("D:/Github/RoryGIS", pattern = ".tif")
print(raster_set)
i <- 1
j <- 2

raster1 <- stack(raster_set[i])
raster2 <- stack(raster_set[j])
res(raster1) <- c(xres(raster2), yres(raster2)) ##Match rasters resolution
crs(raster1) <- crs(raster2) ##Match raster projections
origin(raster1) <- origin(raster2) ##Match raster origins


merged_raster <- merge(raster1, raster2)
output_raster <- paste0(substr(raster_set[[i]], 1, nchar(poly_set[[i]])-4), "_", j,  "_merged.tif")
writeRaster(merged_raster, output_raster, overwrite = TRUE)




