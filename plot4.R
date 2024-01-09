# 必要なライブラリをロード
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("gridExtra")) install.packages("gridExtra")
library(ggplot2)
library(gridExtra)

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

# データを読み込む
data <- load_data("household_power_consumption.txt")

# プロット4: Global Active Powerのラインプロット
plot4 <- ggplot(data, aes(x = DateTime, y = Global_active_power)) +
  geom_line(color = "blue") +
  labs(x = "Time", y = "Global Active Power (kilowatts)")

# プロット5: 時間ごとの電圧のラインプロット
plot5 <- ggplot(data, aes(x = DateTime, y = Voltage)) +
  geom_line(color = "red") +
  labs(x = "Time", y = "Voltage (Volts)")

# プロット6: 各サブメータリングの時間ごとのラインプロット
plot6 <- ggplot(data) +
  geom_line(aes(x = DateTime, y = Sub_metering_1), color = "red") +
  geom_line(aes(x = DateTime, y = Sub_metering_2), color = "green") +
  geom_line(aes(x = DateTime, y = Sub_metering_3), color = "blue") +
  labs(x = "Time", y = "Sub_metering (Watt-hours)")

# プロット7: 時間ごとのGlobal Active Powerのラインプロット
plot7 <- ggplot(data, aes(x = DateTime, y = Global_reactive_power)) +
  geom_line(color = "green") +
  labs(x = "Time", y = "Global Reactive Power (kilowatts)")

# 全てのプロットを1つのファイルにまとめる
multiplot <- grid.arrange(plot4, plot5, plot6, plot7, nrow = 2, ncol = 2)

# マルチプロットをPNGファイルに保存
ggsave("plot4.png", multiplot, width = 504/96, height = 504/96, dpi = 96)
