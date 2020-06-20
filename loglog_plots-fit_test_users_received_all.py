# Loading the required libraries
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import powerlaw
from collections import Counter
import warnings
import os

# Function to create loglog xys from data
def logxy(data):
    data_count = dict(Counter(data))
    xy = []
    for i in data:
        for k, v in data_count.items():
            if i == k:
                xy.append((np.log(i),np.log(v)))
    array = np.array(xy)
    return(array)

# Function to create scatterplots
def loglogscatter(array_data, color, title, ylab, xlab):
    plt.scatter(array_data[:,0], array_data[:,1], s=1, color=color)
    plt.ylabel(ylab)
    plt.xlabel(xlab)
    plt.title(title)

# function to create fit lines
def fitlineplot(data, color):
    x = (logxy(data))[:, 0]
    y = (logxy(data))[:, 1]
    m, b = np.polyfit(x, y, 1)
    #print('The slope/intercept is %s, %s' %(m, b))
    plt.plot(x, (m * x + b), color=color)
    plt.ylim(bottom=0)

# function to fit test data for distribution type
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

loglogscatter(logxy(russian_followers_all), 'black', 'Russian All Follows Received by Count, LogLog Plot', 'Users', 'Follower Count')
fitlineplot(russian_followers_all, 'black')
plt.savefig('loglog_all_follows_received_russian .png')
plt.close()
fittest(russian_followers_all, 'Russian All Follows Received')

loglogscatter(logxy(chinese_followers_all), 'red', 'Chinese All Follows Received by Count, LogLog Plot', 'Users', 'Follower Count')
fitlineplot(chinese_followers_all, 'red')
plt.savefig('loglog_all_follows_received_chinese.png')
plt.close()
fittest(chinese_followers_all, 'Chinese All Follows Received')

loglogscatter(logxy(american_followers_all), 'blue', 'American All Follows Received by Count, LogLog Plot', 'Users', 'Follower Count')
fitlineplot(american_followers_all, 'blue')
plt.savefig('loglog_all_follows_received_american.png')
plt.close()
fittest(american_followers_all, 'American All Follows Received')

loglogscatter(logxy(indian_followers_all), 'green', 'Indian All Follows Received by Count, LogLog Plot', 'Users', 'Follower Count')
fitlineplot(indian_followers_all, 'green')
plt.savefig('loglog_all_follows_received_Indian.png')
plt.close()
fittest(indian_followers_all, 'Indian All Follows Received')

loglogscatter(logxy(russian_followers_all), 'black', '', 'Users', 'Follower Count')
fitlineplot(russian_followers_all, 'black')
loglogscatter(logxy(chinese_followers_all), 'red', '', 'Users', 'Follower Count')
fitlineplot(chinese_followers_all, 'red')
loglogscatter(logxy(american_followers_all), 'blue', '', 'Users', 'Follower Count')
fitlineplot(american_followers_all, 'blue')
loglogscatter(logxy(indian_followers_all), 'green', 'Combined All Follows Received by Count, LogLog Plot', 'Users', 'Follower Count')
fitlineplot(indian_followers_all, 'green')
plt.savefig('loglog_all_follows_received_combined.png')
plt.close()

loglogscatter(logxy(russian_watchers_all), 'black', 'Russian All Stars Received by Count, LogLog Plot', 'Users', 'Star Count')
fitlineplot(russian_watchers_all, 'black')
plt.savefig('loglog_all_stars_received_russian.png')
plt.close()
fittest(russian_watchers_all, 'Russian All Stars Received')

loglogscatter(logxy(chinese_watchers_all), 'red', 'Chinese All Stars Received by Count, LogLog Plot', 'Users', 'Star Count')
fitlineplot(chinese_watchers_all, 'red')
plt.savefig('loglog_all_stars_received_chinese.png')
plt.close()
fittest(chinese_watchers_all, 'Chinese All Stars Received')

