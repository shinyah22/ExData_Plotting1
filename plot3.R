library(data.table)

# Load data
file_path <- "household_power_consumption.txt"
data <- fread(file_path, 
              colClasses = c("character", "character", rep("numeric", 7)),
              na.strings = "?")

# Preprocess data
data[, Date := as.Date(Date, format="%d/%m/%Y")]
data[, Time := as.POSIXct(Time, format="%H:%M:%S")]
subset_data <- data[Date >= as.Date("2007-02-01") & Date <= as.Date("2007-02-02")]
subset_data[, weekday := weekdays(Date)]

# Plotting
png_filename <- "plot3.png"
png(png_filename, width = 480, height = 480)

# Find the start index for Thursday and Friday
thursday_start <- which(subset_data$weekday == "Thursday")[1]
friday_start <- which(subset_data$weekday == "Friday")[1]
saturday_start <- length(subset_data$Global_active_power)

# Define the positions for the x-axis ticks
xaxt <- c(thursday_start, friday_start, saturday_start)

# Define the labels for the x-axis ticks
xaxt_labels <- c("Thu", "Fri", "Sat")

# Plot the data for sub-metering 1, 2, and 3
plot(subset_data$Sub_metering_1, type = "l", col = "black", xaxt = "n", xlab = "", ylab = "Energy sub metering", 
     xlim = c(1, length(subset_data$Global_active_power)), ylim = range(c(subset_data$Sub_metering_1, subset_data$Sub_metering_2, subset_data$Sub_metering_3), na.rm = TRUE))
lines(subset_data$Sub_metering_2, type = "l", col = "red")
lines(subset_data$Sub_metering_3, type = "l", col = "blue")

# Add the custom x-axis
axis(1, at = xaxt, labels = xaxt_labels)

# Add a legend
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col = c("black", "red", "blue"), lty = 1)

# End the PNG device
dev.off()

