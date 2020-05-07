library('openair')


# Loading pollutant information for all cetesb stations
cetesb_data <- readRDS('02_data/raw_data/cetesb_010320_140420.Rds')

# Loading cetesb station latitude and longitude
cetesb_latlon <- read.table('02_data/pre_processed_data/cetesb2017_latlon.dat', 
                            header = T, stringsAsFactors = F, 
                            sep = ',', dec = '.')


# Selecting dates
cetesb_sem <- lapply(cetesb_data, 
                     function(df) selectByDate(df, start = "15/03/2020", end = "21/03/2020")) # Week with no restrictions
cetesb_w1 <- lapply(cetesb_data, 
                    function(df) selectByDate(df, start = "22/03/2020", end = "28/03/2020")) # First week quarantine
cetesb_w2 <- lapply(cetesb_data, 
                    function(df) selectByDate(df, start = "29/03/2020", end = "04/04/2020")) # Second week of quarantine
cetesb_w3 <- lapply(cetesb_data, 
                    function(df) selectByDate(df, start = '05/04/2020', end = "11/04/2020")) # Third week of quarantine

# Calculating NOX in ug/m3
cetesb_sem <- lapply(cetesb_sem, function(df) {
  df$nox_mi <- df$no + df$no2
  return(df)
})

cetesb_w1 <- lapply(cetesb_w1, function(df) {
  df$nox_mi <- df$no + df$no2
  return(df)
})

cetesb_w2 <- lapply(cetesb_w2, function(df) {
  df$nox_mi <- df$no + df$no2
  return(df)
})

cetesb_w3 <- lapply(cetesb_w3, function(df) {
  df$nox_mi <- df$no + df$no2
  return(df)
})


# Calculating mean for each period
sem_mean <- lapply(cetesb_sem, function(df) colMeans(df[c(2:8, 10)], na.rm = T))
w1_mean <- lapply(cetesb_w1, function(df) colMeans(df[c(2:8, 10)], na.rm = T))
w2_mean <- lapply(cetesb_w2, function(df) colMeans(df[c(2:8, 10)], na.rm = T))
w3_mean <- lapply(cetesb_w3, function(df) colMeans(df[c(2:8, 10)], na.rm = T))

# Merging all pollutan mean for each air quality station (aqs) in one dataframe
aqs_sem <- as.data.frame(do.call(rbind, sem_mean))
aqs_w1 <- as.data.frame(do.call(rbind, w1_mean))
aqs_w2 <- as.data.frame(do.call(rbind, w2_mean))
aqs_w3 <- as.data.frame(do.call(rbind, w3_mean))


# Calculating differences in %
dif_w1_sem <- (aqs_w1 - aqs_sem) / aqs_sem * 100 # 1st week of quarantine vs Week we no restriction
dif_w2_w1 <- (aqs_w2 - aqs_w1) / aqs_w1 * 100 # 2nd week of quarantine vs 1st Week of quarantine
dif_w3_w1 <- (aqs_w3 - aqs_w1) / aqs_w1 * 100 # 3th week of quarantine vs 1st Week of quarantine

dif_w1_sem_lalo <- cbind(cetesb_latlon, dif_w1_sem)
dif_w2_w1_lalo <- cbind(cetesb_latlon, dif_w2_w1)
dif_w3_w1_lalo <- cbind(cetesb_latlon, dif_w3_w1)


# These outputs will be read by map map_cetesb_aqs_week_mean.py
write.table(dif_w1_sem_lalo, "02_data/pre_processed_data/dif_w1_sem.csv", 
            sep = ',', row.names = F, quote = F)
write.table(dif_w2_w1_lalo, "02_data/pre_processed_data/dif_w2_w1.csv", 
            sep = ',', row.names = F, quote = F)
write.table(dif_w3_w1_lalo, "02_data/pre_processed_data/dif_w3_w1.csv", 
            sep = ',', row.names = F, quote = F)

