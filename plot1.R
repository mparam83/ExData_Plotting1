## Title: Exploratory Data Analysis - Week 1 Course Project
## Author: Meenakshi Parameshwaran
## Date: 08/01/16

## Plot 1 ##

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

# could have just read in the subset of the data at the start using sqlf e.g.
# power <- file("household_power_consumption.txt") 
# attr(power, "file.format") <- list(sep = ";", header = TRUE) 
# febpower <- sqldf("select * from power where Date in ('1/2/2007', '2/2/2007')")

# check febpower data is looking ok
head(febpower)

# check classes of the columns
lapply(febpower, function(x) class(x))

# change some col classes to numeric
mycols <- c(3:9)
febpower[,mycols] <- apply(febpower[,mycols], 2, function(x) as.numeric(x))

# tidy up by removing the full dataset
rm(powerdata)
       
## Code for PLOT 1

# make the histogram of global active power
with(febpower, hist(Global_active_power, col = "Red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)"))

# save the file as plot1.png
dev.copy(png, "plot1.png", width = 480, height = 480)
dev.off() # close the device

## END ##
