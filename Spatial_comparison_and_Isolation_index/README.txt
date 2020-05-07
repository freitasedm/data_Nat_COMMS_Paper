README

To create Fig 2, we split the process into two parts that are reflected in two scripts: 01_calculate_masp_aqs_mean_difference.R and 02_plot_map_masp_aqs_mean_difference.ipynb. The fist script calculates the mean concentration difference for each CETESB air quality station (AQS), located inside the metropolitan area of Sao Paulo between evaluated weeks. It returns csv files with the mean concentration difference for each AQS with their respective latitude and coordinate. Those files will be the input for the second script, which will create the individuals maps. Finally, the Supplementary Fig 1 was created using the script. 03_plot_nox_vs_isolation_index.R 

1. DIRECTORIES

├── 01_scripts
├── 02_data
│   ├── cetesb_data
│   ├── processed_data
│   └── raw_data
│       └── masp_shp
└── 03_output_figs

01_scripts:
Include all the scripts to process the data and create the plots
02_data
    cetesb_data: csv files for each CETESB station generated using cetesb_010320_140420.Rds  raw data.
    Processed_data: 
        cetesb_masp_aqs_lat_lon.csv : AQS  names for MASP  with latitude and coordinates
        isolation_index_five_mun_sp_170320_130420.csv: csv file with no header and only for the five most populated cities of Sao Paulo State gerated from Taxa-Isolamento-por-Município_14Abr-3.xlsx raw data.
    raw_data: 
        cetesb_010320_140420.Rds: AQS pollutant data for all Sao Paulo State
        cetesb_masp_010320_140420.Rds: AQS pollutant data for MASP
        Taxa-Isolamento-por-Município_14Abr-3.xlsx: Isolation index per Sao Paulo State city.
03_output_figs:
Directory to store produced figures.


2. SYSTEM REQUIREMENTS 

The scripts were tested in Ubuntu Linux with R v.3.6.3 and with Python 3.7.7 via miniconda3. 

R packages:
    - openair_2.7
    - data.table_1.12.8
Python Packages
    - Numpy 1.18
    - Pandas 1.0.3
    - Matplotlib 3.1.3
    - Basemap 1.2.0
    - Proj4 5.2.0


3. INSTALLATION GUIDE
It is recommended to use Rstudio and Jupyter Lab to run the scripts. 

To install R packages, type in R console:
install.packages(c(“openair”, “data.table”)

To install Python packages, type on terminal:
conda install numpy=1.18 pandas=1.0.3 matplotlib=3.1.3 basemap=1.2.0 proj4=5.2.0

4. DEMO

- Instruction to use:

To create Fig 2. 
In Rstudio  open Spatial_comp_iso_index.Rproj and run 01_calculate_masp_aqs_mean_difference.R, then run the 02_plot_map_masp_aqs_mean_difference.ipynb jupyter notebook. A python script is also provided that can be run by: python 02_plot_map_masp_aqs_mean_difference.py.

To create Supplementary Fig 1:
In RStudio open Spatial_comp_iso_index.Rproj and run 03_plot_nox_vs_isolation_index.R

- Expected output:
Individual maps for each pollutant and evaluated weeks that can be latter merge using Inkscape (Fig 2.pdf) and Supplementary Fig 1 (Supplementary_Fig1.png) .

- Expected run time for demo on a normal desktop computer
Running all the three scripts could take 45 seconds.








