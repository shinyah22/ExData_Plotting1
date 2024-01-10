library(data.table)

# Load data
file_path <- "household_power_consumption.txt"
data <- fread(file_path, colClasses = c("character", "character", rep("numeric", 7)), na.strings = "?")

# Preprocess data
data[, Date := as.Date(Date, format="%d/%m/%Y")]
data[, Time := as.POSIXct(Time, format="%H:%M:%S")]
subset_data <- data[Date >= as.Date("2007-02-01") & Date <= as.Date("2007-02-02")]
subset_data[, weekday := weekdays(Date)]

# Define the positions for the x-axis ticks
thursday_start <- which(subset_data$weekday == "Thursday")[1]
friday_start <- which(subset_data$weekday == "Friday")[1]
saturday_start <- length(subset_data$Global_active_power)
xaxt <- c(thursday_start, friday_start, saturday_start)
xaxt_labels <- c("Thu", "Fri", "Sat")

# Start the PNG device
png_filename <- "plot4.png"
png(png_filename, width = 480, height = 480)

# Set up a 2x2 plot layout
par(mfrow=c(2,2))

# List of columns to plot
column_list <- c("Global_active_power", "Voltage", "Global_reactive_power")

# Plot the first two columns
for (y_column_name in column_list[1:2]) {
  ylab <- gsub("_", " ", y_column_name)
  ylab <- sapply(strsplit(ylab, " ")[[1]], function(word) {
    paste(toupper(substring(word, 1, 1)), substring(word, 2), sep = "", collapse = NULL)
  })
  ylab <- paste(ylab, collapse = " ")
  
  plot(subset_data[[y_column_name]], type = "l", xaxt = "n", xlab = "Datetime", 
       ylab = ylab, xlim = c(1, length(subset_data[[y_column_name]])), 
       ylim = range(subset_data[[y_column_name]], na.rm = TRUE))
  axis(1, at = xaxt, labels = xaxt_labels)
}

# Plot the third plot with plot_time_series_3_line
# Plot the data for sub-metering 1, 2, and 3
plot(subset_data$Sub_metering_1, type = "l", col = "black", xaxt = "n", xlab = "", ylab = "Energy sub metering", 
     xlim = c(1, length(subset_data$Global_active_power)), ylim = range(c(subset_data$Sub_metering_1, subset_data$Sub_metering_2, subset_data$Sub_metering_3), na.rm = TRUE))
lines(subset_data$Sub_metering_2, type = "l", col = "red")
lines(subset_data$Sub_metering_3, type = "l", col = "blue")
axis(1, at = xaxt, labels = xaxt_labels)
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col = c("black", "red", "blue"), lty = 1)

# If there's a fourth y-column, plot it; otherwise, leave the space blank
if (length(column_list) > 2) {
  y_column_name <- column_list[3]
  ylab <- gsub("_", " ", y_column_name)
  ylab <- sapply(strsplit(ylab, " ")[[1]], function(word) {
    paste(toupper(substring(word, 1, 1)), substring(word, 2), sep = "", collapse = NULL)
  })
  ylab <- paste(ylab, collapse = " ")
  
  plot(subset_data[[y_column_name]], type = "l", xaxt = "n", xlab = "Datetime", 
       ylab = ylab, xlim = c(1, length(subset_data[[y_column_name]])), 
       ylim = range(subset_data[[y_column_name]], na.rm = TRUE))
  axis(1, at = xaxt, labels = xaxt_labels)
}

# End the PNG device
dev.off()
