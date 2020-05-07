# Readme file for paper *Mobility restrictions and air quality under COVID-19 pandemic in São Paulo, Brazil*

## Directories

This directory includes

```
├───apple
├───figuras
├───RDS
└───stations
```

- apple: includes the file apple\applemobilitytrends-2020-04-13.csv.
- figuras: directory to store the figures.
- RDS: directory with the air quality data in .rds format.
- stations: directory with the name of the air quality stations by pollutants

## System requirements

Any operation system than can install R v4.0.0. Currently includes Windows, Mac, Linux, Solaris etc.

## Software dependencies and operanting systems

The required libraries already includes the necessary dependencies

## Versions the software has been tested

OS Windows 10
Rstudio Version 1.2.5001
R version 3.6.1 (2019-07-05)
Platform: x86_64-w64-mingw32/x64 (64-bit)  
Running under: Windows 10 x64 (build 18362)
packages:

- vein_0.8.8
- readxl_1.3.1
- magick_2.2
- ggplot2_3.2.1    
- data.table_1.12.8

## Installation guide

### Install R

Install R for your operational system https://cran.r-project.org/
If you use Windows, install Rtools https://cran.r-project.org/bin/windows/Rtools/

### Install Rstudio 

https://rstudio.com/products/rstudio/download/


### libraries

On R, install the packages data.table, magick, ggplot2, readxl and vein as


```r
install.packages(c("data.table", "magick", "ggplot2", "readxl", "vein"))
```

### Open the file project.Rproj

Using Rstudio, open the file project.Rproj

### Run the script

run the script figs.R

```r
source("figs.R")
```


## Expected output

This will generate the figures in the current directory directory *figures* and text files on directory *stations*.

## Expected run time for demo on a "normal" desktop computer

36 secs

## How to run the software on your data

Display data in long format with time as POSIXct class, observations, according shown on file figs.R



