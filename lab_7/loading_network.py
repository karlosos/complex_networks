from igraph import Graph, VertexSeq, plot
from igraph import *
import matplotlib.pyplot as plt

g = Graph.Read_Ncol('../data/facebook_combined.txt', directed=False)

vs = VertexSeq(g)

nodes = Graph.vcount(g)
edg = Graph.ecount(g)
print(nodes, edg)

g = Graph.Watts_Strogatz(dim=1, size=10, nei=10, p=0.3)
plot(g)
plt.show()