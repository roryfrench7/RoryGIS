install.packages("sqldf")
library(sqldf)
geochem_data <- read.csv("D:/Github/RoryGIS/whole_rock_geochem.csv")

## return sample information with highest concentration of Nickel

sqldf("SELECT * FROM geochem_data WHERE Ni_ppm = (select Max(Ni_ppm) FROM geochem_data)")


## select highest concentration of Lithium from dataset
      
sqldf("SELECT Sn_ppm FROM geochem_data WHERE Sn_ppm = (select Max(Sn_ppm) FROM geochem_data)")

## order sample information by concentration of Copper

sqldf("SELECT * FROM geochem_data ORDER BY Cu_ppm")
