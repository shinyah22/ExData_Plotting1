# Load necessary libraries
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("gridExtra")) install.packages("gridExtra")
library(ggplot2)
library(gridExtra)

# Function to load and preprocess the data
load_data <- function(filepath) {
  data <- read.table(filepath, header = TRUE, sep = ";", na.strings = "?", 
                     colClasses = c("character", "character", "numeric", "numeric", 
                                    "numeric", "numeric", "numeric", "numeric", "numeric"))
  data$Date <- as.Date(data$Date, format="%d/%m/%Y")
  data$Time <- strptime(data$Time, format="%H:%M:%S")
  data$DateTime <- as.POSIXct(paste(data$Date, format(data$Time, "%H:%M:%S")), format="%Y-%m-%d %H:%M:%S")
  # Filter data for the dates of interest
  data <- subset(data, data$Date >= as.Date("2007-02-01") & data$Date < as.Date("2007-02-03"))
  # Extract the day of the week
  data$Weekday <- weekdays(data$DateTime)
  return(data)
}

# Load the data
data <- load_data("household_power_consumption.txt")  # Replace with the actual file path

# Plot 4a: Line plot for Global Active Power
plot4a <- ggplot(data, aes(x = DateTime, y = Global_active_power)) +
  geom_line(color = "blue") +
  labs(x = "Time", y = "Global Active Power (kilowatts)")

# Plot 4b: Line plot for Voltage over time
plot4b <- ggplot(data, aes(x = DateTime, y = Voltage)) +
  geom_line(color = "red") +
  labs(x = "Time", y = "Voltage (Volts)")

# Plot 4c: Line plots for each sub-metering value over time
plot4c <- ggplot(data) +
  geom_line(aes(x = DateTime, y = Sub_metering_1), color = "red") +
  geom_line(aes(x = DateTime, y = Sub_metering_2), color = "green") +
  geom_line(aes(x = DateTime, y = Sub_metering_3), color = "blue") +
  labs(x = "Time", y = "Sub_metering (Watt-hours)")

# Plot 4d: Line plot for Global Reactive Power over time
plot4d <- ggplot(data, aes(x = DateTime, y = Global_reactive_power)) +
  geom_line(color = "green") +
  labs(x = "Time", y = "Global Reactive Power (kilowatts)")

# Combine all plots into one file
plot4 <- grid.arrange(plot4a, plot4b, plot4c, plot4d, nrow = 2, ncol = 2)

# Save the plot4 to a PNG file
ggsave("plot4.png", multiplot, width = 504/96, height = 504/96, dpi = 96)
