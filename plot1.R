# Define the destination where the file will be saved
destfile <- "household_power_consumption.zip"

# Unzip the file
unzip(destfile)

# 必要なパッケージを読み込む
if (!require(data.table)) {
  install.packages("data.table")
}
library(data.table)

# データファイルのパスを指定してください
file_path <- "household_power_consumption.txt"

# データを読み込む際に、特定の列の型を指定
data <- fread(file_path, 
              na.strings="?", 
              colClasses=c("character", "character", "numeric", "numeric", 
                           "numeric", "numeric", "numeric", "numeric", "numeric"),
              col.names=c("Date", "Time", "Global_active_power", "Global_reactive_power", 
                          "Voltage", "Global_intensity", "Sub_metering_1", 
                          "Sub_metering_2", "Sub_metering_3"))

# 日付と時刻を結合してPOSIXct型に変換
data[, DateTime := as.POSIXct(paste(Date, Time), format="%d/%m/%Y %H:%M:%S")]

# 2007年2月1日と2月2日のデータに絞る
data <- data[(DateTime >= "2007-02-01") & (DateTime < "2007-02-03")]

# プロットを作成する
png(file="plot1.png", width=480, height=480)
hist(data$Global_active_power, 
     main="Global Active Power", 
     xlab="Global Active Power (kilowatts)", 
     ylab="Frequency", 
     col="red")
dev.off()
