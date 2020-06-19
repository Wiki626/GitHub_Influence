# Loading the required libraries
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Function to create histograms
def histplot(data, binsize, ylab, xlab, color, title):
    plt.hist(data, density=False, bins=binsize, color=color, fill=False, histtype='step')
    plt.yscale('log')
    plt.xscale('log')
    plt.ylabel(ylab)
    plt.xlabel(xlab)
    plt.title(title)

# Reading in CSVs with the data for the histograms
russian_repo_forks = pd.read_csv("russian_forks_6_months_count.csv", encoding = "ISO-8859-1", engine = 'python')
chinese_repo_forks = pd.read_csv("chinese_forks_6_months_count.csv", encoding = "ISO-8859-1", engine = 'python')
unitedstates_repo_forks = pd.read_csv("unitedstates_forks_6_months_count.csv", encoding = "ISO-8859-1", engine = 'python')
indian_repo_forks = pd.read_csv("indian_forks_6_months_count.csv", encoding = "ISO-8859-1", engine = 'python')

# Putting the data into list form
chinese_forks = chinese_repo_forks['fork_count'].tolist()
american_forks = unitedstates_repo_forks['fork_count'].tolist()
indian_forks = indian_repo_forks['fork_count'].tolist()
russian_forks = russian_repo_forks['fork_count'].tolist()

# Determining the largest data value in the set
maxfork = np.max(russian_forks)
# Deriving the bin size from the largest value in the set
binsize = int(maxfork)
# Plotting the first line
histplot(russian_forks, binsize, 'Users', 'Fork Count', 'black', '')
# Repeating the process for the rest of the data
maxfork = np.max(chinese_forks)
binsize = int(maxfork)
histplot(chinese_forks, binsize, 'Users', 'Fork Count', 'red', '')
maxfork = np.max(american_forks)
binsize = int(maxfork)
histplot(american_forks, binsize, 'Users', 'Fork Count', 'blue', '')
maxfork = np.max(indian_forks)
binsize = int(maxfork)
histplot(indian_forks, binsize, 'Users', 'Fork Count', 'green', 'Repository Forks Jan-Jul 2019 by Count, Loglog Scale Plot')
plt.savefig('logscale jan-jul_forks.png')
plt.close()
