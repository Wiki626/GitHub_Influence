import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import powerlaw
from collections import Counter
import warnings

def logxy(data):
    data_count = dict(Counter(data))
    xy = []
    for i in data:
        for k, v in data_count.items():
            if i == k:
                xy.append((np.log(i),np.log(v)))
    array = np.array(xy)
    return(array)

def loglogscatter(array_data, color, title, ylab, xlab):
    plt.scatter(array_data[:,0], array_data[:,1], s=1, color=color)
    plt.ylabel(ylab)
    plt.xlabel(xlab)
    plt.title(title)

def fitlineplot(data, color):
    x = (logxy(data))[:, 0]
    y = (logxy(data))[:, 1]
    m, b = np.polyfit(x, y, 1)
    #print('The slope/intercept is %s, %s' %(m, b))
    plt.plot(x, (m * x + b), color=color)
    plt.ylim(bottom=0)

def fittest(data, dataset_name):
    warnings.filterwarnings('ignore')
    fit = powerlaw.Fit(data, discrete=True)
    R1, p1 = fit.distribution_compare('power_law', 'exponential', normalized_ratio=True)
    R2, p2 = fit.distribution_compare('power_law', 'lognormal', normalized_ratio=True)
    R3, p3 = fit.distribution_compare('power_law', 'truncated_power_law', normalized_ratio=True)
    R4, p4 = fit.distribution_compare('lognormal', 'truncated_power_law', normalized_ratio=True)
    print('The comparison values for %s are: Power Law/Exponential R=%s, p=%s, Power Law/Lognormal R=%s, p=%s, '
          'Power Law/Truncated Power Law R=%s, p=%s, Lognormal/Truncated Power Law R=%s, p=%s'
          %(dataset_name, R1, p1, R2, p2, R3, p3, R4, p4))
    print ('The Alpha value of %s is %s' %(dataset_name, fit.power_law.alpha))
    warnings.resetwarnings()

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

loglogscatter(logxy(russian_followers), 'black', 'Russian Followers by Count, LogLog Plot', 'Users', 'Follower Count')
fitlineplot(russian_followers, 'black')
plt.savefig('followers loglog russian .png')
plt.close()
fittest(russian_followers, 'Russian Followers')

loglogscatter(logxy(chinese_followers), 'red', 'Chinese Followers by Count, LogLog Plot', 'Users', 'Follower Count')
fitlineplot(chinese_followers, 'red')
plt.savefig('followers loglog chinese.png')
plt.close()
fittest(chinese_followers, 'Chinese Followers')

loglogscatter(logxy(american_followers), 'blue', 'American Followers by Count, LogLog Plot', 'Users', 'Follower Count')
fitlineplot(american_followers, 'blue')
plt.savefig('followers loglog american.png')
plt.close()
fittest(american_followers, 'American Followers')

loglogscatter(logxy(indian_followers), 'green', 'Indian Followers by Count, LogLog Plot', 'Users', 'Follower Count')
fitlineplot(indian_followers, 'green')
plt.savefig('followers loglog Indian.png')
plt.close()
fittest(indian_followers, 'Indian Followers')

loglogscatter(logxy(russian_followers), 'black', '', 'Users', 'Follower Count')
fitlineplot(russian_followers, 'black')
loglogscatter(logxy(chinese_followers), 'red', '', 'Users', 'Follower Count')
fitlineplot(chinese_followers, 'red')
loglogscatter(logxy(american_followers), 'blue', '', 'Users', 'Follower Count')
fitlineplot(american_followers, 'blue')
loglogscatter(logxy(indian_followers), 'green', 'Followers by Count, LogLog Plot', 'Users', 'Follower Count')
fitlineplot(indian_followers, 'green')
plt.savefig('followers loglog combined.png')
plt.close()

loglogscatter(logxy(russian_watchers), 'black', 'Russian Watchers by Count, LogLog Plot', 'Users', 'Star Count')
fitlineplot(russian_watchers, 'black')
plt.savefig('watchers loglog russian .png')
plt.close()
fittest(russian_watchers, 'Russian Watchers')

loglogscatter(logxy(chinese_watchers), 'red', 'Chinese Watchers by Count, LogLog Plot', 'Users', 'Star Count')
fitlineplot(chinese_watchers, 'red')
plt.savefig('watchers loglog chinese.png')
plt.close()
fittest(chinese_watchers, 'Chinese Watchers')

loglogscatter(logxy(american_watchers), 'blue', 'American Watchers by Count, LogLog Plot', 'Users', 'Star Count')
fitlineplot(american_watchers, 'blue')
plt.savefig('watchers loglog american.png')
plt.close()
fittest(american_watchers, 'American Watchers')

loglogscatter(logxy(indian_watchers), 'green', 'Indian Watchers by Count, LogLog Plot', 'Users', 'Star Count')
fitlineplot(indian_watchers, 'green')
plt.savefig('watchers loglog indian.png')
plt.close()
fittest(indian_watchers, 'Indian Watchers')

loglogscatter(logxy(russian_watchers), 'black', '', 'Users', 'Star Count')
fitlineplot(russian_watchers, 'black')
loglogscatter(logxy(chinese_watchers), 'red', '', 'Users', 'Star Count')
fitlineplot(chinese_watchers, 'red')
loglogscatter(logxy(american_watchers), 'blue', '', 'Users', 'Star Count')
fitlineplot(american_watchers, 'blue')
loglogscatter(logxy(indian_watchers), 'green', 'Watchers by Count, LogLog Plot', 'Users', 'Star Count')
fitlineplot(indian_watchers, 'green')
plt.savefig('watchers loglog combined.png')

loglogscatter(logxy(russian_forkers), 'black', 'Russian Forkers by Count, LogLog Plot', 'Users', 'Fork Count')
fitlineplot(russian_forkers, 'black')
plt.savefig('forkers loglog russian .png')
plt.close()
fittest(russian_forkers, 'Russian Forkers')

loglogscatter(logxy(chinese_forkers), 'red', 'Chinese Forkers by Count, LogLog Plot', 'Users', 'Fork Count')
fitlineplot(chinese_forkers, 'red')
plt.savefig('forkers loglog chinese.png')
plt.close()
fittest(chinese_forkers, 'Chinese Forkers')

loglogscatter(logxy(american_forkers), 'blue', 'American Forkers by Count, LogLog Plot', 'Users', 'Fork Count')
fitlineplot(american_forkers, 'blue')
plt.savefig('forkers loglog american.png')
plt.close()
fittest(american_forkers, 'American Forkers')

loglogscatter(logxy(indian_forkers), 'green', 'Indian Forkers by Count, LogLog Plot', 'Users', 'Fork Count')
fitlineplot(indian_forkers, 'green')
plt.savefig('forkers loglog indian.png')
plt.close()
fittest(indian_forkers, 'Indian Forkers')

loglogscatter(logxy(russian_forkers), 'black', '', 'Users', 'Fork Count')
fitlineplot(russian_forkers, 'black')
loglogscatter(logxy(chinese_forkers), 'red', '', 'Users', 'Fork Count')
fitlineplot(chinese_forkers, 'red')
loglogscatter(logxy(american_forkers), 'blue', '', 'Users', 'Fork Count')
fitlineplot(american_forkers, 'blue')
loglogscatter(logxy(indian_forkers), 'green', 'Forkers by Count, LogLog Plot', 'Users', 'Fork Count')
fitlineplot(indian_forkers, 'green')
plt.savefig('forkers loglog combined.png')