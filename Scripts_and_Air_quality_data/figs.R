options(encoding = "UTF-8")
Sys.setlocale("LC_TIME", "English") # Windows
setwd("F:/MEGA/PostDoc/covid19/delivery/")
library(data.table, quietly = TRUE, warn.conflicts = FALSE)
library(ggplot2)
library(magick)
library(readxl)

# MP25 HOURLY####
f2 <- readRDS("RDS/MP25_2020.rds")
sink("stations/PM25stations.txt")
cat(paste0(unique(f2$stationname), ", "))
sink()

f2$date <- as.Date(f2$date)
ano <- year(f2$date)
month <- month(f2$date)
day <- strftime(f2$date, "%d")
f2$time <- ISOdatetime(ano, month, day, f2$hour - 1, 0, 0)
ff2 <- f2[time <= as.POSIXct("2020-04-13 08:00"), 
          mean(conc, na.rm = T), 
          by = .(time)]

names(ff2)[2] <- "V1_2020"
ff2$day <- strftime(ff2$time, "%a")

# 2019
f1 <- readRDS("RDS/MP25_2019.rds")
f1$date <- as.Date(f1$date)
ano <- year(f1$date)
month <- month(f1$date)
day <- strftime(f1$date, "%d")
f1$time <- ISOdatetime(ano, month, day, f1$hour - 1, 0, 0)
ff1 <- f1[, 
          mean(conc, na.rm = T), 
          by = .(time)]
names(ff1) <- c("time_2019", "V1_2019")
ff1$day <- strftime(ff1$time, "%a")
ff <- cbind(ff2, ff1[25:(nrow(ff2) + 24)])
ff <- ff[!is.na(V1_2020)]
ff[, media24h2020 := mean(V1_2020), by = .(strftime(time, "%Y-%m-%d"))]
ff[, media24h2019 := mean(V1_2019), by = .(strftime(time, "%Y-%m-%d"))]

dfin <- ff[time >= as.POSIXct("2020-03-17"), V1_2020 - V1_2019]
summary(dfin)

df <- ff[, c("time", "V1_2020",  "V1_2019")]
names(df) <- c("time", as.character(2020:2019))
df$WHO24h <- 25

shapiro.test(df$`2020`)
shapiro.test(df$`2019`)
ff[time >= as.POSIXct("2020-03-17"), t.test(V1_2020, V1_2019)]

dt <- vein::wide_to_long(df = df, column_with_data = names(df)[2:4],
                         column_fixed = "time")
setDT(dt)
dt
names(dt) <- c("PM25", "time", "data")

