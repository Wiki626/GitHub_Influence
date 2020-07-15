# Loading the required libraries
import pandas as pd
import matplotlib.pyplot as plt
plt.rcParams['agg.path.chunksize'] = 100000
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

# Plotting the charts and running the tests
loglogscatter(logxy(russian_6), 'black', 'Russian Jan-Jun 2019 Forks Given by Count, LogLog Plot', 'Users', 'Fork Count')
fitlineplot(russian_6, 'black')
plt.savefig('loglog_jan-jun_forks_given_russian.png')
plt.close()
fittest(russian_6, 'Russian Jan-Jun Forks Given')

loglogscatter(logxy(chinese_6), 'red', 'Chinese Jan-Jun 2019 Forks Given by Count, LogLog Plot', 'Users', 'Fork Count')
fitlineplot(chinese_6, 'red')
plt.savefig('loglog_jan-jun_forks_given_chinese.png')
plt.close()
fittest(chinese_6, 'Chinese Jan-Jun Forks Given')

loglogscatter(logxy(american_6), 'blue', 'American Jan-Jun 2019 Forks Given by Count, LogLog Plot', 'Users', 'Fork Count')
fitlineplot(american_6, 'blue')
plt.savefig('loglog_jan-jun_forks_given_american.png')
plt.close()
fittest(american_6, 'American Jan-Jun Forks Given')

loglogscatter(logxy(indian_6), 'green', 'Indian Jan-Jun 2019 Forks Given by Count, LogLog Plot', 'Users', 'Fork Count')
fitlineplot(indian_6, 'green')
plt.savefig('loglog_jan-jun_forks_given_indian.png')
plt.close()
fittest(indian_6, 'Indian Jan-Jun Forks Given')

loglogscatter(logxy(russian_6), 'black', ', LogLog Plot', 'Users', 'Fork Count')
fitlineplot(russian_6, 'black')
loglogscatter(logxy(chinese_6), 'red', '', 'Users', 'Fork Count')
fitlineplot(chinese_6, 'red')
loglogscatter(logxy(american_6), 'blue', '', 'Users', 'Fork Count')
fitlineplot(american_6, 'blue')
loglogscatter(logxy(indian_6), 'green', 'Combined Jan-Jun 2019 Forks Given by Count', 'Users', 'Fork Count')
fitlineplot(indian_6, 'green')
plt.savefig('loglog_jan-jun_forks_given_combined.png')
plt.close()

loglogscatter(logxy(russian_all), 'black', 'Russian All Forks Given by Count, LogLog Plot', 'Users', 'Fork Count')
fitlineplot(russian_all, 'black')
plt.savefig('loglog_all_forks_given_russian.png')
plt.close()
fittest(russian_all, 'Russian All Forks Given')

loglogscatter(logxy(chinese_all), 'red', 'Chinese All Forks Given by Count, LogLog Plot', 'Users', 'Fork Count')
fitlineplot(chinese_all, 'red')
plt.savefig('loglog_all_forks_given_chinese.png')
plt.close()
fittest(chinese_all, 'Chinese All Forks Given')

loglogscatter(logxy(american_all), 'blue', 'American All Forks Given by Count, LogLog Plot', 'Users', 'Fork Count')
fitlineplot(american_all, 'blue')
plt.savefig('loglog_all_forks_given_american.png')
plt.close()
fittest(american_all, 'American All Forks Given')

loglogscatter(logxy(indian_all), 'green', 'Indian All Forks Given by Count, LogLog Plot', 'Users', 'Fork Count')
fitlineplot(indian_all, 'green')
plt.savefig('loglog_all_forks_given_indian.png')
plt.close()
fittest(indian_all, 'Indian All Forks Given')

loglogscatter(logxy(russian_all), 'black', ', LogLog Plot', 'Users', 'Fork Count')
fitlineplot(russian_all, 'black')
loglogscatter(logxy(chinese_all), 'red', '', 'Users', 'Fork Count')
fitlineplot(chinese_all, 'red')
loglogscatter(logxy(american_all), 'blue', '', 'Users', 'Fork Count')
fitlineplot(american_all, 'blue')
loglogscatter(logxy(indian_all), 'green', 'Combined All Forks Given by Count', 'Users', 'Fork Count')
fitlineplot(indian_all, 'green')
plt.savefig('loglog_all_forks_given_combined.png')
plt.close()