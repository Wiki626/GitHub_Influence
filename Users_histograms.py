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
russian_users = pd.read_csv("russian_users.csv", encoding = "ISO-8859-1", engine='python')
chinese_users = pd.read_csv("chinese_users.csv", encoding = "ISO-8859-1", engine='python')
american_users = pd.read_csv("unitedstates_users.csv", encoding = "ISO-8859-1", engine = 'python')
indian_users = pd.read_csv("indian_users.csv", encoding = "ISO-8859-1", engine = 'python')

# Putting the data into list form and popping the zeros off
russian_followers = russian_users['follower_count'].tolist()
chinese_followers = chinese_users['follower_count'].tolist()
american_followers = american_users['follower_count'].tolist()
indian_followers = indian_users['follower_count'].tolist()
russian_followers = [i for i in russian_followers if i != 0]
chinese_followers = [i for i in chinese_followers if i != 0]
american_followers = [i for i in american_followers if i != 0]
indian_followers = [i for i in indian_followers if i != 0]

russian_watchers = russian_users['watcher_count'].tolist()
chinese_watchers = chinese_users['watcher_count'].tolist()
american_watchers = american_users['watcher_count'].tolist()
indian_watchers = indian_users['watcher_count'].tolist()
russian_watchers = [i for i in russian_watchers if i != 0]
chinese_watchers = [i for i in chinese_watchers if i != 0]
american_watchers = [i for i in american_watchers if i != 0]
indian_watchers = [i for i in indian_watchers if i != 0]

russian_forkers = russian_users['fork_count'].tolist()
chinese_forkers = chinese_users['fork_count'].tolist()
american_forkers = american_users['fork_count'].tolist()
indian_forkers = indian_users['fork_count'].tolist()
russian_forkers = [i for i in russian_forkers if i != 0]
chinese_forkers = [i for i in chinese_forkers if i != 0]
american_forkers = [i for i in american_forkers if i != 0]
indian_forkers = [i for i in indian_forkers if i != 0]

# Determining the largest data value in the set
maxfollow = np.max(russian_followers)
# Deriving the bin size from the largest value in the set
binsize = int(maxfollow)
#print(maxfollow)
# Plotting the first line
histplot(russian_followers, binsize, 'Users', 'Follower count', 'black', '')
# Repeating the process for the rest of the data
maxfollow = np.max(chinese_followers)
binsize = int(maxfollow)
#print(maxfollow)
histplot(chinese_followers, binsize, 'Users', 'Follower count', 'red', '')
maxfollow = np.max(american_followers)
binsize = int(maxfollow)
#print(maxfollow)
histplot(american_followers, binsize, 'Users', 'Follower count', 'blue', '')
maxfollow = np.max(indian_followers)
binsize = int(maxfollow)
#print(maxfollow)
histplot(indian_followers, binsize, 'Users', 'Follower count', 'green', 'User Followers by Count, LogLog Scale Plot')
plt.savefig('histogram loglog scale followers.png')
plt.close()

maxstar = np.max(russian_watchers)
binsize = int(maxstar)
#print(maxstar)
histplot(russian_watchers, binsize, 'Users', 'Star count', 'black', '')
maxstar = np.max(chinese_watchers)
binsize = int(maxstar)
#print(maxstar)
histplot(chinese_watchers, binsize, 'Users', 'Star count', 'red', '')
maxstar = np.max(american_watchers)
binsize = int(maxstar)
#print(maxstar)
histplot(american_watchers, binsize, 'Users', 'Star count', 'blue', '')
maxstar = np.max(indian_watchers)
binsize = int(maxstar)
#print(maxstar)
histplot(indian_watchers, binsize, 'Users', 'Star count', 'green', 'User Watchers by Count, LogLog Scale Plot')
plt.savefig('histogram loglog scale watchers.png')
plt.close()

maxfork = np.max(russian_forkers)
binsize = int(maxfork)
#print(maxfork)
histplot(russian_forkers, binsize, 'Users', 'Fork count', 'black', '')
maxfork = np.max(chinese_forkers)
binsize = int(maxfork)
#print(maxfork)
histplot(chinese_forkers, binsize, 'Users', 'Fork count', 'red', '')
maxfork = np.max(american_forkers)
binsize = int(maxfork)
#print(maxfork)
histplot(american_forkers, binsize, 'Users', 'Fork count', 'blue', '')
maxfork = np.max(indian_forkers)
binsize = int(maxfork)
#print(maxfork)
histplot(indian_forkers, binsize, 'Users', 'Fork count', 'green', 'User Forks by Count, LogLog Scale Plot')
plt.savefig('histogram loglog scale forkers.png')
plt.close()