p <- ggplot(dt[time >= as.POSIXct("2020-03-17")],
            aes(x = time, y = PM25, colour = data)) +
  labs(title =expression(PM[2.5] ~μg*m^-3~"at MASP"), 
       subtitle =  paste0("2020 - 2019: ",
                          "Min = ", round(min(dfin), 2),
                          " Max = ", round(max(dfin), 2),
                          " Mean = ", round(mean(dfin), 2)),
       y = expression(μg*m^-3),
       x = NULL) + 
  scale_x_datetime(minor_breaks = "day") +
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-03-17 12:00"), 
           xmax = as.POSIXct("2020-03-21"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-03-26 15:00"), 
           xmax = as.POSIXct("2020-03-28 12:00"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-04-05 00:00"), 
           xmax = as.POSIXct("2020-04-07 18:00"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  geom_point(size = 1) +
  geom_line() +
  geom_smooth() +
  theme_bw()+
  scale_color_manual(values = c("red", "blue","black")) +
  theme(legend.title = element_blank()) 

png(filename = "figuras/PM25.png", 
    width = 3000, height = 1000, units = "px", res = 300)
print(p)
dev.off()

# MP10 HOURLY####
f2 <- readRDS("RDS/MP10_2020.rds")
sink("stations/PM10stations.txt")
cat(paste0(unique(f2$stationname), ", "))
sink()

f2$date <- as.Date(f2$date)
ano <- year(f2$date)
month <- month(f2$date)
day <- strftime(f2$date, "%d")
f2$time <- ISOdatetime(ano, month, day, f2$hour - 1, 0, 0)
ff2 <- f2[time <= as.POSIXct("2020-04-13 08:00"), 
          mean(conc, na.rm = T), 
          by = .(time)]

names(ff2)[2] <- "V1_2020"
ff2$day <- strftime(ff2$time, "%a")

# 2019
f1 <- readRDS("RDS/MP10_2019.rds")
f1$date <- as.Date(f1$date)
ano <- year(f1$date)
month <- month(f1$date)
day <- strftime(f1$date, "%d")
f1$time <- ISOdatetime(ano, month, day, f1$hour - 1, 0, 0)
ff1 <- f1[, 
          mean(conc, na.rm = T), 
          by = .(time)]
names(ff1) <- c("time_2019", "V1_2019")
ff1$day <- strftime(ff1$time, "%a")
ff <- cbind(ff2, ff1[25:(nrow(ff2) + 24)])
ff <- ff[!is.na(V1_2020)]
ff[, media24h2020 := mean(V1_2020), by = .(strftime(time, "%Y-%m-%d"))]
ff[, media24h2019 := mean(V1_2019), by = .(strftime(time, "%Y-%m-%d"))]

dfin <- ff[time >= as.POSIXct("2020-03-17"), V1_2020 - V1_2019]
summary(dfin)

df <- ff[, c("time", "V1_2020",  "V1_2019")]
names(df) <- c("time", as.character(2020:2019))
df$WHO24h <- 50

shapiro.test(df$`2020`)
shapiro.test(df$`2019`)
ff[time >= as.POSIXct("2020-03-17"), t.test(V1_2020, V1_2019)]

dt <- vein::wide_to_long(df = df, column_with_data = names(df)[2:4],
                         column_fixed = "time")
setDT(dt)
dt
names(dt) <- c("PM10", "time", "data")

p <- ggplot(dt[time >= as.POSIXct("2020-03-17")],
            aes(x = time, y = PM10, colour = data)) +
  labs(title =expression(PM[10] ~μg*m^-3~"at MASP"), 
       subtitle =  paste0("2020 - 2019: ",
                          "Min = ", round(min(dfin), 2),
                          " Max = ", round(max(dfin), 2),
                          " Mean = ", round(mean(dfin), 2)),
       y = expression(μg*m^-3),
       x = NULL) + 
  scale_x_datetime(minor_breaks = "day") +
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-03-17 12:00"), 
           xmax = as.POSIXct("2020-03-21"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-03-26 15:00"), 
           xmax = as.POSIXct("2020-03-28 12:00"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-04-05 00:00"), 
           xmax = as.POSIXct("2020-04-07 18:00"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  geom_point(size = 1) +
  geom_line() +
  geom_smooth() +
  theme_bw()+
  scale_color_manual(values = c("red", "blue", "black")) +
  theme(legend.title = element_blank()) 


png(filename = "figuras/PM10.png", 
    width = 3000, height = 1000, units = "px", res = 300)
print(p)
dev.off()

# NO2 HOURLY####
f2 <- readRDS("RDS/NO2_2020.rds")
sink("stations/NO2stations.txt")
cat(paste0(unique(f2$stationname), ", "))
sink()

f2$date <- as.Date(f2$date)
ano <- year(f2$date)
month <- month(f2$date)
day <- strftime(f2$date, "%d")
f2$time <- ISOdatetime(ano, month, day, f2$hour - 1, 0, 0)
ff2 <- f2[time <= as.POSIXct("2020-04-13 08:00"), 
          mean(conc, na.rm = T), 
          by = .(time)]

names(ff2)[2] <- "V1_2020"
ff2$day <- strftime(ff2$time, "%a")

# 2019
f1 <- readRDS("RDS/NO2_2019.rds")
f1$date <- as.Date(f1$date)
ano <- year(f1$date)
month <- month(f1$date)
day <- strftime(f1$date, "%d")
f1$time <- ISOdatetime(ano, month, day, f1$hour - 1, 0, 0)
ff1 <- f1[, 
          mean(conc, na.rm = T), 
          by = .(time)]
names(ff1) <- c("time_2019", "V1_2019")
ff1$day <- strftime(ff1$time, "%a")
ff <- cbind(ff2, ff1[25:(nrow(ff2) + 24)])
ff <- ff[!is.na(V1_2020)]
dfin <- ff[time >= as.POSIXct("2020-03-17"), V1_2020 - V1_2019]
summary(dfin)

df <- ff[, c("time", "V1_2020",  "V1_2019")]
names(df) <- c("time", as.character(2020:2019))
df$WHO1h <- 200
dt <- vein::wide_to_long(df = df, column_with_data = names(df)[2:4],
                         column_fixed = "time")

shapiro.test(df$`2020`)
shapiro.test(df$`2019`)
ff[time >= as.POSIXct("2020-03-17"), t.test(V1_2020, V1_2019)]

setDT(dt)
dt
names(dt) <- c("NO2", "time", "data")

p <- ggplot(dt[time >= as.POSIXct("2020-03-17")],
            aes(x = time, y = NO2, colour = data)) +
  labs(title =expression(NO[2] ~μg*m^-3~"at MASP"), 
       subtitle =  paste0("2020 - 2019: ",
                          "Min = ", round(min(dfin), 2),
                          " Max = ", round(max(dfin), 2),
                          " Mean = ", round(mean(dfin), 2)),
       y = expression(μg*m^-3),
       x = NULL) + 
  scale_x_datetime(minor_breaks = "day") +
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-03-17 12:00"), 
           xmax = as.POSIXct("2020-03-21"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-03-26 15:00"), 
           xmax = as.POSIXct("2020-03-28 12:00"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-04-05 00:00"), 
           xmax = as.POSIXct("2020-04-07 18:00"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  geom_point(size = 1) +
  geom_line() +
  geom_smooth() +
  theme_bw()+
  scale_color_manual(values = c("red", "blue", "black")) +
  theme(legend.title = element_blank()) 


png(filename = "figuras/NO2.png", 
    width = 3000, height = 1000, units = "px", res = 300)
print(p)
dev.off()


# O3 HOURLY####
f2 <- readRDS("RDS/O3_2020.rds")
sink("stations/O3stations.txt")
cat(paste0(unique(f2$stationname), ", "))
sink()

f2$date <- as.Date(f2$date)
ano <- year(f2$date)
month <- month(f2$date)
day <- strftime(f2$date, "%d")
f2$time <- ISOdatetime(ano, month, day, f2$hour - 1, 0, 0)

ff2 <- f2[time <= as.POSIXct("2020-04-13 08:00"), 
          mean(conc, na.rm = T), 
          by = .(time)]
names(ff2)[2] <- "V1_2020"

ff2$day <- strftime(ff2$time, "%a")

av2020 <- ff2
av20 <- av2020[, h := hour(time)][h %in% c(0:3, 21:23), mean(V1_2020, na.rm = T)]

# 2019
f1 <- readRDS("RDS/O3_2019.rds")
f1$date <- as.Date(f1$date)
ano <- year(f1$date)
month <- month(f1$date)
day <- strftime(f1$date, "%d")
f1$time <- ISOdatetime(ano, month, day, f1$hour - 1, 0, 0)
ff1 <- f1[, 
          mean(conc, na.rm = T), 
          by = .(time)]
names(ff1) <- c("time_2019", "V1_2019")

ff1$day <- strftime(ff1$time, "%a")

av2019 <- ff1
av19 <- av2019[, h := hour(time_2019)][h %in% c(0:3, 21:23),mean(V1_2019, na.rm = T)]

ff <- cbind(ff2, ff1[25:(nrow(ff2) + 24)])
ff <- ff[!is.na(V1_2020)]

ff$media8h2020 <-  frollmean(x = ff$V1_2020, n = 8, fill = 0, align = "right")
ff$media8h2019 <-  frollmean(x = ff$V1_2019, n = 8, fill = 0, align = "right")

ff[, media8h2020 := max(media8h2020), by = .(strftime(time, "%Y-%m-%d"))]
ff[, media8h2019 := max(media8h2019), by = .(strftime(time, "%Y-%m-%d"))]

dfin <- ff[time >= as.POSIXct("2020-03-17"), V1_2020 - V1_2019]

df <- ff[, c("time", "V1_2020",  "V1_2019")]

names(df) <- c("time", as.character(2020:2019))

df$WHO8h <- 100

dt <- vein::wide_to_long(df = df, column_with_data = names(df)[2:4],
                         column_fixed = "time")

shapiro.test(df$`2020`)
shapiro.test(df$`2019`)
ff[time >= as.POSIXct("2020-03-17"), t.test(V1_2020, V1_2019)]

ff[time >= as.POSIXct("2020-03-17") &
     h %in% c(0:3, 21:23), 
   t.test(V1_2020, V1_2019)]

mn <- ff[time >= as.POSIXct("2020-03-17") &
           h %in% c(0:3, 21:23), 
         mean(V1_2020 -V1_2019)]

ff[time >= as.POSIXct("2020-03-17") &
     h %in% c(11:17), 
   mean(V1_2020 -V1_2019)]

ff[time >= as.POSIXct("2020-03-17") &
     h %in% c(11:17), 
   t.test(V1_2020, V1_2019)]


setDT(dt)
dt
names(dt) <- c("O3", "time", "data")

p <- ggplot(dt[time >= as.POSIXct("2020-03-17")],
            aes(x = time, 
                y = O3, 
                colour = data)) +
  labs(title =expression(O[3] ~μg*m^-3~"at MASP"), 
       subtitle =  paste0("2020 - 2019: ",
                          "Min = ", round(min(dfin), 2),
                          " Max = ", round(max(dfin), 2),
                          " Mean = ", round(mean(dfin), 2),
                          " Mean between 21:00-03:00 = ", round(mn, 2)),
       y = expression(μg*m^-3),
       x = NULL) + 
  scale_x_datetime(minor_breaks = "day") +
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-03-17 12:00"), 
           xmax = as.POSIXct("2020-03-21"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-03-26 15:00"), 
           xmax = as.POSIXct("2020-03-28 12:00"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-04-05 00:00"), 
           xmax = as.POSIXct("2020-04-07 18:00"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-03-17 00:00"), 
           xmax = as.POSIXct("2020-04-13 12:00"), 
           ymin = 45, 
           ymax = 0, 
           colour = "black", alpha = 0.2)+
  geom_point(size = 1) +
  geom_line() +
  geom_smooth()+
  theme_bw()+
  scale_color_manual(values = c("red", "blue", "black")) +
  theme(legend.title = element_blank()) 


png(filename = "figuras/O3.png", 
    width = 3000, height = 1000, units = "px", res = 300)
print(p)
dev.off()

# CO HOURLY####
f2 <- readRDS("RDS/CO_2020.rds")
sink("stations/COstations.txt")
cat(paste0(unique(f2$stationname), ", "))
sink()

f2$date <- as.Date(f2$date)
ano <- year(f2$date)
month <- month(f2$date)
day <- strftime(f2$date, "%d")
f2$time <- ISOdatetime(ano, month, day, f2$hour - 1, 0, 0)

ff2 <- f2[time <= as.POSIXct("2020-04-13 08:00"), 
          mean(conc, na.rm = T), 
          by = .(time)]
names(ff2)[2] <- "V1_2020"

ff2$day <- strftime(ff2$time, "%a")

av2020 <- ff2
av20 <- av2020[, h := hour(time)][h %in% c(0:3, 21:23), mean(V1_2020, na.rm = T)]

# 2019
f1 <- readRDS("RDS/CO_2019.rds")
f1$date <- as.Date(f1$date)
ano <- year(f1$date)
month <- month(f1$date)
day <- strftime(f1$date, "%d")
f1$time <- ISOdatetime(ano, month, day, f1$hour - 1, 0, 0)
ff1 <- f1[, 
          mean(conc, na.rm = T), 
          by = .(time)]
names(ff1) <- c("time_2019", "V1_2019")

ff1$day <- strftime(ff1$time, "%a")

av2019 <- ff1
av19 <- av2019[, h := hour(time_2019)][h %in% c(0:3, 21:23),mean(V1_2019, na.rm = T)]

ff <- cbind(ff2, ff1[25:(nrow(ff2) + 24)])
ff <- ff[!is.na(V1_2020)]

ff$media8h2020 <-  frollmean(x = ff$V1_2020, n = 8, fill = 0, align = "right")
ff$media8h2019 <-  frollmean(x = ff$V1_2019, n = 8, fill = 0, align = "right")

ff[, media8h2020 := max(media8h2020), by = .(strftime(time, "%Y-%m-%d"))]
ff[, media8h2019 := max(media8h2019), by = .(strftime(time, "%Y-%m-%d"))]

dfin <- ff[time >= as.POSIXct("2020-03-17"), V1_2020 - V1_2019]

df <- ff[, c("time", "V1_2020",  "V1_2019")]

names(df) <- c("time", as.character(2020:2019))

dt <- vein::wide_to_long(df = df, column_with_data = names(df)[2:3],
                         column_fixed = "time")

shapiro.test(df$`2020`)
shapiro.test(df$`2019`)
ff[time >= as.POSIXct("2020-03-17"), t.test(V1_2020, V1_2019)]

setDT(dt)
dt
names(dt) <- c("CO", "time", "data")

p <- ggplot(dt[time >= as.POSIXct("2020-03-17")],
            aes(x = time, 
                y = CO, 
                colour = data)) +
  labs(title =expression(paste(CO, " ppm at MASP")), 
       subtitle =  paste0("2020 - 2019: ",
                          "Min = ", round(min(dfin, na.rm = T), 2),
                          " Max = ", round(max(dfin, na.rm = T), 2),
                          " Mean = ", round(mean(dfin, na.rm = T), 2)),
       y = "ppm",
       x = NULL) + 
  scale_x_datetime(minor_breaks = "day") +
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-03-17 12:00"), 
           xmax = as.POSIXct("2020-03-21"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-03-26 15:00"), 
           xmax = as.POSIXct("2020-03-28 12:00"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-04-05 00:00"), 
           xmax = as.POSIXct("2020-04-07 18:00"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  geom_point(size = 1) +
  geom_line() +
  geom_smooth()+
theme_bw()+
  scale_color_manual(values = c("red", "blue", "black")) +
  theme(legend.title = element_blank()) 


png(filename = "figuras/CO.png", 
    width = 2980, height = 1000, units = "px", res = 300)
print(p)
dev.off()



a <- image_trim(image_read("figuras/PM25.png"))
b1 <- image_annotate(a, "a)", gravity = "northwest", location = "+10+10", size = 60)
image_write(b1, "figuras/PM25x.png")

a <- image_trim(image_read("figuras/PM10.png"))
b2 <- image_annotate(a, "b)", gravity = "northwest", location = "+10+10", size = 60)
image_write(b2, "figuras/PM10x.png")

a <- image_trim(image_read("figuras/NO2.png"))
b3 <- image_annotate(a, "c)", gravity = "northwest", location = "+10+10", size = 60)
image_write(b3, "figuras/NO2x.png")

a <- image_trim(image_read("figuras/CO.png"))
b4 <- image_annotate(a, "d)", gravity = "northwest", location = "+10+10", size = 60)
image_write(b4, "figuras/COx.png")

a <- image_trim(image_read("figuras/O3.png"))
b5 <- image_annotate(a, "e)", gravity = "northwest", location = "+10+10", size = 60)
image_write(b5, "figuras/O3x.png")


image_write(image_append(image = c(b1, b2, b3, b4, b5), stack = T), 
            path = "figuras/fig3.png")


# O3 PINHEIROS HOURLY####
f2 <- readRDS("RDS/O3_2020.rds")
f2$date <- as.Date(f2$date)
ano <- year(f2$date)
month <- month(f2$date)
day <- strftime(f2$date, "%d")
f2$time <- ISOdatetime(ano, month, day, f2$hour - 1, 0, 0)

ff2 <- f2[stationname == unique(f2$stationname)[6] &
            time <= as.POSIXct("2020-04-13 08:00"),
          c("time", "conc")]
names(ff2)[2] <- "V1_2020"

ff2$day <- strftime(ff2$time, "%a")

aa <- ff2[time >= as.POSIXct("2020-03-18") &
            time < as.POSIXct("2020-03-21")]
shapiro.test(aa$V1_2020)
a <- lm(V1_2020 ~ time, data = aa)
summary(a)

aa <- ff2[time >= as.POSIXct("2020-03-21") &
            time < as.POSIXct("2020-04-07")]
a <- lm(V1_2020 ~ time, data = aa)
shapiro.test(aa$V1_2020)
summary(a)


# 2019
f1 <- readRDS("RDS/O3_2019.rds")
f1$date <- as.Date(f1$date)
ano <- year(f1$date)
month <- month(f1$date)
day <- strftime(f1$date, "%d")
f1$time <- ISOdatetime(ano, month, day, f1$hour - 1, 0, 0)

ff1 <- f1[stationname == unique(f2$stationname)[6],
          c("time", "conc")]
names(ff1) <- c("time_2019", "V1_2019")

ff1$day <- strftime(ff1$time, "%a")


ff <- cbind(ff2, ff1[25:(nrow(ff2) + 24)])
ff <- ff[!is.na(V1_2020)]
ff$h <- hour(ff$time)
dfin <- ff[time >= as.POSIXct("2020-03-17"), V1_2020 - V1_2019]

df <- ff[, c("time", "V1_2020",  "V1_2019")]

names(df) <- c("time", as.character(2020:2019))

shapiro.test(df$`2020`)
shapiro.test(df$`2019`)
ff[time >= as.POSIXct("2020-03-17"), t.test(V1_2020, V1_2019)]

(mn <- ff[time >= as.POSIXct("2020-03-17") & 
            h %in% c(0:3, 21:23), 
          mean(V1_2020 - V1_2019, na.rm = T)])

ff[time >= as.POSIXct("2020-03-17") & 
     h %in% c(0:3, 21:23), 
   t.test(V1_2020, V1_2019)]

ff[time >= as.POSIXct("2020-03-17") & 
     h %in% c(12:17), 
   mean(V1_2020 - V1_2019, na.rm = T)]

ff[time >= as.POSIXct("2020-03-17") & 
     h %in% c(12:17), 
   t.test(V1_2020, V1_2019)]

dt <- vein::wide_to_long(df = df, column_with_data = names(df)[2:3],
                         column_fixed = "time")
setDT(dt)
dt
names(dt) <- c("O3", "time", "data")

p <- ggplot(dt[time >= as.POSIXct("2020-03-17")],
            aes(x = time, 
                y = O3, 
                colour = data)) +
  labs(title =expression(O[3] ~μg*m^-3~" at MASP"), 
       subtitle =  paste0("2020 - 2019: ",
                          "Min = ", round(min(dfin, na.rm = T), 2),
                          " Max = ", round(max(dfin, na.rm = T), 2),
                          " Mean = ", round(mean(dfin, na.rm = T), 2)),
       y = expression(μg*m^-3),
       x = NULL) + 
  scale_x_datetime(minor_breaks = "day") +
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-03-17 12:00"), 
           xmax = as.POSIXct("2020-03-21"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-03-26 15:00"), 
           xmax = as.POSIXct("2020-03-28 12:00"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-04-05 00:00"), 
           xmax = as.POSIXct("2020-04-07 18:00"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-03-17 00:00"), 
           xmax = as.POSIXct("2020-04-13 12:00"), 
           ymin = 45, 
           ymax = 0, 
           colour = "black", alpha = 0.2)+
  geom_point(size = 1) +
  geom_line() +
  geom_smooth()+
  theme_bw()+
  scale_color_manual(values = c("red", "blue", "black")) +
  theme(legend.title = element_blank()) 

png(filename = "figuras/O3_PIN.png", width = 3000, height = 1000, units = "px", res = 300)
print(p)
dev.off()



# NO2 PINHEIROS HOURLY####
f2 <- readRDS("RDS/NO2_2020.rds")
f2$date <- as.Date(f2$date)
ano <- year(f2$date)
month <- month(f2$date)
day <- strftime(f2$date, "%d")
f2$time <- ISOdatetime(ano, month, day, f2$hour - 1, 0, 0)

ff2 <- f2[stationname == unique(f2$stationname)[5] &
            time <= as.POSIXct("2020-04-13 08:00"),
          c("time", "conc")]
names(ff2)[2] <- "V1_2020"

ff2$day <- strftime(ff2$time, "%a")

aa <- ff2[time >= as.POSIXct("2020-03-18") &
            time < as.POSIXct("2020-03-21")]
shapiro.test(aa$V1_2020)
a <- lm(V1_2020 ~ time, data = aa)
summary(a)

aa <- ff2[time >= as.POSIXct("2020-03-21") &
            time < as.POSIXct("2020-04-07")]
a <- lm(V1_2020 ~ time, data = aa)
shapiro.test(aa$V1_2020)
summary(a)




# 2019
f1 <- readRDS("RDS/NO2_2019.rds")
f1$date <- as.Date(f1$date)
ano <- year(f1$date)
month <- month(f1$date)
day <- strftime(f1$date, "%d")
f1$time <- ISOdatetime(ano, month, day, f1$hour - 1, 0, 0)

ff1 <- f1[stationname == unique(f2$stationname)[5],
          c("time", "conc")]
names(ff1) <- c("time_2019", "V1_2019")
ff1$day <- strftime(ff1$time, "%a")
ff <- cbind(ff2, ff1[25:(nrow(ff2) + 24)])
ff <- ff[!is.na(V1_2020)]
dfin <- ff[time >= as.POSIXct("2020-03-17"), V1_2020 - V1_2019]

ff[time >= as.POSIXct("2020-03-17"), 
   t.test(V1_2020, V1_2019)]
ff[time >= as.POSIXct("2020-03-17"), 
   mean(V1_2020 -V1_2019, na.rm = T)]

summary(dfin)

df <- ff[, c("time", "V1_2020",  "V1_2019")]
names(df) <- c("time", as.character(2020:2019))
df$OMS1h <- 200
dt <- vein::wide_to_long(df = df, column_with_data = names(df)[2:4],
                         column_fixed = "time")
setDT(dt)
dt
names(dt) <- c("NO2", "time", "data")

p <- ggplot(dt[data %in% 2019:2020 & 
                 time >= as.POSIXct("2020-03-17")],
            aes(x = time, y = NO2, colour = data)) +
  labs(title =expression(NO[2] ~μg*m^-3~" at station Pinheiros"), 
       subtitle =  paste0("2020 - 2019: ",
                          "Min = ", round(min(dfin, na.rm = T), 2),
                          " Max = ", round(max(dfin, na.rm = T), 2),
                          " Mean = ", round(mean(dfin, na.rm = T), 2)),
       y = expression(μg*m^-3),
       x = NULL) + 
  scale_x_datetime(minor_breaks = "day") +
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-03-17 12:00"), 
           xmax = as.POSIXct("2020-03-21"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-03-26 15:00"), 
           xmax = as.POSIXct("2020-03-28 12:00"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-04-05 00:00"), 
           xmax = as.POSIXct("2020-04-07 18:00"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-03-29 12:00"), 
           xmax = as.POSIXct("2020-03-30 06:00"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  geom_point(size = 1) +
  geom_line() +
  geom_smooth() +
  theme_bw()+
  scale_color_manual(values = c("red", "blue", "black")) +
  theme(legend.title = element_blank()) 


png(filename = "figuras/NO2_PIN.png", 
    width = 3000, height = 1000, units = "px", res = 300)
print(p)
dev.off()



# CO PINHEIROS HOURLY####
f2 <- readRDS("RDS/CO_2020.rds")
f2$date <- as.Date(f2$date)
ano <- year(f2$date)
month <- month(f2$date)
day <- strftime(f2$date, "%d")
f2$time <- ISOdatetime(ano, month, day, f2$hour - 1, 0, 0)

ff2 <- f2[stationname == unique(f2$stationname)[6] &
            time <= as.POSIXct("2020-04-13 08:00"),
          c("time", "conc")]
names(ff2)[2] <- "V1_2020"

ff2$day <- strftime(ff2$time, "%a")

aa <- ff2[time >= as.POSIXct("2020-03-18") &
            time < as.POSIXct("2020-03-21")]
a <- lm(V1_2020 ~ time, data = aa)
summary(a)
aa <- ff2[time >= as.POSIXct("2020-03-21") &
            time < as.POSIXct("2020-04-07")]
a <- lm(V1_2020 ~ time, data = aa)
summary(a)


# 2019
f1 <- readRDS("RDS/CO_2019.rds")
f1$date <- as.Date(f1$date)
ano <- year(f1$date)
month <- month(f1$date)
day <- strftime(f1$date, "%d")
f1$time <- ISOdatetime(ano, month, day, f1$hour - 1, 0, 0)

ff1 <- f1[stationname == unique(f2$stationname)[6],
          c("time", "conc")]
names(ff1) <- c("time_2019", "V1_2019")
ff1$day <- strftime(ff1$time, "%a")
ff <- cbind(ff2, ff1[25:(nrow(ff2) + 24)])
ff <- ff[!is.na(V1_2020)]
dfin <- ff[time >= as.POSIXct("2020-03-17"), V1_2020 - V1_2019]

ff[time >= as.POSIXct("2020-03-17"), 
   t.test(V1_2020, V1_2019)]
ff[time >= as.POSIXct("2020-03-17"), 
   mean(V1_2020 -V1_2019, na.rm = T)]

summary(dfin)

df <- ff[, c("time", "V1_2020",  "V1_2019")]
names(df) <- c("time", as.character(2020:2019))

dt <- vein::wide_to_long(df = df, column_with_data = names(df)[2:3],
                         column_fixed = "time")
setDT(dt)
dt
names(dt) <- c("NO2", "time", "data")

p <- ggplot(dt[time >= as.POSIXct("2020-03-17")],
            aes(x = time, y = NO2, colour = data)) +
  labs(title =paste("CO ppm at station Pinheiros"), 
       subtitle =  paste0("2020 - 2019: ",
                          "Min = ", round(min(dfin, na.rm = T), 2),
                          " Max = ", round(max(dfin, na.rm = T), 2),
                          " Mean = ", round(mean(dfin, na.rm = T), 2)),
       y = "ppm",
       x = NULL) + 
  scale_x_datetime(minor_breaks = "day") +
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-03-17 12:00"), 
           xmax = as.POSIXct("2020-03-21"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-03-26 15:00"), 
           xmax = as.POSIXct("2020-03-28 12:00"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-04-05 00:00"), 
           xmax = as.POSIXct("2020-04-07 18:00"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-03-29 12:00"), 
           xmax = as.POSIXct("2020-03-30 06:00"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  geom_point(size = 1) +
  geom_line() +
  geom_smooth() +
  theme_bw()+
  scale_color_manual(values = c("red", "blue", "black")) +
  theme(legend.title = element_blank()) 


png(filename = "figuras/CO_PIN.png", 
    width = 3000, height = 1000, units = "px", res = 300)
print(p)
dev.off()


# TOL PINHEIROS HOURLY####
f2 <- readRDS("RDS/TOL_2020.rds")
f2$date <- as.Date(f2$date)
ano <- year(f2$date)
month <- month(f2$date)
day <- strftime(f2$date, "%d")
f2$time <- ISOdatetime(ano, month, day, f2$hour - 1, 0, 0)

ff2 <- f2[stationname == unique(f2$stationname)[1] &
            time <= as.POSIXct("2020-04-13 08:00"),
          c("time", "conc")]
names(ff2)[2] <- "V1_2020"

ff2$day <- strftime(ff2$time, "%a")

aa <- ff2[time >= as.POSIXct("2020-03-18") &
            time < as.POSIXct("2020-03-21")]
a <- lm(V1_2020 ~ time, data = aa)
summary(a)
aa <- ff2[time >= as.POSIXct("2020-03-21") &
            time < as.POSIXct("2020-04-07")]
a <- lm(V1_2020 ~ time, data = aa)
summary(a)


# 2019
f1 <- readRDS("RDS/TOL_2019.rds")
f1$date <- as.Date(f1$date)
ano <- year(f1$date)
month <- month(f1$date)
day <- strftime(f1$date, "%d")
f1$time <- ISOdatetime(ano, month, day, f1$hour - 1, 0, 0)

ff1 <- f1[stationname == unique(f2$stationname)[1],
          c("time", "conc")]
names(ff1) <- c("time_2019", "V1_2019")
ff1$day <- strftime(ff1$time, "%a")
ff <- cbind(ff2, ff1[25:(nrow(ff2) + 24)])
ff <- ff[!is.na(V1_2020)]
dfin <- ff[time >= as.POSIXct("2020-03-17"), V1_2020 - V1_2019]

ff[time >= as.POSIXct("2020-03-17"), 
   t.test(V1_2020, V1_2019)]
ff[time >= as.POSIXct("2020-03-17"), 
   mean(V1_2020 -V1_2019, na.rm = T)]

summary(dfin)

df <- ff[, c("time", "V1_2020",  "V1_2019")]
names(df) <- c("time", as.character(2020:2019))

dt <- vein::wide_to_long(df = df, column_with_data = names(df)[2:3],
                         column_fixed = "time")
setDT(dt)
dt
names(dt) <- c("TOL", "time", "data")

p <- ggplot(dt[time >= as.POSIXct("2020-03-17")],
            aes(x = time, y = TOL, colour = data)) +
  labs(title =expression(Toluene ~μg*m^-3~" at station Pinheiros"), 
       subtitle =  paste0("2020 - 2019: ",
                          "Min = ", round(min(dfin, na.rm = T), 2),
                          " Max = ", round(max(dfin, na.rm = T), 2),
                          " Mean = ", round(mean(dfin, na.rm = T), 2)),
       y = expression(μg*m^-3),
       x = NULL) + 
  scale_x_datetime(minor_breaks = "day") +
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-03-17 12:00"), 
           xmax = as.POSIXct("2020-03-21"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-03-26 15:00"), 
           xmax = as.POSIXct("2020-03-28 12:00"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-04-05 00:00"), 
           xmax = as.POSIXct("2020-04-07 18:00"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-03-29 12:00"), 
           xmax = as.POSIXct("2020-03-30 06:00"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  geom_point(size = 1) +
  geom_line() +
  geom_smooth() +
  theme_bw()+
  scale_color_manual(values = c("red", "blue", "black")) +
  theme(legend.title = element_blank()) 

p
png(filename = "figuras/TOL_PIN.png",
    width = 3000, height = 1000, units = "px", res = 300)
print(p)
dev.off()


# MP25 PINHEIROS HOURLY####
f2 <- readRDS("RDS/MP25_2020.rds")
f2$date <- as.Date(f2$date)
ano <- year(f2$date)
month <- month(f2$date)
day <- strftime(f2$date, "%d")
f2$time <- ISOdatetime(ano, month, day, f2$hour - 1, 0, 0)

ff2 <- f2[stationname == unique(f2$stationname)[1] &
            time <= as.POSIXct("2020-04-13 08:00"),
          c("time", "conc")]
names(ff2)[2] <- "V1_2020"

ff2$day <- strftime(ff2$time, "%a")

aa <- ff2[time >= as.POSIXct("2020-03-18") &
            time < as.POSIXct("2020-03-21")]
shapiro.test(aa$V1_2020)
a <- lm(V1_2020 ~ time, data = aa)
summary(a)

aa <- ff2[time >= as.POSIXct("2020-03-21") &
            time < as.POSIXct("2020-04-07")]
a <- lm(V1_2020 ~ time, data = aa)
shapiro.test(aa$V1_2020)
summary(a)


# 2019
f1 <- readRDS("RDS/MP25_2019.rds")
f1$date <- as.Date(f1$date)
ano <- year(f1$date)
month <- month(f1$date)
day <- strftime(f1$date, "%d")
f1$time <- ISOdatetime(ano, month, day, f1$hour - 1, 0, 0)

ff1 <- f1[stationname == unique(f2$stationname)[1],
          c("time", "conc")]
names(ff1) <- c("time_2019", "V1_2019")
ff1$day <- strftime(ff1$time, "%a")
ff <- cbind(ff2, ff1[25:(nrow(ff2) + 24)])
ff <- ff[!is.na(V1_2020)]
dfin <- ff[time >= as.POSIXct("2020-03-17"), V1_2020 - V1_2019]

ff[time >= as.POSIXct("2020-03-17"), 
   t.test(V1_2020, V1_2019)]
ff[time >= as.POSIXct("2020-03-17"), 
   mean(V1_2020 -V1_2019, na.rm = T)]
summary(dfin)

df <- ff[, c("time", "V1_2020",  "V1_2019")]
names(df) <- c("time", as.character(2020:2019))

dt <- vein::wide_to_long(df = df, column_with_data = names(df)[2:3],
                         column_fixed = "time")
setDT(dt)
dt
names(dt) <- c("MP25", "time", "data")

p <- ggplot(dt[time >= as.POSIXct("2020-03-17")],
            aes(x = time, y = MP25, colour = data)) +
  labs(title =expression(PM[2.5] ~μg*m^-3~" at station Pinheiros"), 
       subtitle =  paste0("2020 - 2019: ",
                          "Min = ", round(min(dfin, na.rm = T), 2),
                          " Max = ", round(max(dfin, na.rm = T), 2),
                          " Mean = ", round(mean(dfin, na.rm = T), 2)),
       y = expression(μg*m^-3),
       x = NULL) + 
  scale_x_datetime(minor_breaks = "day") +
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-03-17 12:00"), 
           xmax = as.POSIXct("2020-03-21"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-03-26 15:00"), 
           xmax = as.POSIXct("2020-03-28 12:00"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-04-05 00:00"), 
           xmax = as.POSIXct("2020-04-07 18:00"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  annotate(geom = "rect", 
           xmin = as.POSIXct("2020-03-29 12:00"), 
           xmax = as.POSIXct("2020-03-30 06:00"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  geom_point(size = 1) +
  geom_line() +
  geom_smooth() +
  theme_bw()+
  scale_color_manual(values = c("red", "blue", "black")) +
  theme(legend.title = element_blank()) 


png(filename = "figuras/PM25_PIN.png", 
    width = 3000, height = 1000, units = "px", res = 300)
print(p)
dev.off()


a <- image_trim(image_read("figuras/PM25_PIN.png"))
b1 <- image_annotate(a, "a)", gravity = "northwest", location = "+10+10", size = 60)
image_write(b1, "figuras/PM25_PINx.png")

a <- image_trim(image_read("figuras/NO2_PIN.png"))
b2 <- image_annotate(a, "b)", gravity = "northwest", location = "+10+10", size = 60)
image_write(b2, "figuras/NO2_PINx.png")

a <- image_trim(image_read("figuras/CO_PIN.png"))
b3 <- image_annotate(a, "c)", gravity = "northwest", location = "+10+10", size = 60)
image_write(b3, "figuras/CO_PINx.png")

a <- image_trim(image_read("figuras/O3_PIN.png"))
b4 <- image_annotate(a, "d)", gravity = "northwest", location = "+10+10", size = 60)
image_write(b4, "figuras/O3_PINx.png")

a <- image_trim(image_read("figuras/TOL_PIN.png"))
b5 <- image_annotate(a, "e)", gravity = "northwest", location = "+10+10", size = 60)
image_write(b5, "figuras/TOL_PINx.png")


image_write(image_append(image = c(b1, b2, b3, b4, b5), stack = T), 
            path = "figuras/fig4.png")


# APPLE BR ####
ap <- fread("apple/applemobilitytrends-2020-04-13.csv")
df <- ap[region == "Brazil"]
dff <- vein::wide_to_long(df = df, column_with_data = names(df)[4:95], column_fixed = names(df)[3])
setDT(dff)
dff
names(dff) <- c("Perc", "Mode", "date")

dff$date <- as.Date(dff$date)
dff
p <- ggplot(dff[date > as.Date("2020-03-17") ],
            aes(x = date, y = Perc, colour = Mode)) +
  labs(title =paste("Mobility tendencies in Brazil by mode [%]"), 
       subtitle =  paste0("100% is January 13th, 2020. Source Apple Mobility reports"),
       y = "[%]",
       x = NULL) + 
  scale_x_date(minor_breaks = "day") +
  annotate(geom = "rect", 
           xmin = as.Date("2020-03-17"), 
           xmax = as.Date("2020-03-21"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  annotate(geom = "rect", 
           xmin = as.Date("2020-03-26"), 
           xmax = as.Date("2020-03-28"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  annotate(geom = "rect", 
           xmin = as.Date("2020-04-05"), 
           xmax = as.Date("2020-04-07"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  annotate(geom = "rect", 
           xmin = as.Date("2020-03-29"), 
           xmax = as.Date("2020-03-30"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  geom_point(size = 1) +
  geom_line() +
  geom_smooth() +
  geom_vline(xintercept = as.Date("2020-03-17"), lty = 2) +
  geom_vline(xintercept = as.Date("2020-03-24"), lty = 2) +
  theme_bw()+
  scale_color_manual(values = c("red", "blue", "black")) +
  theme(legend.position = "bottom",
        legend.title = element_blank(),
        legend.direction="horizontal") 

png(filename = "figuras/MOBILITY_AppleBR.png", 
    width = 3000, height = 1500, units = "px", res = 300)
print(p)
dev.off()

image_write(image_trim(image_read("figuras/MOBILITY_AppleBR.png")))

# APPLE SP ####
ap <- fread("apple/applemobilitytrends-2020-04-13.csv")
df <- ap[region == "Sao Paulo"]
dff <- vein::wide_to_long(df = df, column_with_data = names(df)[4:95], column_fixed = names(df)[3])
setDT(dff)
dff
names(dff) <- c("Perc", "Mode", "date")

dff$date <- as.Date(dff$date)
dff
p <- ggplot(dff[date > as.Date("2020-03-17") ],
            aes(x = date, y = Perc, colour = Mode)) +
  labs(title =paste("Mobility tendencies in São Paulo by mode [%]"), 
       subtitle =  paste0("100% is January 13th, 2020. Source Apple Mobility reports"),
       y = "[%]",
       x = NULL) + 
  scale_x_date(minor_breaks = "day") +
  annotate(geom = "rect", 
           xmin = as.Date("2020-03-17"), 
           xmax = as.Date("2020-03-21"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  annotate(geom = "rect", 
           xmin = as.Date("2020-03-26"), 
           xmax = as.Date("2020-03-28"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  annotate(geom = "rect", 
           xmin = as.Date("2020-04-05"), 
           xmax = as.Date("2020-04-07"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  annotate(geom = "rect", 
           xmin = as.Date("2020-03-29"), 
           xmax = as.Date("2020-03-30"), 
           ymin = -Inf, 
           ymax = Inf, colour = "black", alpha = 0.2)+
  geom_point(size = 1) +
  geom_line() +
  geom_smooth() +
  geom_vline(xintercept = as.Date("2020-03-17"), lty = 2) +
  geom_vline(xintercept = as.Date("2020-03-24"), lty = 2) +
  theme_bw()+
  scale_color_manual(values = c("red", "blue", "black")) +
  theme(legend.position = "bottom",
        legend.title = element_blank(),
        legend.direction="horizontal") 

png(filename = "figuras/MOBILITY_AppleSP.png", 
    width = 3000, height = 1500, units = "px", res = 300)
print(p)
dev.off()

image_write(image_trim(image_read("figuras/MOBILITY_AppleSP.png")))

# Correlations Apple ####
f2 <- readRDS("RDS/MP25_2020.rds")
f2$date <- as.Date(f2$date)
ano <- year(f2$date)
month <- month(f2$date)
day <- strftime(f2$date, "%d")
f2$time <- ISOdatetime(ano, month, day, f2$hour - 1, 0, 0)
ff2 <- f2[time <= as.POSIXct("2020-04-13 08:00") &
            time >= as.POSIXct("2020-03-17 08:00"), 
          mean(conc, na.rm = T), 
          by = .(date)]
dff <- dff[date >= as.Date("2020-03-17 08:00") &
             date <= as.Date("2020-04-13 08:00") &
             Mode == "driving"]
cor(ff2$V1, dff$Perc)

f2 <- readRDS("RDS/MP10_2020.rds")
f2$date <- as.Date(f2$date)
ano <- year(f2$date)
month <- month(f2$date)
day <- strftime(f2$date, "%d")
f2$time <- ISOdatetime(ano, month, day, f2$hour - 1, 0, 0)
ff2 <- f2[time <= as.POSIXct("2020-04-13 08:00") &
            time >= as.POSIXct("2020-03-17 08:00"), 
          mean(conc, na.rm = T), 
          by = .(date)]
cor(ff2$V1, dff$Perc)

f2 <- readRDS("RDS/NO2_2020.rds")
f2$date <- as.Date(f2$date)
ano <- year(f2$date)
month <- month(f2$date)
day <- strftime(f2$date, "%d")
f2$time <- ISOdatetime(ano, month, day, f2$hour - 1, 0, 0)
ff2 <- f2[time <= as.POSIXct("2020-04-13 08:00") &
            time >= as.POSIXct("2020-03-17 08:00"), 
          mean(conc, na.rm = T), 
          by = .(date)]
cor(ff2$V1, dff$Perc)
dt <- data.frame(pol = ff2$V1, driving = dff$Perc)
lm(pol ~ driving, data = dt)

f2 <- readRDS("RDS/O3_2020.rds")
f2$date <- as.Date(f2$date)
ano <- year(f2$date)
month <- month(f2$date)
day <- strftime(f2$date, "%d")
f2$time <- ISOdatetime(ano, month, day, f2$hour - 1, 0, 0)
ff2 <- f2[time <= as.POSIXct("2020-04-13 08:00") &
            time >= as.POSIXct("2020-03-17 08:00"), 
          mean(conc, na.rm = T), 
          by = .(date)]
cor(ff2$V1, dff$Perc)

f2 <- readRDS("RDS/CO_2020.rds")
f2$date <- as.Date(f2$date)
ano <- year(f2$date)
month <- month(f2$date)
day <- strftime(f2$date, "%d")
f2$time <- ISOdatetime(ano, month, day, f2$hour - 1, 0, 0)
ff2 <- f2[time <= as.POSIXct("2020-04-13 08:00") &
            time >= as.POSIXct("2020-03-17 08:00"), 
          mean(conc, na.rm = T), 
          by = .(date)]
cor(ff2$V1, dff$Perc)

dt <- data.frame(pol = ff2$V1, transit = dff$Perc)
a <- lm(pol ~ transit, data = dt)
summary(a)
plot(ff2$V1, pch = 16, type = "b")
lines(predict(a), pch = 16,col = "blue", type = "b")

ff2$data <- "Observations"
dfx <- ff2
dfx$V1 <- predict(a)
dfx$data <- "Predicted"
dfxx <- rbind(ff2, dfx)
b <- summary(a)
b$coefficients[4]

dfxx$date <- as.Date(dfxx$date)
