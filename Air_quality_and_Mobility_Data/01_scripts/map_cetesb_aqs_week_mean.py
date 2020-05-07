import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap
from mpl_toolkits.axes_grid1 import make_axes_locatable
from matplotlib.collections import PatchCollection
from matplotlib.patches import Polygon

# Loading the differences

dif_w1_sem = pd.read_csv("../02_data/pre_processed_data/dif_w1_sem.csv")
dif_w2_w1 = pd.read_csv("../02_data/pre_processed_data/dif_w2_w1.csv")
dif_w3_w1 = pd.read_csv("../02_data/pre_processed_data/dif_w3_w1.csv")


# Creating a function to plot map with concentration difference

def plot_diff_rmsp_per(pol, title, bar_label, w4):
    """ Map showing concentration differences in each 
     cetesb air quality station
     
    Parameters:
    -----------
    pol: str
        polutant col name of dataframe w4
    title: str
        plot title 
    pol: str
        color bar label
    pol: str
        data frame with concentration difference
        
    
    Returns:
    -----------
    a map in svg format
    """
    
    path = "../03_output_figs/"
    file_name = (path + pol + '_' + title.replace(" ", "_").replace("_-_", "-") + ".svg")
    
    fig = plt.figure(figsize=(12, 18))
    ax = fig.add_subplot(111)
    ax.set_title(title, size=20)
    m = Basemap(llcrnrlon=-47.10 - 0.15,
                llcrnrlat=-24.05 - 0.15,
                urcrnrlon=-45.70 + 0.15,
                urcrnrlat=-23.15 + 0.15,
                projection='merc', resolution='h')
    m.drawcoastlines(linewidth=1.5)
    m.drawcountries(linewidth=1.5)
    m.drawstates(linewidth=1.25)
    xm, ym = m(w4.lon.values, w4.lat.values)
    m.readshapefile("../02_data/raw_data/rmsp_shp/rmsp_shp", "rmsp", color="grey", linewidth=1.5, zorder=1)
    sc = m.scatter(xm, ym, c=w4[pol].values, cmap = "coolwarm", s=300,
                   vmin=-100, vmax=100)
    divider = make_axes_locatable(ax)
    cax=divider.append_axes("right", size="5%", pad=0.05)
    cbar = plt.colorbar(sc, cax=cax)
    cbar.set_label(bar_label,labelpad=30, size=25)
    cbar.ax.tick_params(labelsize=20)
    plt.savefig(file_name, bbox_inches="tight")
    plt.clf()
    
# Making list of pol, title, bar_name to make loop to plots

pol_names = ["o3", "nox_mi", "pm10", "pm25", "co"]
bar_label = ["$O_3 \; (\%)$", "$NO_X \; (\%)$", "$PM_{10} \; (\%)$", "$PM_{2.5} \; (\%)$", "$CO \; (\%)$"]
plot_titles = ["1st week of quarantine - Normal week",
               "2nd week of quarantine - 1st week of quarantine",
               "3th week of quarantine - 1st week of quarantine"]
dif_list = [dif_w1_sem, dif_w2_w1, dif_w3_w1]


# Making the plots

for i in range(len(dif_list)):
    for j in range(len(pol_names)):
        plot_diff_rmsp_per(pol_names[j],
                           plot_titles[i],
                           bar_label[j],
                           dif_list[i])
