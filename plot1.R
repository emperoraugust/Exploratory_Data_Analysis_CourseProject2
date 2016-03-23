library(dplyr)


source("downloadFileScript.R")    #Load the dataset

data99<-filter(NEI,NEI$year==1999)
data02<-filter(NEI,NEI$year==2002)
data05<-filter(NEI,NEI$year==2005)
data08<-filter(NEI,NEI$year==2008)

data<-rbind(data99,data02,data05,data08)
data<-mutate(data, year=factor(rep(c("1999","2002","2005","2008"),c(nrow(data99),
                                                                    nrow(data02),
                                                                    nrow(data05),
                                                                    nrow(data08)
                                                                    ))))
#set.seed(20893)
#idx<-sample(nrow(data),5000)
boxplot(Emissions~year, data=data,outline=FALSE,
        main="PM emissions in years 1999, 2002,2005,2008",
        xlab="Year",
        ylab="PM emissions")


dev.copy(png, file = "Figure/plot1.png")
dev.off()
