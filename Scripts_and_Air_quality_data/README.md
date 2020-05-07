# Instalation and run

## Install R

Install R for your operational system https://cran.r-project.org/
If you use Windows, install Rtools https://cran.r-project.org/bin/windows/Rtools/

## libraries

On R, install the packages data.table, magick, ggplot2, readxl and vein as


```r
install.packages(c("data.table", "magick", "ggplot2", "readxl", "vein"))
```

## Run the script

On R, run

```r
source("figs.R")
```

This will generate the figures anda data in the current directory 