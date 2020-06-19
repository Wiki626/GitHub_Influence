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
russian_repo_forks = pd.read_csv("russian_forks_6_months_all.csv", encoding = "ISO-8859-1", engine = 'python')
chinese_repo_forks = pd.read_csv("chinese_forks_6_months_all.csv", encoding = "ISO-8859-1", engine = 'python')
unitedstates_repo_forks = pd.read_csv("unitedstates_forks_6_months_all.csv", encoding = "ISO-8859-1", engine = 'python')
indian_repo_forks = pd.read_csv("indian_forks_6_months_all.csv", encoding = "ISO-8859-1", engine = 'python')

# Putting the data into list form
chinese_forks = chinese_repo_forks['fork_count'].tolist()
american_forks = unitedstates_repo_forks['fork_count'].tolist()
indian_forks = indian_repo_forks['fork_count'].tolist()
russian_forks = russian_repo_forks['fork_count'].tolist()

# Setting the graph boundaries
ylim = (0, 1000)
xlim = (0, 80)

# Determining the largest data value in the set
maxfork = np.max(russian_forks)
# Deriving the bin size from the largest value in the set
binsize = int(maxfork/2)
# Plotting the first line
histplot(russian_forks, binsize, 'User Count', 'Fork Count', ylim, xlim, 'black', '', 'jan-jul_forks.png')
# Repeating the process for the rest of the data
maxfork = np.max(chinese_forks)
binsize = int(maxfork/2)
histplot(chinese_forks, binsize, 'User Count', 'Fork Count', ylim, xlim, 'red', '', 'jan-jul_forks.png')
maxfork = np.max(american_forks)
binsize = int(maxfork/2)
histplot(american_forks, binsize, 'User Count', 'Fork Count', ylim, xlim, 'blue', '', 'jan-jul_forks.png')
maxfork = np.max(indian_forks)
binsize = int(maxfork/2)
histplot(indian_forks, binsize, 'User Count', 'Fork Count', ylim, xlim, 'green', 'Repository Forks Jan-Jul 2019 by Count', 'jan-jul_forks.png')
plt.close()