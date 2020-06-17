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
russian_users = pd.read_csv("russian_users.csv", encoding = "ISO-8859-1", engine='python')
chinese_users = pd.read_csv("chinese_users.csv", encoding = "ISO-8859-1", engine='python')
american_users = pd.read_csv("unitedstates_users.csv", encoding = "ISO-8859-1", engine = 'python')
indian_users = pd.read_csv("indian_users.csv", encoding = "ISO-8859-1", engine = 'python')

# Putting the data into list form
russian_followers = russian_users['follower_count'].tolist()
chinese_followers = chinese_users['follower_count'].tolist()
american_followers = american_users['follower_count'].tolist()
indian_followers = indian_users['follower_count'].tolist()

russian_watchers = russian_users['watcher_count'].tolist()
chinese_watchers = chinese_users['watcher_count'].tolist()
american_watchers = american_users['watcher_count'].tolist()
indian_watchers = indian_users['watcher_count'].tolist()

russian_forkers = russian_users['fork_count'].tolist()
chinese_forkers = chinese_users['fork_count'].tolist()
american_forkers = american_users['fork_count'].tolist()
indian_forkers = indian_users['fork_count'].tolist()

# Setting the graph boundaries
ylim = (0, 1000)
xlim = (0, 800)

# Determining the largest data value in the set
maxfollow = np.max(russian_followers)
# Deriving the bin size from the largest value in the set
binsize = int(maxfollow/3)
#print(maxfollow)
# Plotting the first line
histplot(russian_followers, binsize, 'Users', 'Follower count', ylim, xlim, 'black', '', 'followers.png')
# Repeating the process for the rest of the data
maxfollow = np.max(chinese_followers)
binsize = int(maxfollow/3)
#print(maxfollow)
histplot(chinese_followers, binsize, 'Users', 'Follower count', ylim, xlim,'red', '', 'followers.png')
maxfollow = np.max(american_followers)
binsize = int(maxfollow/3)
#print(maxfollow)
histplot(american_followers, binsize, 'Users', 'Follower count', ylim, xlim, 'blue', '', 'followers.png')
maxfollow = np.max(indian_followers)
binsize = int(maxfollow/3)
#print(maxfollow)
histplot(indian_followers, binsize, 'Users', 'Follower count', ylim, xlim, 'green',
         'User Followers by Count', 'followers.png')
plt.close()

maxstar = np.max(russian_watchers)
binsize = int(maxstar/3)
#print(maxstar)
histplot(russian_watchers, binsize, 'Users', 'Follower count', ylim, xlim, 'black', '', 'watchers.png')
maxstar = np.max(chinese_watchers)
binsize = int(maxstar/3)
#print(maxstar)
histplot(chinese_watchers, binsize, 'Users', 'Follower count', ylim, xlim,'red', '', 'watchers.png')
maxstar = np.max(american_watchers)
binsize = int(maxstar/3)
#print(maxstar)
histplot(american_watchers, binsize, 'Users', 'Follower count', ylim, xlim, 'blue', '', 'watchers.png')
maxstar = np.max(indian_watchers)
binsize = int(maxstar/3)
#print(maxstar)
histplot(indian_watchers, binsize, 'Users', 'Star count', ylim, xlim, 'green',
         'User Watchers by Count', 'watchers.png')
plt.close()

maxfork = np.max(russian_forkers)
binsize = int(maxfork/3)
#print(maxfork)
histplot(russian_forkers, binsize, 'Users', 'Follower count', ylim, xlim, 'black', '', 'forkers.png')
maxfork = np.max(chinese_forkers)
binsize = int(maxfork/3)
#print(maxfork)
histplot(chinese_forkers, binsize, 'Users', 'Follower count', ylim, xlim,'red', '', 'forkers.png')
maxfork = np.max(american_forkers)
binsize = int(maxfork/3)
#print(maxfork)
histplot(american_forkers, binsize, 'Users', 'Follower count', ylim, xlim, 'blue', '','forkers.png')
maxfork = np.max(indian_forkers)
binsize = int(maxfork/3)
#print(maxfork)
histplot(indian_forkers, binsize, 'Users', 'Fork count', ylim, xlim, 'green',
         'User Forks by Count', 'forkers.png')
plt.close()