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
wd = os.getcwd() + '\\received\\'

# Reading in CSVs with the data for the histograms
russian_all = pd.read_csv(wd + "russian_users_received_all.csv", encoding = "ISO-8859-1", engine='python')
chinese_all = pd.read_csv(wd + "chinese_users_received_all.csv", encoding = "ISO-8859-1", engine='python')
american_all = pd.read_csv(wd + "unitedstates_users_received_all.csv", encoding = "ISO-8859-1", engine = 'python')
indian_all = pd.read_csv(wd + "indian_users_received_all.csv", encoding = "ISO-8859-1", engine = 'python')

russian_6_star = pd.read_csv(wd + "russian_stars_received_6_months.csv", encoding = "ISO-8859-1", engine='python')
chinese_6_star = pd.read_csv(wd + "chinese_stars_received_6_months.csv", encoding = "ISO-8859-1", engine='python')
american_6_star = pd.read_csv(wd + "unitedstates_stars_received_6_months.csv", encoding = "ISO-8859-1", engine = 'python')
indian_6_star = pd.read_csv(wd + "indian_stars_received_6_months.csv", encoding = "ISO-8859-1", engine = 'python')

russian_6_fork = pd.read_csv(wd + "russian_forks_received_6_months.csv", encoding = "ISO-8859-1", engine='python')
chinese_6_fork = pd.read_csv(wd + "chinese_forks_received_6_months.csv", encoding = "ISO-8859-1", engine='python')
american_6_fork = pd.read_csv(wd + "unitedstates_forks_received_6_months.csv", encoding = "ISO-8859-1", engine = 'python')
indian_6_fork = pd.read_csv(wd + "indian_forks_received_6_months.csv", encoding = "ISO-8859-1", engine = 'python')

# Putting the data into list form and popping the zeros off
russian_followers_all = russian_all['follower_count'].tolist()
chinese_followers_all = chinese_all['follower_count'].tolist()
american_followers_all = american_all['follower_count'].tolist()
indian_followers_all = indian_all['follower_count'].tolist()
russian_followers_all = [i for i in russian_followers_all if i != 0]
chinese_followers_all = [i for i in chinese_followers_all if i != 0]
american_followers_all = [i for i in american_followers_all if i != 0]
indian_followers_all = [i for i in indian_followers_all if i != 0]

russian_watchers_all = russian_all['watcher_count'].tolist()
chinese_watchers_all = chinese_all['watcher_count'].tolist()
american_watchers_all = american_all['watcher_count'].tolist()
indian_watchers_all = indian_all['watcher_count'].tolist()
russian_watchers_all = [i for i in russian_watchers_all if i != 0]
chinese_watchers_all = [i for i in chinese_watchers_all if i != 0]
american_watchers_all = [i for i in american_watchers_all if i != 0]
indian_watchers_all = [i for i in indian_watchers_all if i != 0]

russian_forkers_all = russian_all['fork_count'].tolist()
chinese_forkers_all = chinese_all['fork_count'].tolist()
american_forkers_all = american_all['fork_count'].tolist()
indian_forkers_all = indian_all['fork_count'].tolist()
russian_forkers_all = [i for i in russian_forkers_all if i != 0]
chinese_forkers_all = [i for i in chinese_forkers_all if i != 0]
american_forkers_all = [i for i in american_forkers_all if i != 0]
indian_forkers_all = [i for i in indian_forkers_all if i != 0]

chinese_6_star = chinese_6_star['star_count'].tolist()
american_6_star = american_6_star['star_count'].tolist()
indian_6_star = indian_6_star['star_count'].tolist()
russian_6_star = russian_6_star['star_count'].tolist()

chinese_6_fork = chinese_6_fork['fork_count'].tolist()
american_6_fork = american_6_fork['fork_count'].tolist()
indian_6_fork = indian_6_fork['fork_count'].tolist()
russian_6_fork = russian_6_fork['fork_count'].tolist()

# Deriving the bin size from the largest value in the set
binsize = int(np.max(russian_followers_all))
# Plotting the first line
histplot(russian_followers_all, binsize, 'Users', 'Follower count', 'black', '')
# Repeating the process for the rest of the data
binsize = int(np.max(chinese_followers_all))
histplot(chinese_followers_all, binsize, 'Users', 'Follower count', 'red', '')
binsize = int(np.max(american_followers_all))
histplot(american_followers_all, binsize, 'Users', 'Follower count', 'blue', '')
binsize = int(np.max(indian_followers_all))
histplot(indian_followers_all, binsize, 'Users', 'Follower count', 'green', 'User All Follows Received by Count, LogLog Scale Plot')
plt.savefig('logscale_all_follow_received.png')
plt.close()

binsize = int(np.max(russian_watchers_all))
histplot(russian_watchers_all, binsize, 'Users', 'Star count', 'black', '')
binsize = int(np.max(chinese_watchers_all))
histplot(chinese_watchers_all, binsize, 'Users', 'Star count', 'red', '')
binsize = int(np.max(american_watchers_all))
histplot(american_watchers_all, binsize, 'Users', 'Star count', 'blue', '')
binsize = int(np.max(indian_watchers_all))
histplot(indian_watchers_all, binsize, 'Users', 'Star count', 'green', 'User All Stars Received by Count, LogLog Scale Plot')
plt.savefig('logscale_all_stars_received.png')
plt.close()

binsize = int(np.max(russian_forkers_all))
histplot(russian_forkers_all, binsize, 'Users', 'Fork count', 'black', '')
binsize = int(np.max(chinese_forkers_all))
histplot(chinese_forkers_all, binsize, 'Users', 'Fork count', 'red', '')
binsize = int(np.max(american_forkers_all))
histplot(american_forkers_all, binsize, 'Users', 'Fork count', 'blue', '')
binsize = int(np.max(indian_forkers_all))
histplot(indian_forkers_all, binsize, 'Users', 'Fork count', 'green', 'User All Forks Received by Count, LogLog Scale Plot')
plt.savefig('logscale_all_forks_received.png')
plt.close()

multiplier = 7
binsize = int(np.max(russian_6_star)/5)
histplot(russian_6_star, binsize, 'Users', 'Star count', 'black', '')
binsize = int(np.max(chinese_6_star)/multiplier)
histplot(chinese_6_star, binsize, 'Users', 'Star count', 'red', '')
binsize = int(np.max(american_6_star)/multiplier)
histplot(american_6_star, binsize, 'Users', 'Star count', 'blue', '')
binsize = int(np.max(indian_watchers_all)/multiplier)
histplot(indian_6_star, binsize, 'Users', 'Star count', 'green', 'User Jan-Jun 2019 Stars Received by Count, LogLog Scale Plot')
plt.savefig('logscale_jan-jun_stars_received.png')
plt.close()

multiplier = 6
binsize = int(np.max(russian_6_fork)/multiplier)
histplot(russian_6_fork, binsize, 'Users', 'Fork count', 'black', '')
binsize = int(np.max(chinese_6_fork)/multiplier)
histplot(chinese_6_fork, binsize, 'Users', 'Fork count', 'red', '')
binsize = int(np.max(american_forkers_all)/multiplier)
histplot(american_6_fork, binsize, 'Users', 'Fork count', 'blue', '')
binsize = int(np.max(indian_6_fork)/multiplier)
histplot(indian_6_fork, binsize, 'Users', 'Fork count', 'green', 'User Jan-Jun Forks Received by Count, LogLog Scale Plot')
plt.savefig('logscale_jan-jun_forks_received.png')
plt.close()