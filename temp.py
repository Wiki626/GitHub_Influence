from scipy.stats import lognorm, expon
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np


russian_repo_forks = pd.read_csv("russian_forks_6_months_count.csv", encoding = "ISO-8859-1", engine = 'python')

russian_forks = russian_repo_forks['fork_count'].tolist()
maxfollow = np.max(russian_forks)
russian_array = np.array(russian_forks)


def plot_ccdf(data, ax):
    """
    Plot the complementary cumulative distribution function
    (1-CDF(x)) based on the data on the axes object.

    Note that this way of computing and plotting the ccdf is not
    the best approach for a discrete variable, where many
    observations can have exactly same value!
    """
    # Note that, here we use the convention for presenting an
    # empirical 1-CDF (ccdf) as discussed above
    sorted_vals = np.sort(np.unique(data))
    ccdf = np.zeros(len(sorted_vals))
    n = float(len(data))
    for i, val in enumerate(sorted_vals):
        ccdf[i] = np.sum(data >= val) / n
    ax.plot(sorted_vals, ccdf, "-")
    # faster (approximative) way:
    # sorted_vals = np.sort(data)
    # ccdf = np.linspace(1, 1./len(data), len(data))
    # ax.plot(sorted_vals, ccdf)


def plot_cdf(data, ax):
    """
    Plot CDF(x) on the axes object

    Note that this way of computing and plotting the CDF is not
    the best approach for a discrete variable, where many
    observations can have exactly same value!
    """
    sorted_vals = np.sort(np.unique(data))
    cdf = np.zeros(len(sorted_vals))
    n = float(len(data))
    for i, val in enumerate(sorted_vals):
        cdf[i] = np.sum(data <= val) / n
    ax.plot(sorted_vals, cdf, "-")

    # faster (approximative) way:
    # sorted_vals = np.sort(data)
    # now probs run from "0 to 1"
    # probs = np.linspace(1./len(data),1, len(data))
    # ax.plot(sorted_vals, probs, "-")


fig = plt.figure(figsize=(15, 15))
fig.suptitle('Different broad distribution CDFs in' + \
             'lin-lin, log-log, and lin-log axes')
# loop over different empirical data distributions
# enumerate, enumerates the list elements (gives out i in addition to the data)
# zip([1,2],[a,b]) returns [[1,"a"], [2,"b"]]

dist_data = [russian_array, exps, lognorms]
dist_names = ["power law", "exponential", "lognormal"]
for i, (rands, name) in enumerate(zip(dist_data, dist_names)):
    # linear-linear scale
    ax = fig.add_subplot(4, 3, i + 1)
    plot_cdf(rands, ax)
    ax.grid()
    ax.text(0.6, 0.9, "lin-lin, CDF: " + name,
            transform=ax.transAxes)

    # log-log scale
    ax = fig.add_subplot(4, 3, i + 4)
    plot_cdf(rands, ax)
    ax.set_xscale('log')
    ax.set_yscale('log')
    ax.grid()
    ax.text(0.6, 0.9, "log-log, CDF: " + name,
            transform=ax.transAxes)

    # lin-lin 1-CDF
    ax = fig.add_subplot(4, 3, i + 7)
    plot_ccdf(rands, ax)
    ax.text(0.6, 0.9, "lin-lin, 1-CDF: " + name,
            transform=ax.transAxes)
    ax.grid()

    # log-log 1-CDF
    ax = fig.add_subplot(4, 3, i + 10)
    plot_ccdf(rands, ax)
    ax.text(0.6, 0.9, "log-log: 1-CDF " + name,
            transform=ax.transAxes)
    ax.set_yscale('log')
    ax.set_xscale('log')
    ax.grid()
