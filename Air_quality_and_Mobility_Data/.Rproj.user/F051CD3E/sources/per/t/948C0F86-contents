library(openair)
library(data.table)

# Loading pollutant information for all cetesb stations
cetesb_data <- readRDS("./02_data/raw_data/cetesb_010320_140420.Rds")

# Selecting study period
cetesb <- lapply(cetesb_data, function(df) selectByDate(df, start = "17/03/2020", end = "13/04/2020"))

# Calculating nox 
cetesb <- lapply(cetesb, function(df) {
  df$nox_mi <- df$no + df$no2 # nox in ug/m3
  return(df)})

# Calculating daily average
cetesb_mean_day <- lapply(cetesb, function(df) timeAverage(df, avg.time = "day"))

# Reading isolation index data
# This file is a processed version of Taxa-Isolamento-por-Município_14Abr-3.xlsx
# With no header, in CSV and filtered by 5 most populated cities.
iso_index <- fread('02_data/pre_processed_data/isolation_index_five_mun_sp_170320_130420.csv',
                   dec = ',', header=F, sep =';')

# Pivoting table, original data has day as columns
iso_index <- dcast(melt(iso_index, id.vars = "V1"), variable ~ V1)
names(iso_index) <- c( 'var','camp', 'gru', 'sbc', 'sjc', 'sp')


# Selecting cetesb daily mean 
pin <- cetesb_mean_day[[44]] # Pinheiros
gru <- cetesb_mean_day[[24]] # Gurarulhos
camp <- cetesb_mean_day[[7]] # Campinas
sbc <- cetesb_mean_day[[52]] # Sao Bernardo do Campo
sjc <- cetesb_mean_day[[54]] # Sao Jose dos Campos

# Getting NOX min and max values
nox_range <- range(pin$nox_mi, gru$nox_mi,camp$nox_mi, sbc$nox_mi)
iso_index_range <- range(iso[, 2:6])

# Creating a function to plot poluttant vs isolation index
PlotPolIso <- function(cet, iso, pol, city, title, legend.pos = 'topleft'){
  par(mar = c(5, 4, 4, 4) + 0.3)   
  plot(cet[['date']], cet[[pol]], t = 'l', lwd = 3, 
       ylim = range(pin[[pol]], gru[[pol]],camp[[pol]], sbc[[pol]]),  
       col = 'dodgerblue2',  
       ylab = expression("NO"[X] * " (" * mu * "g/m" ^3 * ")"),
       xlab = '2020',
       main = title)
  points(cet[['date']], cet[[pol]], col = 'dodgerblue2', pch = 19)
  par(new = T)
  plot(cet[['date']],iso[[city]], t = 'l', lwd = 3, 
       ylim = c(35, 65),  col = 'chocolate2', ylab = '', xlab = '', axes =F)
  points(cet[['date']], iso[[city]], col = 'chocolate2', pch = 19)
  axis(4)
  axis(1, at = 1:7, label =6:12)
  mtext("Isolation index (%)", side=4, line=3)
  legend(legend.pos, lwd = 2.5, lty = 1, col = c('dodgerblue2', 'chocolate2'),
         legend = c('NOx', 'Isolation index'), bty = 'n')
  box()
}

png('03_output_figs/nox_vs_iso_index.png', height = 710, width = 1000)
par(mfrow = c(2, 2))
PlotPolIso(pin, iso_index, 'nox_mi', 'sp', 'Pinheiros', 'bottomright')
PlotPolIso(gru, iso_index, 'nox_mi', 'gru', 'Guarulhos')
PlotPolIso(camp, iso_index, 'nox_mi', 'camp', 'Campinas')
PlotPolIso(sbc, iso_index, 'nox_mi', 'sbc', 'Sao Bernardo do Campo')
dev.off()
