install.packages("multinet")
library(multinet)
library(igraph)

# Slajd 5
net <- ml_aucs()
net
plot(net)
# degrees of all actors, considering edges on all layers
degree_ml(net)
# degree of actors U54 and U3, only considering layers work and coauthor
degree_ml(net,c("U54","U3"),c("work","coauthor"),"in")
# an indication of whether U54 and U3 are selectively active only on some layers
degree_deviation_ml(net,c("U54","U3"))
# co-workers of U3
neighborhood_ml(net,"U3","work")
# co-workers of U3 who are not connected to U3 on other layers
xneighborhood_ml(net,"U3","work")
# percentage of neighbors of U3 who are also co-workers
relevance_ml(net,"U3","work")
# redundancy between work and lunch
connective_redundancy_ml(net,"U3",c("work","lunch"))
# percentage of neighbors of U3 who would no longer
# be neighbors by removing this layer
xrelevance_ml(net,"U3","work")

# Slajd 6
net <- ml_aucs()
attributes_ml(net)
# actor attributes, of string type (default)
add_attributes_ml(net,c("name","surname"))
# attributes for vertices on the facebook layer
add_attributes_ml(net,"username",type="string",target="vertex",layer="facebook")
# attributes for edges on the work layer
add_attributes_ml(net,"strength",type="numeric",target="edge",layer="work")
# listing the attributes
attributes_ml(net)
# setting some values for the newly created attributes
set_values_ml(net,"name",actors=c("U54","U139"),values=c("John","Johanna"))
e <- data.frame(
  c("U139","U139"),
  c("work","work"),
  c("U71","U97"),
  c("work","work"))
set_values_ml(net,"strength",edges=e,values=.47)

# Slajd 7
# getting the values back
get_values_ml(net,"name",actors=c("U139"))
get_values_ml(net,"strength",edges=e)
# setting attributes based on network properties: create a "degree"
# attribute and set its value to the degree of each actor
actors_ml(net) -> a
layers_ml(net) -> l
degree_ml(net,actors=a,layers=l,mode="all") -> d
add_attributes_ml(net,target="actor",type="numeric",attributes="degree")
set_values_ml(net,attribute="degree",actors=a,values=d)
get_values_ml(net,attribute="degree",actors="U54")
# select actors based on attribute values (e.g., with degree greater than 40)
get_values_ml(net,attribute="degree",actors=a) -> degrees
a[degrees>40]
# list all the attributes
attributes_ml(net)

# Slajd 8
# Algorytmy detekcji spolecznosci
net <- ml_aucs()
abacus_ml(net)
clique_percolation_ml(net)
glouvain_ml(net)
infomap_ml(net)

# Slajd 10
# Konwersja do sieci single layer
net <- ml_aucs()
# using the default merge.actors=TRUE we create a multigraph,
# where each actor corresponds to a vertex in the result
multigraph <- as.igraph(net)
# this is a simple graph corresponding to the facebook layer
facebook1 <- as.igraph(net, "facebook")
# this includes also the actors without a facebook account
facebook2 <- as.igraph(net, "facebook", all.actors=TRUE)
# two layers are converted to an igraph object, where two
# vertices are used for each actor: one corresponding to the
# vertex on facebook, one to the vertex on lunch
f_l_net <- as.igraph(net, c("facebook","lunch"),merge.actors=FALSE)

# Odleglosci w sieciach multilayer
distance_ml(net, from='U54', to=character(0), method="multiplex")
net <- ml_aucs()
distance_ml(net,"U54","U3")

# Slajd 11
file <- tempfile("aucs.mpx") # zapis do R /….. / multinet/extdata
net <- ml_aucs()
write_ml(net,file)
net1 <- read_ml(file,"AUCS")
net1