loglogscatter(logxy(american_watchers_all), 'blue', 'American All Stars Received by Count, LogLog Plot', 'Users', 'Star Count')
fitlineplot(american_watchers_all, 'blue')
plt.savefig('loglog_all_stars_received_american.png')
plt.close()
fittest(american_watchers_all, 'American All Stars Received')

loglogscatter(logxy(indian_watchers_all), 'green', 'Indian All Stars Received by Count, LogLog Plot', 'Users', 'Star Count')
fitlineplot(indian_watchers_all, 'green')
plt.savefig('loglog_all_stars_received_indian.png')
plt.close()
fittest(indian_watchers_all, 'Indian All Stars Received')

loglogscatter(logxy(russian_watchers_all), 'black', '', 'Users', 'Star Count')
fitlineplot(russian_watchers_all, 'black')
loglogscatter(logxy(chinese_watchers_all), 'red', '', 'Users', 'Star Count')
fitlineplot(chinese_watchers_all, 'red')
loglogscatter(logxy(american_watchers_all), 'blue', '', 'Users', 'Star Count')
fitlineplot(american_watchers_all, 'blue')
loglogscatter(logxy(indian_watchers_all), 'green', 'Combined All Stars Received by Count, LogLog Plot', 'Users', 'Star Count')
fitlineplot(indian_watchers_all, 'green')
plt.savefig('loglog_all_stars_received_combined.png')

loglogscatter(logxy(russian_forkers_all), 'black', 'Russian All Forks Received by Count, LogLog Plot', 'Users', 'Fork Count')
fitlineplot(russian_forkers_all, 'black')
plt.savefig('loglog_all_forks_received_russian .png')
plt.close()
fittest(russian_forkers_all, 'Russian All Forks Received')

loglogscatter(logxy(chinese_forkers_all), 'red', 'Chinese All Forks Received by Count, LogLog Plot', 'Users', 'Fork Count')
fitlineplot(chinese_forkers_all, 'red')
plt.savefig('loglog_all_forks_received_chinese.png')
plt.close()
fittest(chinese_forkers_all, 'Chinese All Forks Received')

loglogscatter(logxy(american_forkers_all), 'blue', 'American All Forks Received by Count, LogLog Plot', 'Users', 'Fork Count')
fitlineplot(american_forkers_all, 'blue')
plt.savefig('loglog_all_forks_received_american.png')
plt.close()
fittest(american_forkers_all, 'American All Forks Received')

loglogscatter(logxy(indian_forkers_all), 'green', 'Indian All Forks Received by Count, LogLog Plot', 'Users', 'Fork Count')
fitlineplot(indian_forkers_all, 'green')
plt.savefig('loglog_all_forks_received_indian.png')
plt.close()
fittest(indian_forkers_all, 'Indian All Forks Received')

loglogscatter(logxy(russian_forkers_all), 'black', '', 'Users', 'Fork Count')
fitlineplot(russian_forkers_all, 'black')
loglogscatter(logxy(chinese_forkers_all), 'red', '', 'Users', 'Fork Count')
fitlineplot(chinese_forkers_all, 'red')
loglogscatter(logxy(american_forkers_all), 'blue', '', 'Users', 'Fork Count')
fitlineplot(american_forkers_all, 'blue')
loglogscatter(logxy(indian_forkers_all), 'green', 'Combined All Forks Received by Count, LogLog Plot', 'Users', 'Fork Count')
fitlineplot(indian_forkers_all, 'green')
plt.savefig('loglog_all_forks_received_combined.png')

loglogscatter(logxy(russian_6_star), 'black', 'Russian Jan-Jul 2019 Stars Received by Count, LogLog Plot', 'Users', 'Star Count')
fitlineplot(russian_6_star, 'black')
plt.savefig('loglog_jan-jun_stars_received_russian.png')
plt.close()
fittest(russian_6_star, 'Russian Jan-Jul Stars Received')

