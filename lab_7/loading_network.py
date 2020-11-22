from igraph import Graph, VertexSeq

g = Graph.Read_Ncol('../data/facebook_combined.txt', directed=False)

vs = VertexSeq(g)

nodes = Graph.vcount(g)
edg = Graph.ecount(g)
print(nodes, edg)
