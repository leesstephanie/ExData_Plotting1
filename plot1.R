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

#making the plot----
with(df, hist(as.numeric(Global_active_power), col = "orangered", axes = F, 
              main = "Global Active Power", 
              xlab = "Global Active Power (kilowatts)", ylab = "Frequency"))
axis(1, at = seq(0,6,2), lab = seq(0,6,2))
axis(2, at = seq(0, 1200, 200), lab = seq(0, 1200, 200))

dev.copy(png, "plot1.png")
dev.off()