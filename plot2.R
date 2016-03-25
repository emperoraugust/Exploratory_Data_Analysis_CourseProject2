################################################################################

   #Have total emissions from PM2.5 decreased in the Baltimore City, Maryland  
   #(fips == "24510") from 1999 to 2008? Use the base plotting system to make a 
   #plot answering this question.

################################################################################



library(dplyr)


#Load the data
if(!dir.exists("Data")){
      message("Directory Data doesn't exists.")
      message("Creation of the directory Data.")
      dir.create("Data")
}

if(!dir.exists("Figure")){
      dir.create("Figure")
}
dirDataZip<-"Data/data.zip"
dirFirstRds<-"Data/Source_Classification_Code.rds"
dirSecRds<-"Data/summarySCC_PM25.rds"

if(!file.exists(dirDataZip) && (!file.exists(dirFirstRds) || !file.exists(dirSecRds) )){
      url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
      message("Download of the data.zip in progress.")
      download.file(url,"Data/data.zip")
      message("Download completed.")
      unzip("Data/data.zip",exdir="Data")
}
NEI <- readRDS("Data/summarySCC_PM25.rds")
SCC <- readRDS("Data/Source_Classification_Code.rds")


#-------------------------------------------------------------------------------

data<-filter(NEI,fips=="24510")

totalPM <- tapply(data$Emissions, data$year, sum)
barplot(totalPM, xlab = "Year", ylab = "PM2.5 Emissions",
        main = "Total PM 2.5 Emissions (tons) in Baltimora City")

dev.copy(png, file = "Figure/plot2.png")
dev.off()

#The total emissions has essentially decreased (even if in 2005 the level 
# has temporarily increased)

