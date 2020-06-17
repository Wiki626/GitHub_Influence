import networkx as nx
import pandas as pd
import matplotlib.pyplot as plt

def merge(list1, list2):
    merged_list = [(list1[i], list2[i]) for i in range(0, len(list1))]
    return merged_list

russian_followers = pd.read_csv("russian followers.csv", encoding = "ISO-8859-1", engine = 'python')

follower_logins = russian_followers['follower_login'].tolist()
user_logins = russian_followers['user_login'].tolist()

nodes = follower_logins + user_logins
nodes = set(nodes)

edges = merge(follower_logins, user_logins)

#instantiate graph
russian_follower_network = nx.Graph()

#G.add_nodes_from(nodes)
russian_follower_network.add_edges_from(edges)

print(len(russian_follower_network.nodes()))
print(len(russian_follower_network.edges()))

nx.spring_layout(russian_follower_network)