
if(!dir.exists("Data")){
      message("Directory Data doesn't exists.")
      message("Creation of the directory Data.")
      dir.create("Data")
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