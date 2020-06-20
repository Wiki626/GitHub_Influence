# Loading the required libraries
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import os

# Function to create histograms
def histplot(data, binsize, ylab, xlab, color, title):
    plt.hist(data, density=False, bins=binsize, color=color, fill=False, histtype='step')
    plt.yscale('log')
    plt.xscale('log')
    plt.xlim(left=1)
    plt.ylabel(ylab)
    plt.xlabel(xlab)
    plt.title(title)

# Set the working directory
wd = os.getcwd() + '\\given\\'

# Reading in CSVs with the data for the histograms
russian_6 = pd.read_csv(wd + "russian_forks_given_6_months_count.csv", encoding = "ISO-8859-1", engine = 'python')
chinese_6 = pd.read_csv(wd + "chinese_forks_given_6_months_count.csv", encoding = "ISO-8859-1", engine = 'python')
american_6 = pd.read_csv(wd + "unitedstates_forks_given_6_months_count.csv", encoding = "ISO-8859-1", engine = 'python')
indian_6 = pd.read_csv(wd + "indian_forks_given_6_months_count.csv", encoding = "ISO-8859-1", engine = 'python')

russian_all = pd.read_csv(wd + "russian_forks_given_all_count.csv", encoding = "ISO-8859-1", engine = 'python')
chinese_all = pd.read_csv(wd + "chinese_forks_given_all_count.csv", encoding = "ISO-8859-1", engine = 'python')
american_all = pd.read_csv(wd +"unitedstates_forks_given_all_count.csv", encoding = "ISO-8859-1", engine = 'python')
indian_all = pd.read_csv(wd +"indian_forks_given_all_count.csv", encoding = "ISO-8859-1", engine = 'python')

# Putting the data into list form
chinese_6 = chinese_6['fork_count'].tolist()
american_6 = american_6['fork_count'].tolist()
indian_6 = indian_6['fork_count'].tolist()
russian_6 = russian_6['fork_count'].tolist()

chinese_all = chinese_all['fork_count'].tolist()
american_all = american_all['fork_count'].tolist()
indian_all = indian_all['fork_count'].tolist()
russian_all = russian_all['fork_count'].tolist()

# Plotting the lines
maxstar = np.max(russian_6)
# Deriving the bin size from the largest value in the set
binsize = int(maxstar)
histplot(russian_6, binsize, 'Users', 'Fork Count', 'black', '')
maxstar = np.max(chinese_6)
binsize = int(maxstar)
histplot(chinese_6, binsize, 'Users', 'Fork Count', 'red', '')
maxstar = np.max(american_6)
binsize = int(maxstar)
histplot(american_6, binsize, 'Users', 'Fork Count', 'blue', '')
maxstar = np.max(indian_6)
binsize = int(maxstar)
histplot(indian_6, binsize, 'Users', 'Fork Count', 'green', 'Jan-Jun 2019 Forks Given by Count, Loglog Scale Plot')
plt.savefig('logscale_jan-jun_forks_given.png')
plt.close()

maxstar = np.max(russian_all)
binsize = int(maxstar)
histplot(russian_all, binsize, 'Users', 'Fork Count', 'black', '')
maxstar = np.max(chinese_all)
binsize = int(maxstar)
histplot(chinese_all, binsize, 'Users', 'Fork Count', 'red', '')
maxstar = np.max(american_all)
binsize = int(maxstar)
histplot(american_all, binsize, 'Users', 'Fork Count', 'blue', '')
maxstar = np.max(indian_all)
binsize = int(maxstar)
histplot(indian_all, binsize, 'Users', 'Fork Count', 'green', 'All Forks Stars Given by Count, Loglog Scale Plot')
plt.savefig('logscale_all_forks_given.png')
plt.close()
