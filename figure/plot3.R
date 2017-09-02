##1. Extract and format data

## Activate relevant package
library(chron)
library(dplyr)

## Unzip file
zipfile="./Exploratory data analysis/week1Data.zip"
unzip(zipfile)

## Read only relevant data
datatable=read.table("./household_power_consumption.txt", skip=
                       grep("1/2/2007", readLines("household_power_consumption.txt"))[1]-1,nrows=2880,sep=";")

## Name the columns
colnames(datatable)<-c("Date","Time","Global_Active_Power","Global_Reactive_Power",
                       "Voltage","Global_intensity","Sub_metering1","Sub_metering2","Sub_metering3")


## Convert Date and Time
datatable$Date<-as.Date(datatable$Date,"%d/%m/%Y")
datatable$Time<-times(datatable$Time)
datatable<-mutate(datatable, Time = paste(datatable$Date,datatable$Time,sep=" "))
datatable$Time<-strptime(datatable$Time,"%Y-%m-%d %H:%M:%S")

## No missig values -- Data have been tested directly in the console

## Reshape the table to have all the "Sub_metering" columns in 1 column
dataSub_metering<-cbind(datatable$Time,stack(datatable[,7:9]))
colnames(dataSub_metering)<-c("Time2","Energy_sub_metering_value","Sub_metering_type")

## 2. Create the PNG file and Plot3

png("plot3.png",500,480)

with(dataSub_metering, plot(Time2,Energy_sub_metering_value,type="n",ylab="Energy sub metering",xlab=""))
with(subset(dataSub_metering,Sub_metering_type == "Sub_metering1"),lines(Time2,Energy_sub_metering_value,col="black"))
with(subset(dataSub_metering,Sub_metering_type == "Sub_metering2"),lines(Time2,Energy_sub_metering_value,col="red"))
with(subset(dataSub_metering,Sub_metering_type == "Sub_metering3"),lines(Time2,Energy_sub_metering_value,col="blue"))

legend("topright",lty=c(1,1),col=c("black","red","blue"),
       legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

dev.off
