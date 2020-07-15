# Loading the required libraries
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import os
import powerlaw

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
russian_all = pd.read_csv(wd + "russian_follows_given_all_count.csv", encoding = "ISO-8859-1", engine = 'python')
chinese_all = pd.read_csv(wd + "chinese_follows_given_all_count.csv", encoding = "ISO-8859-1", engine = 'python')
american_all = pd.read_csv(wd +"unitedstates_follows_given_all_count.csv", encoding = "ISO-8859-1", engine = 'python')
indian_all = pd.read_csv(wd +"indian_follows_given_all_count.csv", encoding = "ISO-8859-1", engine = 'python')

# Putting the data into list form
chinese_all = chinese_all['follows'].tolist()
american_all = american_all['follows'].tolist()
indian_all = indian_all['follows'].tolist()
russian_all = russian_all['follows'].tolist()

# Plotting the lines
# Deriving the bin size from the largest value in the set
binsize = int(np.max(russian_all))
histplot(russian_all, binsize, 'Users', 'Follow Count', 'black', '')
binsize = int(np.max(chinese_all))
histplot(chinese_all, binsize, 'Users', 'Follow Count', 'red', '')
binsize = int(np.max(american_all))
histplot(american_all, binsize, 'Users', 'Follow Count', 'blue', '')
binsize = int(np.max(indian_all))
histplot(indian_all, binsize, 'Users', 'Follow Count', 'green', 'All Follows Given by Count, Loglog Scale Plot')
plt.savefig('logscale_all_follows_given.png')
plt.close()

powerlaw.plot_pdf(russian_all, color='black')
powerlaw.plot_pdf(chinese_all, color='red')
powerlaw.plot_pdf(american_all, color='blue')
powerlaw.plot_pdf(indian_all, color='green')
plt.ylabel('Users')
plt.xlabel('Follow Count')
plt.title('All Follows Given by Count, PDF')
plt.savefig('pdf_all_follows_given.png')
plt.close()

powerlaw.plot_ccdf(russian_all, color='black')
powerlaw.plot_ccdf(chinese_all, color='red')
powerlaw.plot_ccdf(american_all, color='blue')
powerlaw.plot_ccdf(indian_all, color='green')
plt.ylabel('Users')
plt.xlabel('Follow Count')
plt.title('All Follows Given by Count, CCDF')
plt.savefig('ccdf_all_follows_given.png')
plt.close()