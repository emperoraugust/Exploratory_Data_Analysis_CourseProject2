################################################################################

   # Compare emissions from motor vehicle sources in Baltimore City with 
   # emissions from motor vehicle sources in Los Angeles County, California  
   # (fips == "06037"). Which city has seen greater changes over time in motor     
   # vehicle emissions?

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
data.Baltimora<-filter(NEI,fips=="24510")
data.LosAngeles<-filter(NEI,fips == "06037")

veh.selection<-grepl("vehicles",SCC$EI.Sector,ignore.case = TRUE)
scc.veh<-filter(SCC,veh.selection)

data.Baltimora<-filter(data.Baltimora,SCC %in% scc.veh$SCC)
data.LosAngeles<-filter(data.LosAngeles,SCC %in% scc.veh$SCC)

sum.BaltimoraEmission<-ddply(data.Baltimora,.(year), function(x) sum(x$Emissions))
sum.BaltimoraEmission$year<-factor(c("1999","2002","2005","2008"))

sum.LosAngelesEmission<-ddply(data.LosAngeles,.(year), function(x) sum(x$Emissions))
sum.LosAngelesEmission$year<-factor(c("1999","2002","2005","2008"))

bind = rbind(sum.BaltimoraEmission,sum.LosAngelesEmission)
bind$Location<-rep(c("Baltimora City","Los Angeles County"),c(4,4))

png("Figure/plot6.png",width=600)
ggplot(bind, aes(year,V1,group=Location,col=Location)) + 
      geom_point(size=3) + geom_line(size=1)+
      ylab("Vehicles emissions")+
      ggtitle("Comparision of Vehicles emission")+
      theme_minimal()
dev.off()
