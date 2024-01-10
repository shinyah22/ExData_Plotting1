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

# Define the positions for the x-axis ticks
thursday_start <- which(subset_data$weekday == "Thursday")[1]
friday_start <- which(subset_data$weekday == "Friday")[1]
saturday_start <- length(subset_data$Global_active_power)
xaxt <- c(thursday_start, friday_start, saturday_start)
xaxt_labels <- c("Thu", "Fri", "Sat")

# Plotting
png_filename <- "plot2.png"
png(png_filename, width = 480, height = 480)

# Check if the specified y_column_name exists in subset_data
y_column_name <- "Global_active_power"
if (!y_column_name %in% names(subset_data)) {
  stop("The specified column does not exist in the data.")
}

# Remove the _ from the y_column_name and capitalize the first letter of each word
ylab <- gsub("_", " ", y_column_name)
ylab <- sapply(strsplit(ylab, " ")[[1]], function(word) {
  paste(toupper(substring(word, 1, 1)), substring(word, 2), sep = "", collapse = NULL)
})
ylab <- paste(ylab, collapse = " ")

# Plot the data using the specified y_column_name
plot(subset_data[[y_column_name]], type = "l", xaxt = "n", xlab = "Time", 
     ylab = ylab, xlim = c(1, length(subset_data[[y_column_name]])), 
     ylim = range(subset_data[[y_column_name]], na.rm = TRUE))

# Add the custom x-axis
axis(1, at = xaxt, labels = xaxt_labels)

# End the PNG device
dev.off()
