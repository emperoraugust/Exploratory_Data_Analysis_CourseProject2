################################################################################

  # Of the four types of sources indicated by the type 
  # (point, nonpoint, onroad, nonroad) variable, which of these four sources 
  # have seen decreases in emissions from 1999–2008 for Baltimore City? 
  # Which have seen increases in emissions from 1999–2008? Use the ggplot2 
  # plotting system to make a plot answer this question.

################################################################################

library(dplyr)
library(ggplot2)
library(plyr)


# I have not make use of facet because I want to delete the outliers because it 
# makes the boxplot unreadble. I have decided to plot four bloxplots using 
# precomputed values and merging all in a unique image. 

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

data<-mutate(data,year = factor(rep(c(1999,2002,2005,2008),
                                    c(nrow(filter(data,year==1999)),
                                      nrow(filter(data,year==2002)),
                                      nrow(filter(data,year==2005)),
                                      nrow(filter(data,year==2008))))))

newData<-ddply(data,.(year,type),function(x) sum(x$Emissions))

#qplot(year, V1, data = newData, color = type,
#      main="Emissions by type in Baltimora City ",
#      ylab="Total emission",
#      geom=c("point","line"))

png("Figure/plot3.png",width=600,height = 480)
ggplot(newData,aes(year,V1,color=type,group=type))+
      geom_point(size=3)+
      geom_line(size=0.8)+
      xlab("Year")+
      ylab("Total emissions")+
      ggtitle("Total emissions by type in Baltimora City")
dev.off()

