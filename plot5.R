################################################################################
   
    # 5. How have emissions from motor vehicle sources changed from 1999–2008 in
    # Baltimore City?

################################################################################

library(dplyr)
library(ggplot2)
library(plyr)

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
veh.selection<-grepl("vehicles",SCC$EI.Sector,ignore.case = TRUE)
scc.veh<-filter(SCC,veh.selection)
data<-filter(data,SCC %in% scc.veh$SCC)

sum.EmissionByYear<-ddply(data,.(year), function(x) sum(x$Emissions))
sum.EmissionByYear$year<-factor(c("1999","2002","2005","2008"))

png("Figure/plot5.png")
ggplot(sum.EmissionByYear,aes(year,V1))+
      geom_bar(stat="identity",fill="steelblue")+
      ylab("Vehicles emissions")+
      ggtitle("Total vehicles emissions by year in Baltimora City")+
      theme_minimal()
dev.off()
