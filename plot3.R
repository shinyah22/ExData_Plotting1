# ライブラリの読み込み
library(ggplot2)

# データのロードと前処理
load_data <- function(filepath) {
  data <- read.table(filepath, header = TRUE, sep = ";", na.strings = "?", 
                     colClasses = c("character", "character", "numeric", "numeric", 
                                    "numeric", "numeric", "numeric", "numeric", "numeric"))
  data$Date <- as.Date(data$Date, format="%d/%m/%Y")
  data$Time <- strptime(data$Time, format="%H:%M:%S")
  data$DateTime <- as.POSIXct(paste(data$Date, format(data$Time, "%H:%M:%S")), format="%Y-%m-%d %H:%M:%S")
  data <- subset(data, data$Date >= as.Date("2007-02-01") & data$Date < as.Date("2007-02-03"))
  data$Weekday <- weekdays(data$DateTime)
  return(data)
}

# データの読み込み
data <- load_data("household_power_consumption.txt") # ファイルパスを適切なものに置き換えてください。

# プロット3の作成
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

# プロットをPNGファイルに保存
ggsave("plot3.png", plot3, width = 480 / 96, height = 480 / 96, dpi = 96)
