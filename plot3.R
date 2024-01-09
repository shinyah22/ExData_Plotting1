# Load libraries
library(ggplot2)

# Function to load and preprocess the data
load_data <- function(filepath) {
  data <- read.table(filepath, header = TRUE, sep = ";", na.strings = "?", 
                     colClasses = c("character", "character", "numeric", "numeric", 
                                    "numeric", "numeric", "numeric", "numeric", "numeric"))
  # Convert the Date and Time into POSIXct format
  data$Date <- as.Date(data$Date, format="%d/%m/%Y")
  data$Time <- strptime(data$Time, format="%H:%M:%S")
  data$DateTime <- as.POSIXct(paste(data$Date, format(data$Time, "%H:%M:%S")), format="%Y-%m-%d %H:%M:%S")
  # Filter data for the specified dates
  data <- subset(data, data$Date >= as.Date("2007-02-01") & data$Date < as.Date("2007-02-03"))
  # Extract the weekday from the DateTime
  data$Weekday <- weekdays(data$DateTime)
  return(data)
}

# Load the data
data <- load_data("household_power_consumption.txt") # Replace with the appropriate file path.

# Create Plot 3
plot3 <- ggplot(data, aes(x = DateTime)) +
  geom_line(aes(y = Sub_metering_1, colour = "Sub_metering_1")) +
  geom_line(aes(y = Sub_metering_2, colour = "Sub_metering_2")) +
  geom_line(aes(y = Sub_metering_3, colour = "Sub_metering_3")) +
  labs(x = "Day of the Week",
       y = "Energy sub metering") +
  scale_colour_manual(values = c("Sub_metering_1" = "black", 
                                 "Sub_metering_2" = "red", 
                                 "Sub_metering_3" = "blue")) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Save the plot as a PNG file
ggsave("plot3.png", plot3, width = 480 / 96, height = 480 / 96, dpi = 96)
