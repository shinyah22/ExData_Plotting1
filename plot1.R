# Define the destination where the file will be saved
destfile <- "household_power_consumption.zip"

# Unzip the file
unzip(destfile)

# Load the necessary package
if (!require(data.table)) {
  install.packages("data.table")
}
library(data.table)

# Please specify the path to the data file
file_path <- "household_power_consumption.txt"

# When loading the data, specify the type of certain columns
data <- fread(file_path, 
              na.strings="?", 
              colClasses=c("character", "character", "numeric", "numeric", 
                           "numeric", "numeric", "numeric", "numeric", "numeric"),
              col.names=c("Date", "Time", "Global_active_power", "Global_reactive_power", 
                          "Voltage", "Global_intensity", "Sub_metering_1", 
                          "Sub_metering_2", "Sub_metering_3"))

# Combine the Date and Time into a POSIXct type
data[, DateTime := as.POSIXct(paste(Date, Time), format="%d/%m/%Y %H:%M:%S")]

# Focus on the data from February 1st and 2nd, 2007
data <- data[(DateTime >= "2007-02-01") & (DateTime < "2007-02-03")]

# Create the plot
png(file="plot1.png", width=480, height=480)
hist(data$Global_active_power, 
     main="Global Active Power", 
     xlab="Global Active Power (kilowatts)", 
     ylab="Frequency", 
     col="red")
dev.off()
