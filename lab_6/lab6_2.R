library(multinet)
library(igraph)

# Siec 1 takie same rewiring probabilities
ws1_1 <- sample_smallworld(dim=1, size=20, nei=1, p=0.1)
ws1_1 <- set_vertex_attr(ws1_1, "name", value = LETTERS[1:20])
ws1_2 <- sample_smallworld(dim=1, size=20, nei=1, p=0.1)
ws1_2 <- set_vertex_attr(ws1_2, "name", value = LETTERS[1:20])

# Siec 2 różne rewiring probabilities
ws2_1 <- sample_smallworld(dim=1, size=20, nei=1, p=0.1)
ws2_1 <- set_vertex_attr(ws2_1, "name", value = LETTERS[1:20])
ws2_2 <- sample_smallworld(dim=1, size=20, nei=1, p=0.8)
ws2_2 <- set_vertex_attr(ws2_2, "name", value = LETTERS[1:20])

# Tworzenie sieci
createML <- function(ws1, ws2) {
  net <- ml_empty()
  add_igraph_layer_ml(net, ws1, 'l1')
  add_igraph_layer_ml(net, ws1, 'l2')
  return(net)
}

# Wprowadzanie 5 polaczen miedzywarstwami
addInterLayersEdges <- function(net, num) {
  edges <- data.frame(
    c(LETTERS[sample.int(10, num, replace=TRUE)]),
    c(rep("l1", num)),
    c(LETTERS[sample.int(10, num, replace=TRUE)]),
    c(rep("l2", num)))
  edges
  add_edges_ml(net, edges)
}

#
# 5 Polaczen
#
net1 <- createML(ws1_1, ws1_2)
addInterLayersEdges(net1, 5)
plot(net1)

net2 <- createML(ws2_1, ws2_2)
addInterLayersEdges(net2, 5)
plot(net2)

# Wyznaczenie i porownanie dwoch podstawowych miar sieciowych w ujeciu wielowarstwowym
degree_ml(net1)
degree_ml(net2)

# Podobienstwo warstw
layer_comparison_ml(net1,method="kulczynski2.actors")
layer_comparison_ml(net1,method="kulczynski2.edges")
layer_comparison_ml(net1,method="kulczynski2.triangles")

layer_comparison_ml(net1,method="dissimilarity.degree")
layer_comparison_ml(net1,method="KL.degree")
layer_comparison_ml(net1,method="jeffrey.degree")

# Porownanie spolecznosci
comm <- clique_percolation_ml(net1)
length(comm) 
modularity_ml(net1, comm, gamma=1, omega=1)

comm <- clique_percolation_ml(net2)
length(comm)
modularity_ml(net2, comm, gamma=1, omega=1)


#
# 10 polaczen
#
# 5 Polaczen
net1 <- createML(ws1_1, ws1_2)
addInterLayersEdges(net1, 10)
plot(net1)

net2 <- createML(ws2_1, ws2_2)
addInterLayersEdges(net2, 10)
plot(net2)

# Wyznaczenie i porownanie dwoch podstawowych miar sieciowych w ujeciu wielowarstwowym
degree_ml(net1)
degree_ml(net2)

# Podobienstwo warstw
layer_comparison_ml(net1,method="kulczynski2.actors")
layer_comparison_ml(net1,method="kulczynski2.edges")
layer_comparison_ml(net1,method="kulczynski2.triangles")

layer_comparison_ml(net1,method="dissimilarity.degree")
layer_comparison_ml(net1,method="KL.degree")
layer_comparison_ml(net1,method="jeffrey.degree")

# Porownanie spolecznosci
comm <- clique_percolation_ml(net1)
length(comm) 
modularity_ml(net1, comm, gamma=1, omega=1)

comm <- clique_percolation_ml(net2)
length(comm)
modularity_ml(net2, comm, gamma=1, omega=1)

#
# 20 polaczen
#
net1 <- createML(ws1_1, ws1_2)
addInterLayersEdges(net1, 20)
plot(net1)

net2 <- createML(ws2_1, ws2_2)
addInterLayersEdges(net2, 20)
plot(net2)

# Wyznaczenie i porownanie dwoch podstawowych miar sieciowych w ujeciu wielowarstwowym
degree_ml(net1)
degree_ml(net2)

# Podobienstwo warstw
layer_comparison_ml(net1,method="kulczynski2.actors")
layer_comparison_ml(net1,method="kulczynski2.edges")
layer_comparison_ml(net1,method="kulczynski2.triangles")

layer_comparison_ml(net1,method="dissimilarity.degree")
layer_comparison_ml(net1,method="KL.degree")
layer_comparison_ml(net1,method="jeffrey.degree")

# Porownanie spolecznosci
comm <- clique_percolation_ml(net1)
length(comm) 
modularity_ml(net1, comm, gamma=1, omega=1)

comm <- clique_percolation_ml(net2)
length(comm)
modularity_ml(net2, comm, gamma=1, omega=1)