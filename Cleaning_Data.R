"""
Provide some examples of cleaning data for either a data table in csv or shapefile format.Perform tasks such as data
manipulation, class type conversion, and column renaming. This is used on random example files from my computer to
demonstrate basic actions taken to clean data.
"""




library(raster)
library(rgdal)
library(dplyr)


## Clean data of data frame

  csv1 <- read.csv("whole_rock_geochem.csv")
 
  ## Check out summary of file
 
  names(csv1)
  glimpse(csv1)
 
  ##Rename column headers
 
  colnames(csv1)[2] <- "Longitude"
  colnames(csv1)[3] <- "Latitude"
  colnames(csv1)[48]<- "Sn_%wt"
 
  ##Delete unneeded column
 
  csv2 <- csv1[,-(49:51)]
 
   ##Convert data in a column (from ppm to %wt in column 48)
  
  csv2$`Sn_%wt` <- csv2$`Sn_%wt` / 10000
  
  ##Change null data to values in column (<d/l to NA)
  
  csv2[csv2 == "<d/l"] <- NA  ##change to NA
  
  factor_cols <- sapply(csv2, is.factor) #Create logical column of factor class type
  csv2[factor_cols] <- lapply(csv2[factor_cols], as.character) ## Change only factor type columns to character
  csv2[is.na(csv2)] <- 0      ##Change NA to zeros
  
 
  
  
  
 
##Clean data of shapefile

   shp1 <- readOGR(dsn = "D:/Github/RoryGIS", layer = "alberta_poly")
 
   ## Check out summary of file
   names(shp1)
   glimpse(shp1)
   summary(shp1)
 
   ## Delete unneeded columns
 
   shp2 <- shp1[,-(9:11)]
 
 
   ## Rename column headers
 
   colnames(shp2@data)[5] <- "Study_Level"
   colnames(shp2@data)[4] <- "Area_Km2"
 
   ## Convert data in a column (for this example column 4 from hectare to km2)
 
   shp2$Area_Km2 <- shp2$Area_Km2 / 100

   ## Convert null data in column to values
 
   shp2$THICKNESS <- as.numeric(as.character(shp2$THICKNESS)) ##Change class factor to numeric data type
   shp2$THICKNESS[is.na(shp2$THICKNESS)] <- 0 ## Reassign NA values with zeros

