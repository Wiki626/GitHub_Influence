# Loading the required libraries
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Function to create histograms
def histplot(data, binsize, ylab, xlab, color, title):
    plt.hist(data, density=False, bins=binsize, color=color, fill=False, histtype='step')
    plt.ylabel(ylab)
    plt.xlabel(xlab)
    plt.yscale('log')
    plt.xscale('log')
    plt.title(title)

# Reading in CSVs with the data for the histograms
russian_repo_watchers = pd.read_csv("russian_watchers_6_months_count.csv", encoding = "ISO-8859-1", engine = 'python')
chinese_repo_watchers = pd.read_csv("chinese_watchers_6_months_count.csv", encoding = "ISO-8859-1", engine = 'python')
unitedstates_repo_watchers = pd.read_csv("unitedstates_watchers_6_months_count.csv", encoding = "ISO-8859-1", engine = 'python')
indian_repo_watchers = pd.read_csv("indian_watchers_6_months_count.csv", encoding = "ISO-8859-1", engine = 'python')

# Putting the data into list form
chinese_watchers = chinese_repo_watchers['star_count'].tolist()
american_watchers = unitedstates_repo_watchers['star_count'].tolist()
indian_watchers = indian_repo_watchers['star_count'].tolist()
russian_watchers = russian_repo_watchers['star_count'].tolist()

# Determining the largest data value in the set
maxstar = np.max(russian_watchers)
# Deriving the bin size from the largest value in the set
binsize = int(maxstar)
# Plotting the first line
histplot(russian_watchers, binsize, 'Users', 'Star Count', 'black', '',)
# Repeating the process for the rest of the data
maxstar = np.max(chinese_watchers)
binsize = int(maxstar)
histplot(chinese_watchers, binsize, 'Users', 'Star Count', 'red', '')
maxstar = np.max(american_watchers)
binsize = int(maxstar)
histplot(american_watchers, binsize, 'Users', 'Star Count', 'blue', '')
maxstar = np.max(indian_watchers)
binsize = int(maxstar)
histplot(indian_watchers, binsize, 'Users', 'Star Count', 'green', 'Repository Stars Jan-Jul 2019 by Count, LogLog Scale Plot')
plt.savefig('logscale jan-jul_watchers.png')
plt.close()