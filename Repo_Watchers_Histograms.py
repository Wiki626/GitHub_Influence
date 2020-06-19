# Loading the required libraries
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Function to create histograms
def histplot(data, binsize, ylab, xlab, ylim, xlim, color, title, savename):
    plt.hist(data, density=False, bins=binsize, color=color, fill=False, histtype='step')
    plt.ylabel(ylab)
    plt.xlabel(xlab)
    plt.ylim(ylim)
    plt.xlim(xlim)
    plt.title(title)
    plt.savefig(savename)

# Reading in CSVs with the data for the histograms
russian_repo_watchers = pd.read_csv("russian_watchers_6_months_all.csv", encoding = "ISO-8859-1", engine = 'python')
chinese_repo_watchers = pd.read_csv("chinese_watchers_6_months_all.csv", encoding = "ISO-8859-1", engine = 'python')
unitedstates_repo_watchers = pd.read_csv("unitedstates_watchers_6_months_all.csv", encoding = "ISO-8859-1", engine = 'python')
indian_repo_watchers = pd.read_csv("indian_watchers_6_months_all.csv", encoding = "ISO-8859-1", engine = 'python')

# Putting the data into list form
chinese_watchers = chinese_repo_watchers['star_count'].tolist()
american_watchers = unitedstates_repo_watchers['star_count'].tolist()
indian_watchers = indian_repo_watchers['star_count'].tolist()
russian_watchers = russian_repo_watchers['star_count'].tolist()

# Setting the graph boundaries
ylim = (0, 1000)
xlim = (0, 300)

# Determining the largest data value in the set
maxstar = np.max(russian_watchers)
# Deriving the bin size from the largest value in the set
binsize = int(maxstar/3)
# Plotting the first line
histplot(russian_watchers, binsize, 'User Count', 'Star Count', ylim, xlim, 'black', '', 'jan-jul_watchers.png')
# Repeating the process for the rest of the data
maxstar = np.max(chinese_watchers)
binsize = int(maxstar/3)
histplot(chinese_watchers, binsize, 'User Count', 'Star Count', ylim, xlim, 'red', '', 'jan-jul_watchers.png')
maxstar = np.max(american_watchers)
binsize = int(maxstar/3)
histplot(american_watchers, binsize, 'User Count', 'Star Count', ylim, xlim, 'blue', '', 'jan-jul_watchers.png')
maxstar = np.max(indian_watchers)
binsize = int(maxstar/3)
histplot(indian_watchers, binsize, 'User Count', 'Star Count', ylim, xlim, 'green', 'Repository Stars Jan-Jul 2019 by Count', 'jan-jul_watchers.png')
plt.close()