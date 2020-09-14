library(lubridate)

#read data----
con <- file(description = "household_power_consumption.txt", "r")
df <- data.frame(Date = vector(), 
                 Time = vector(),
                 Global_active_power = vector(),
                 Global_reactive_power = vector(),
                 Voltage = vector(),
                 Global_intensity = vector(),
                 Sub_metering_1 = vector(),
                 Sub_metering_2 = vector(),
                 Sub_metering_3 = vector())
repeat {
    data <- readLines(con,1)
    l <- length(data)
    if (l > 0){
        split <- strsplit(data, split = ";")
        if (split[[1]][1] == "1/2/2007" | split[[1]][1] == "2/2/2007"){
            rowlist <- as.list(split[[1]])
            rowdf <- as.data.frame(rowlist, stringsAsFactors = F, 
                                   col.names = names(df))
            df <- rbind(df, rowdf)
        }
    } else{
        break
    }
}
close.connection(con)

#make the plot----
datetime <- mapply(paste, df$Date, df$Time)
datetime2 <- as_datetime(datetime, format = "%d/%m/%Y %H:%M:%S") #as_datetime() is from package lubridate

par(mfcol = c(2,2))

#plot1
plot(datetime2, as.numeric(df$Global_active_power), type = "l", 
     xlab = "", ylab = "Global Active Power (kilowatts)")

#plot2
plot(datetime2, df$Sub_metering_1, type = "l",
     xlab = "", ylab = "Energy sub metering")
lines(datetime2, df$Sub_metering_2, col = "red")
lines(datetime2, df$Sub_metering_3, col = "blue")
legend("topright", lty = 1, col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       bty = "n", y.intersp = 0.25,
       inset = c(-0.05, -0.15), xpd = TRUE, seg.len = 1)

#plot3
with(df, plot(datetime2, Voltage, type = "l", xlab = "datetime"))

#plot4
with(df, plot(datetime2, Global_reactive_power, type = "l", xlab = "datetime"))

dev.copy(png, "plot4.png")
dev.off()