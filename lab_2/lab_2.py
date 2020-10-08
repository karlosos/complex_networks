from igraph import *

import timeit

start = timeit.default_timer()

net = open("../data/facebook_combined.txt", "r")
g = Graph.Read_Edgelist(net, directed=False)

layout = g.layout("fr")

visual_style = {}
visual_style["edge_width"] = 1
visual_style["layout"] = layout

plot(g, **visual_style)

stop = timeit.default_timer()

print('Time: ', stop - start)
