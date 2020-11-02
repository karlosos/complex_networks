setwd("C:/Dev/complex_networks/lab_3/")

# Detekcja spolecznosci
library("igraph")
graph <- sample_gnm(n=30, m=30)
plot(graph, vertex.label=NA, vertex.size=18, vertex.label.cex = 1.3)

communities <- cluster_louvain(graph, weights = NULL)
# info zwrotne https://igraph.org/r/doc/communities.html
length(communities) # liczba społeczności
sizes(communities) # rozmiary społeczności
members <- membership(communities) #w tablicy dla każdego węzła przypisane jest community id
modularity(communities)
crossing(communities, graph) # łączność pomiędzy społecznościami 

# Wizualizacja spolecznosci
compare(comm1, comm2, method = c("vi", "nmi", "split.join", "rand",
                                 "adjusted.rand")) # porównanie 
plot(communities, graph)

# Dendogram i podejscie hierarchiczne
karate <- make_graph("Zachary")
fc <- cluster_fast_greedy(karate)
plot_dendrogram(fc)
plot(fc, karate)

# Inne algorytmy
# Random walk
fc <- cluster_walktrap(graph, weights = E(graph)$weight, steps = 2, merges = TRUE, modularity = TRUE, membership =
                   TRUE)
plot_dendrogram(fc)
plot(fc, karate)

# Eigenvector
fc <- cluster_leading_eigen(graph, steps = -1, weights = NULL, start = NULL, options = arpack_defaults, callback = NULL,
                      extra = NULL, env = parent.frame())
plot_dendrogram(fc)
plot(fc, karate)

# Betweenness krawędzi
fc <- cluster_edge_betweenness(graph, weights = E(graph)$weight, directed = TRUE, edge.betweenness = TRUE, merges
                         = TRUE, bridges = TRUE, modularity = TRUE, membership = TRUE)
plot_dendrogram(fc)
plot(fc, karate)

# Etykiety & voting
fc <- cluster_label_prop(graph, weights = NULL, initial = NULL, fixed = NULL)
plot(fc, karate)

# Greedy
fc <- cluster_fast_greedy(graph)
plot(fc, karate)