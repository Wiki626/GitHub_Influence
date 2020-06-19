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
russian_repo_watchers = pd.read_csv("russian_watchers_6_months_count.csv", encoding = "ISO-8859-1", engine = 'python')
chinese_repo_watchers = pd.read_csv("chinese_watchers_6_months_count.csv", encoding = "ISO-8859-1", engine = 'python')
unitedstates_repo_watchers = pd.read_csv("unitedstates_watchers_6_months_count.csv", encoding = "ISO-8859-1", engine = 'python')
indian_repo_watchers = pd.read_csv("indian_watchers_6_months_count.csv", encoding = "ISO-8859-1", engine = 'python')

# Putting the data into list form
chinese_watchers = chinese_repo_watchers['star_count'].tolist()
american_watchers = unitedstates_repo_watchers['star_count'].tolist()
indian_watchers = indian_repo_watchers['star_count'].tolist()
russian_watchers = russian_repo_watchers['star_count'].tolist()

loglogscatter(logxy(russian_watchers), 'black', 'Russian Repository Watchers Jan-Jul 2019 by Count, LogLog Plot', 'Users', 'Star Count')
fitlineplot(russian_watchers, 'black')
plt.savefig('repo watchers jan-jul loglog russian .png')
plt.close()
fittest(russian_watchers, 'Russian Watchers')

loglogscatter(logxy(chinese_watchers), 'red', 'Chinese Repository Watchers Jan-Jul 2019 by Count, LogLog Plot', 'Users', 'Star Count')
fitlineplot(chinese_watchers, 'red')
plt.savefig('repo watchers jan-jul loglog chinese.png')
plt.close()
fittest(chinese_watchers, 'Chinese Watchers')

loglogscatter(logxy(american_watchers), 'blue', 'American Repository Watchers Jan-Jul 2019 by Count., LogLog Plot', 'Users', 'Star Count')
fitlineplot(american_watchers, 'blue')
plt.savefig('repo watchers jan-jul loglog american.png')
plt.close()
fittest(american_watchers, 'American Watchers')

loglogscatter(logxy(indian_watchers), 'green', 'Indian Repository Watchers Jan-Jul 2019 by Count, LogLog Plot', 'Users', 'Star Count')
fitlineplot(indian_watchers, 'green')
plt.savefig('repo watchers jan-jul loglog indian.png')
plt.close()
fittest(indian_watchers, 'Indian Watchers')

loglogscatter(logxy(russian_watchers), 'black', 'Repository Watchers Jan-Jul 2019 by Count, LogLog Plot', 'Users', 'Star Count')
fitlineplot(russian_watchers, 'black')
loglogscatter(logxy(chinese_watchers), 'red', 'Repository Watchers Jan-Jul 2019 by Count, LogLog Plot', 'Users', 'Star Count')
fitlineplot(chinese_watchers, 'red')
loglogscatter(logxy(american_watchers), 'blue', 'Repository Watchers Jan-Jul 2019 by Count, LogLog Plot', 'Users', 'Star Count')
fitlineplot(american_watchers, 'blue')
loglogscatter(logxy(indian_watchers), 'green', 'Repository Watchers Jan-Jul 2019 by Count, LogLog Plot', 'Users', 'Star Count')
fitlineplot(indian_watchers, 'green')
plt.savefig('repo watchers jan-jul loglog combined.png')
plt.close()


