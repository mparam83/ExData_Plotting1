## Title: Exploratory Data Analysis - Week 1 Course Project
## Author: Meenakshi Parameshwaran
## Date: 08/01/16

## Plot 3 ##

## Set the working directory

setwd("~/GitHub/ExData_Plotting1")

## Get the Electric power consumption data from the UCI Irvine Machine Learning Repository

myurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

download.file(url = myurl, destfile = "power.zip", method = "curl")

unzip(zipfile = "power.zip", exdir = "./") # unzips to the same directory

# read in the data
powerdata <- read.table(file = "household_power_consumption.txt", sep = ";", header = T, stringsAsFactors = F, strip.white = T)

## Explore the data
dim(powerdata)
names(powerdata)
head(powerdata)

## Convert the Date and Time fields from character to Date and Time formats

class(powerdata$Date)
class(powerdata$Time)

library(lubridate) # use the lubridate package to fix the dates and times
powerdata$Date <- parse_date_time(powerdata$Date, "dmy")
powerdata$Time <- fast_strptime(powerdata$Time, "%H:%M:%S")

# check dates and times look ok
head(powerdata)

## Select data within just the dates needed - 2007-02-01 and 2007-02-02
febpower <- subset(powerdata, Date >= "2007-02-01" & Date <= "2007-02-02")

# check febpower data is looking ok
head(febpower)

# check classes of the columns
lapply(febpower, function(x) class(x))

# change some col classes to numeric
mycols <- c(3:9)
febpower[,mycols] <- apply(febpower[,mycols], 2, function(x) as.numeric(x))

# change dates and times back to characters
febpower$Date <- as.character(febpower$Date)
febpower$Time <- as.character(febpower$Time)

# keep only the time part of the time var (get rid of the leading date part)
febpower$Time2 <- substr(febpower$Time, 11, 19)

# paste together the date and new time to create a combined date-time variable
febpower$DateTime <- paste(febpower$Date, febpower$Time2)

# turn the new DateTime variable into the Date Time format
febpower$DateTime <- ymd_hms(febpower$DateTime)
class(febpower$DateTime)

# create a variable for day of the week
febpower$Day <- wday(febpower$Date, label = T, abbr = T)
table(febpower$Day)
levels(febpower$Day) # check the labels fo the days
levels(febpower$Day)[5] <- "Thu"
table(febpower$Day)

## Code for PLOT 3

# find the three meter reading vars of interest
names(febpower)

# save the file as plot3.png
png(file = "plot3.png", width = 480, height = 480)

# prepare the empty plot of energy meter readings by datetime
plot.new()
with(febpower, plot(DateTime, Sub_metering_1, type = "n", xlab = "", ylab = "Energy sub metering"))

# add the first meter
with(febpower, lines(DateTime, Sub_metering_1, type = "l", col = "black"))

# add the second meter
with(febpower, lines(DateTime, Sub_metering_2, type = "l", col = "red"))

# add the third meter
with(febpower, lines(DateTime, Sub_metering_3, type = "l", col = "blue"))

# add in the legend 
legend("topright", lty = 1, legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"))

dev.off() # close the device

## END ##
