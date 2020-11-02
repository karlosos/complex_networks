setwd("C:/Dev/complex_networks/lab_3/")

# Detekcja spolecznosci
library("igraph")
ba <- sample_pa(n=50, power=1, m=1, directed=F)
plot(ba, vertex.size=6, vertex.label=NA)

communities <- cluster_louvain(graph, weights = NULL)
# info zwrotne https://igraph.org/r/doc/communities.html
length(communities) # liczba społeczności
sizes(communities) # rozmiary społeczności
members <- membership(communities) #w tablicy dla każdego węzła przypisane jest community id
modularity(communities)
crossing(communities, graph) # łączność pomiędzy społecznościami