loglogscatter(logxy(chinese_6_star), 'red', 'Chinese Jan-Jul 2019 Stars Received by Count, LogLog Plot', 'Users', 'Star Count')
fitlineplot(chinese_6_star, 'red')
plt.savefig('loglog_jan-jun_stars_received_chinese.png')
plt.close()
fittest(chinese_6_star, 'Chinese Jan-Jul Stars Received')

loglogscatter(logxy(american_6_star), 'blue', 'American Jan-Jul 2019 Stars Received by Count, LogLog Plot', 'Users', 'Star Count')
fitlineplot(american_6_star, 'blue')
plt.savefig('loglog_jan-jun_stars_received_american.png')
plt.close()
fittest(american_6_star, 'American Jan-Jul Stars Received')

loglogscatter(logxy(indian_6_star), 'green', 'Indian Jan-Jul 2019 Stars Received by Count, LogLog Plot', 'Users', 'Star Count')
fitlineplot(indian_6_star, 'green')
plt.savefig('loglog_jan-jun_stars_received_indian.png')
plt.close()
fittest(indian_6_star, 'Indian Jan-Jul Stars Received')

loglogscatter(logxy(russian_6_star), 'black', '', 'Users', 'Star Count')
fitlineplot(russian_6_star, 'black')
loglogscatter(logxy(chinese_6_star), 'red', '', 'Users', 'Star Count')
fitlineplot(chinese_6_star, 'red')
loglogscatter(logxy(american_6_star), 'blue', '', 'Users', 'Star Count')
fitlineplot(american_6_star, 'blue')
loglogscatter(logxy(indian_6_star), 'green', 'Combined Jan-Jul 2019 Stars Received by Count, LogLog Plot', 'Users', 'Star Count')
fitlineplot(indian_6_star, 'green')
plt.savefig('loglog_jan-jun_stars_received_combined.png')

loglogscatter(logxy(russian_6_fork), 'black', 'Russian Jan-Jul 2019 Forks Received by Count, LogLog Plot', 'Users', 'Fork Count')
fitlineplot(russian_6_fork, 'black')
plt.savefig('loglog_jan-jun_forks_received_russian .png')
plt.close()
fittest(russian_6_fork, 'Russian Jan-Jul Forks Received')

loglogscatter(logxy(chinese_6_fork), 'red', 'Chinese Jan-Jul 2019 Forks Received by Count, LogLog Plot', 'Users', 'Fork Count')
fitlineplot(chinese_6_fork, 'red')
plt.savefig('loglog_jan-jun_forks_received_chinese.png')
plt.close()
fittest(chinese_6_fork, 'Chinese Jan-Jul Forks Received')

loglogscatter(logxy(american_6_fork), 'blue', 'American Jan-Jul 2019 Forks Received by Count, LogLog Plot', 'Users', 'Fork Count')
fitlineplot(american_6_fork, 'blue')
plt.savefig('loglog_jan-jun_forks_received_american.png')
plt.close()
fittest(american_6_fork, 'American Jan-Jul Forks Received')

loglogscatter(logxy(indian_6_fork), 'green', 'Indian Jan-Jul 2019 Forks Received by Count, LogLog Plot', 'Users', 'Fork Count')
fitlineplot(indian_6_fork, 'green')
plt.savefig('loglog_jan-jun_forks_received_indian.png')
plt.close()
fittest(indian_6_fork, 'Indian Jan-Jul Forks Received')

loglogscatter(logxy(russian_6_fork), 'black', '', 'Users', 'Fork Count')
fitlineplot(russian_6_fork, 'black')
loglogscatter(logxy(chinese_6_fork), 'red', '', 'Users', 'Fork Count')
fitlineplot(chinese_6_fork, 'red')
loglogscatter(logxy(american_6_fork), 'blue', '', 'Users', 'Fork Count')
fitlineplot(american_6_fork, 'blue')
loglogscatter(logxy(indian_6_fork), 'green', 'Combined Jan-Jul 2019 Forks Received by Count, LogLog Plot', 'Users', 'Fork Count')
fitlineplot(indian_6_fork, 'green')
plt.savefig('loglog_jan-jun_forks_received_combined.png')