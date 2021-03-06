################################################################################
    
   # Across the United States, how have emissions from coal combustion-related 
   # sources changed from 1999–2008?

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

coal.selection<-grepl("coal",SCC$Short.Name,ignore.case = TRUE) & (
                grepl("comb",SCC$Short.Name,ignore.case=TRUE) |
                grepl("fuel",SCC$Short.Name,ignore.case=TRUE)
                )   
               
scc.coal<-filter(SCC,coal.selection)   
data<-filter(NEI,SCC %in% scc.coal$SCC)
sum.EmissionByYear<-ddply(data,.(year),function(x) sum(x$Emissions))
sum.EmissionByYear$year<-factor(c(1999,2002,2005,2008))

png("Figure/plot4.png")
ggplot(sum.EmissionByYear,aes(year,V1))+
      geom_bar(stat="identity",fill="steelblue")+
      ylab("Coal combustion emissions")+
      ggtitle("Total coal combustion emissions by year")+
      theme_minimal()
dev.off()