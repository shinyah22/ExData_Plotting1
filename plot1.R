# Load required packages
library(ggplot2)

# Define a function to load data
load_data <- function(filepath) {
  # Read data from the specified file
  # Treat '?' as NA while reading data
  data <- read.table(filepath, header = TRUE, sep = ";", na.strings = "?")
  
  # Convert Date and Time into POSIXct and combine them
  data$Datetime <- as.POSIXct(paste(data$Date, data$Time), format="%d/%m/%Y %H:%M:%S")
  
  # Retrieve the necessary subset of data
  data <- subset(data, Datetime >= as.POSIXct("2007-02-01") & Datetime < as.POSIXct("2007-02-03"))
  
  return(data)
}

# Load the data
data <- load_data("household_power_consumption.txt")  # Replace with your actual data file path

# Create Plot 2
plot2 <- ggplot(data, aes(x = Datetime, y = Global_active_power)) +
  geom_line() +
  labs(title = "Global Active Power",
       x = "Time",
       y = "Global Active Power (kilowatts)") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Save Plot 2 as a PNG file
ggsave("plot2.png", plot2, width = 480 / 96, height = 480 / 96, dpi = 96)
