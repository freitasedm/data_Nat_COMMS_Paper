library('openair')

# Location of input files and output directory
cetesb_data_file  <- "./02_data/raw_data/cetesb_masp_010320_140420.Rds"
cetesb_station_file <- "./02_data/processed_data/cetesb_masp_aqs_lat_lon.csv"
output_dir <-  "./02_data/processed_data/"

# Loading pollutant information for cetesb stations inside metropolitan area of sao paulo (MASP)
cetesb_data <- readRDS(cetesb_data_file)

# Loading cetesb station latitude and longitude
cetesb_latlon <- read.table(cetesb_station_file, 
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
write.table(dif_w1_sem_lalo, paste0(output_dir, "dif_w1_sem.csv"), 
            sep = ',', row.names = F, quote = F)
write.table(dif_w2_w1_lalo, paste0(output_dir, "dif_w2_w1.csv"), 
            sep = ',', row.names = F, quote = F)
write.table(dif_w3_w1_lalo, paste0(output_dir, "dif_w3_w1.csv"), 
            sep = ',', row.names = F, quote = F)

