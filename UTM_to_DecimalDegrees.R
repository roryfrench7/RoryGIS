library(sp)


coord_set <- list.files("D:/Kobold_Metals/UTM_Coord", pattern = ".csv")
print(coord_set)
i=1
coord_list <- read.csv(coord_set[i])

utm_coord <- SpatialPoints(cbind(coord_list[1],coord_list[2]), proj4string=CRS("+init=epsg:26716"))

wgs_coord <- spTransform(utm_coord, CRS("+proj=longlat"))

write.csv(wgs_coord, coord_set[i])




+init=epsg:26718 "NAD27 Zone 18N"
+init=epsg:26716 "NAD27 Zone 16N"
+proj=utm +zone=15N "NAD84 Zone 15N"