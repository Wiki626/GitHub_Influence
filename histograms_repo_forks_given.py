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
# Deriving the bin size from the largest value in the set
binsize = int(np.max(russian_6))
histplot(russian_6, binsize, 'Users', 'Fork Count', 'black', '')
binsize = int(np.max(chinese_6))
histplot(chinese_6, binsize, 'Users', 'Fork Count', 'red', '')
binsize = int(np.max(american_6))
histplot(american_6, binsize, 'Users', 'Fork Count', 'blue', '')
binsize = int(np.max(indian_6))
histplot(indian_6, binsize, 'Users', 'Fork Count', 'green', 'Jan-Jun 2019 Forks Given by Count, Loglog Scale Plot')
plt.savefig('logscale_jan-jun_forks_given.png')
plt.close()

binsize = int(np.max(russian_all))
histplot(russian_all, binsize, 'Users', 'Fork Count', 'black', '')
binsize = int(np.max(chinese_all))
histplot(chinese_all, binsize, 'Users', 'Fork Count', 'red', '')
binsize = int(np.max(american_all))
histplot(american_all, binsize, 'Users', 'Fork Count', 'blue', '')
binsize = int(np.max(indian_all))
histplot(indian_all, binsize, 'Users', 'Fork Count', 'green', 'All Forks Given by Count, Loglog Scale Plot')
plt.savefig('logscale_all_forks_given.png')
plt.close()

powerlaw.plot_pdf(russian_6, color='black')
powerlaw.plot_pdf(chinese_6, color='red')
powerlaw.plot_pdf(american_6, color='blue')
powerlaw.plot_pdf(indian_6, color='green')
plt.ylabel('Users')
plt.xlabel('Fork Count')
plt.title('Jan-Jun 2019 Forks Given by Count, PDF')
plt.savefig('pdf_jan-jun_forks_given.png')
plt.close()

powerlaw.plot_ccdf(russian_6, color='black')
powerlaw.plot_ccdf(chinese_6, color='red')
powerlaw.plot_ccdf(american_6, color='blue')
powerlaw.plot_ccdf(indian_6, color='green')
plt.ylabel('Users')
plt.xlabel('Fork Count')
plt.title('Jan-Jun 2019 Forks Given by Count, CCDF')
plt.savefig('ccdf_jan-jun_forks_given.png')
plt.close()

powerlaw.plot_pdf(russian_all, color='black')
powerlaw.plot_pdf(chinese_all, color='red')
powerlaw.plot_pdf(american_all, color='blue')
powerlaw.plot_pdf(indian_all, color='green')
plt.ylabel('Users')
plt.xlabel('Fork Count')
plt.title('All Forks Given by Count, PDF')
plt.savefig('pdf_all_forks_given.png')
plt.close()

powerlaw.plot_ccdf(russian_all, color='black')
powerlaw.plot_ccdf(chinese_all, color='red')
powerlaw.plot_ccdf(american_all, color='blue')
powerlaw.plot_ccdf(indian_all, color='green')
plt.ylabel('Users')
plt.xlabel('Fork Count')
plt.title('All Forks Given by Count, CCDF')
plt.savefig('ccdf_all_forks_given.png')
plt.close()