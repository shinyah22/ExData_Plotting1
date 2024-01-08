# 必要なパッケージを読み込みます。
library(ggplot2)

# データを読み込む関数を定義します。
load_data <- function(filepath) {
  # 指定されたファイルからデータを読み込みます。
  # データの読み込み時に?をNAとして扱います。
  data <- read.table(filepath, header = TRUE, sep = ";", na.strings = "?")
  
  # 日付と時刻をPOSIXctに変換して統合します。
  data$Datetime <- as.POSIXct(paste(data$Date, data$Time), format="%d/%m/%Y %H:%M:%S")
  
  # 必要なデータのサブセットを取得します。
  data <- subset(data, Datetime >= as.POSIXct("2007-02-01") & Datetime < as.POSIXct("2007-02-03"))
  
  return(data)
}

# データをロードします。
data <- load_data("household_power_consumption.txt")

# プロット2を作成します。
plot2 <- ggplot(data, aes(x = Datetime, y = Global_active_power)) +
  geom_line() +
  labs(title = "Global Active Power",
       x = "Time",
       y = "Global Active Power (kilowatts)") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# プロット2をPNGファイルとして保存します。
ggsave("plot2.png", plot2, width = 480 / 96, height = 480 / 96, dpi = 96)
