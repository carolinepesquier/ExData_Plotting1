##1. Extract and format data

## Activate relevant package
library(chron)
library(dplyr)

## Unzip file
zipfile="./Exploratory data analysis/week1Data.zip"
unzip(zipfile)

## Read only relevant data
datatable=read.table("./household_power_consumption.txt", skip=
                       grep("1/2/2007", readLines("household_power_consumption.txt"))[1]-1,nrows=2880,sep=";",na.strings="?")

## Name the columns
colnames(datatable)<-c("Date","Time","Global_Active_Power","Global_Reactive_Power",
                       "Voltage","Global_intensity","Sub_metering1","Sub_metering2","Sub_metering3")


## Convert Date and Time
datatable$Date<-as.Date(datatable$Date,"%d/%m/%Y")
datatable$Time<-times(datatable$Time)
datatable<-mutate(datatable, Time = paste(datatable$Date,datatable$Time,sep=" "))
datatable$Time<-strptime(datatable$Time,"%Y-%m-%d %H:%M:%S")

## 2. Plot 2

with(datatable, plot(Time,Global_Active_Power,ylab="Global Active Power (kilowatts)",xlab="",type="l"))


##3. Export as PNG
dev.copy(png,file="plot2.png")
dev.off()