# Slajd 12
# Tworzenie sieci wielowarstwowej
net <- ml_empty()
# Adding some layers
add_layers_ml(net,"l1")
add_layers_ml(net,c("l2","l3"),c(TRUE,FALSE))
layers_ml(net)
# Adding some vertices (actor A3 is not present in layer l3: no corresponding vertex there)
vertices <- data.frame(
  c("A1","A2","A3","A1","A2","A3"),
  c("l1","l1","l1","l2","l2","l2"))
add_vertices_ml(net,vertices)
vertices <- data.frame(
  c("A1","A2"),
  c("l3","l3"))
add_vertices_ml(net,vertices)
vertices_ml(net)

# Slajd 13
# Verifying that the actors have been added correctly
num_actors_ml(net)
actors_ml(net)
# We create a data frame specifying two edges:
# A2,l2 -- A3,l1
# A2,l2 -- A3,l2
edges <- data.frame(
  c("A2","A2"),
  c("l2","l2"),
  c("A3","A3"),
  c("l1","l2"))
add_edges_ml(net,edges)
edges_ml(net)
# The following deletes layer 1, and also deletes
# all vertices from "l1" and the edge with an end-point in "l1"
delete_layers_ml(net,"l1")
# The following also deletes the vertices associated to
# "A1" in layers "l2" and "l3"
delete_actors_ml(net,"A1")
# deleting vertex A2,l3 and edge A2,l2 -- A3,l2
delete_vertices_ml(net,data.frame("A2","l3"))
edges <- data.frame("A2","l2","A3","l2")
delete_edges_ml(net,edges)
net

# Slajd 14
# Tworzenie sieci ewoluujcej
# we generate a network with two layers, one growing according
# to the Preferential Attachment model and one growing by selecting
# new edges uniformly at random.
models <- c(evolution_pa_ml(3,1), evolution_er_ml(50))
# all the probability vectors must have the same number of
# fields, one for each layer: two in this example
# by defining pr.internal and pr.external, we are also implicitely defining
# pr.no.action (1 minus the other probabilities, for each field/layer).
pr_external <- c(.5,0)
pr_internal <- c(.5,.5)
# each layer will import edges from the other if needed
# (not the second layer in this example: it has 0 probability of external events)
dependency <- matrix(c(0,1,1,0),2,2)
# 100 steps of network growing, adding actors from a pool of 100
grow_ml(100, 100, models, pr_internal, pr_external, dependency)

# Slajd 15
# Porownywanie warstw
layer_comparison_ml(net,method="kulczynski2.actors")
layer_comparison_ml(net,method="kulczynski2.edges")
layer_comparison_ml(net,method="kulczynski2.triangles")
layer_comparison_ml(net,method="hamann.actors")
layer_comparison_ml(net,method="hamann.edges")
layer_comparison_ml(net,method="hamann.triangles")
# comparison of degree distributions (divergences)
layer_comparison_ml(net,method="dissimilarity.degree")
layer_comparison_ml(net,method="KL.degree")
layer_comparison_ml(net,method="jeffrey.degree")
# statistical degree correlation
layer_comparison_ml(net,method="pearson.degree")
layer_comparison_ml(net,method="rho.degree")

# Slajd 19
# Wizualizacja
net <- ml_florentine()
l <- layout_multiforce_ml(net, w_in = 1, w_inter = 1, gravity = 0, iterations = 100)
plot(net, layout=l)
net <- ml_florentine()
layout_multiforce_ml(net)
l <- layout_circular_ml(net)
plot(net,layout=l)
net <- ml_aucs()
layout_multiforce_ml(net)
l <- layout_circular_ml(net)
plot(net,layout=l)
net <- ml_florentine()
plot(net)
c <- clique_percolation_ml(net)
plot(net, vertex.labels.cex=.5, com=c)
net <- ml_aucs()
plot(net, vertex.labels=NA)
title("AUCS network")
values2graphics(c("a", "b", "b", "c"))

# Sieci przykladowe
ml_empty(name="unnamed")
ml_aucs()
ml_bankwiring()
ml_florentine()
ml_monastery()
ml_tailorshop()
ml_toy()