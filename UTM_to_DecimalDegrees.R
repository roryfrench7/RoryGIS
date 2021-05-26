"""
Read data table and convert UTM xy coordinates to a specified coordinate system. 
The first two columns of the input csv should be the XY coordinates.
"""

library(sp)

coord_set <- list.files("D:/Kobold_Metals/UTM_Coord", pattern = ".csv")
print(coord_set)
i=1
coord_list <- read.csv(coord_set[i])

utm_coord <- SpatialPoints(cbind(coord_list[1],coord_list[2]), proj4string=CRS("+init=epsg:26716")) #Create shapefile from input csv, need to assigns its existing coord system

wgs_coord <- spTransform(utm_coord, CRS("+proj=longlat")) #Reproject shapefile to specified coordinate system

write.csv(wgs_coord, coord_set[i]) #Rewrite new coordinate points to file




+init=epsg:26718 "NAD27 Zone 18N"
+init=epsg:26716 "NAD27 Zone 16N"
+proj=utm +zone=15N "NAD84 Zone 15N"