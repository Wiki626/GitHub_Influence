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

fit = powerlaw.Fit(american_watchers, discrete=True)
R2, p2 = fit.distribution_compare('power_law', 'truncated_power_law', normalized_ratio=True)
print(R2, p2)