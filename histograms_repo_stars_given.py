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
russian_6 = pd.read_csv(wd + "russian_stars_given_6_months_count.csv", encoding = "ISO-8859-1", engine = 'python')
chinese_6 = pd.read_csv(wd + "chinese_stars_given_6_months_count.csv", encoding = "ISO-8859-1", engine = 'python')
american_6 = pd.read_csv(wd + "unitedstates_stars_given_6_months_count.csv", encoding = "ISO-8859-1", engine = 'python')
indian_6 = pd.read_csv(wd + "indian_stars_given_6_months_count.csv", encoding = "ISO-8859-1", engine = 'python')

russian_all = pd.read_csv(wd + "russian_stars_given_all_count.csv", encoding = "ISO-8859-1", engine = 'python')
chinese_all = pd.read_csv(wd + "chinese_stars_given_all_count.csv", encoding = "ISO-8859-1", engine = 'python')
american_all = pd.read_csv(wd +"unitedstates_stars_given_all_count.csv", encoding = "ISO-8859-1", engine = 'python')
indian_all = pd.read_csv(wd +"indian_stars_given_all_count.csv", encoding = "ISO-8859-1", engine = 'python')

# Putting the data into list form
chinese_6 = chinese_6['star_count'].tolist()
american_6 = american_6['star_count'].tolist()
indian_6 = indian_6['star_count'].tolist()
russian_6 = russian_6['star_count'].tolist()

chinese_all = chinese_all['star_count'].tolist()
american_all = american_all['star_count'].tolist()
indian_all = indian_all['star_count'].tolist()
russian_all = russian_all['star_count'].tolist()

# Determining the largest data value in the set and setting the binsize
binsize = int(np.max(russian_6))
histplot(russian_6, binsize, 'Users', 'Star Count', 'black', '',)
# Repeating the process for the rest of the data
binsize = int(np.max(chinese_6))
histplot(chinese_6, binsize, 'Users', 'Star Count', 'red', '')
binsize = int(np.max(american_6))
histplot(american_6, binsize, 'Users', 'Star Count', 'blue', '')
binsize = int(np.max(indian_6))
histplot(indian_6, binsize, 'Users', 'Star Count', 'green', 'Jan-Jun 2019 Stars Given by Count, LogLog Scale Plot')
plt.savefig('logscale_jan-jun_stars_given.png')
plt.close()

multiplier = 15
binsize = int(np.max(russian_all)/multiplier)
histplot(russian_all, binsize, 'Users', 'Star Count', 'black', '',)
binsize = int(np.max(chinese_all)/multiplier)
histplot(chinese_all, binsize, 'Users', 'Star Count', 'red', '')
binsize = int(np.max(american_all)/multiplier)
histplot(american_6, binsize, 'Users', 'Star Count', 'blue', '')
binsize = int(np.max(indian_all)/multiplier)
histplot(indian_6, binsize, 'Users', 'Star Count', 'green', 'All Stars Given by Count, LogLog Scale Plot')
plt.savefig('logscale_all_stars_given.png')
plt.close()