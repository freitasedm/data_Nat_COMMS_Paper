
# Loading pollutant information for all cetesb stations
cetesb_data <- readRDS("02_data/raw_data/cetesb_010320_140420.Rds")


# Function to write station data in csv

WriteStationData<- function(df){
  station_name <- unique(na.omit(df$est))
  station_name <- iconv(station_name, from = "UTF-8", to = "ASCII//TRANSLIT") # Change spetial characters
  station_name <- gsub(" ", "_", station_name) # Removing empty spaces in station_name
  
  path <- "./02_data/cetesb_data/"
  file_name <- paste0(path, station_name, "_010320-140420.csv")
  write.table(df, file_name, quote = F, row.names = F, sep = ',')
}


lapply(cetesb_data, WriteStationData)

