setwd("C:/Dev/complex_networks/lab_3/")
install.packages("dplyr")
library(dplyr)
library(igraph)

## Wizualizacja
df <- read.table("data/reachability.txt", sep = " ", header = FALSE)
graph <- graph.data.frame(df)
#plot(graph)

# Srednica w grafie nieskierowanym
d = diameter(graph, directed = FALSE, weights=NA)
# Srednia najkrotsza sciezka dla grafu nieskierowanego
average.path.length(graph, directed = FALSE)
# Srednica sieci w grafie skierowanym
diameter(graph, directed=T, weight=NA)
get.diameter(graph, directed = TRUE)
# Srednia najkrotsza sciezka dla grafu skierowanego
average.path.length(graph, directed = TRUE)

# Rozklad degree
hist(degree(graph))

# Rozklad closeness
hist(closeness(graph))

# Rozklad betweenness
hist(betweenness(graph))

dg = sort(degree(graph), decreasing = TRUE)[1:5]
shortest.paths(graph, names(dg), names(dg), mode="out")

cl = sort(closeness(graph), decreasing = TRUE)[1:5]
shortest.paths(graph, names(cl), names(cl), mode="out")

bt = sort(betweenness(graph), decreasing = TRUE)[1:5]
shortest.paths(graph, names(bt), names(bt), mode="out")

intersect(intersect(names(dg),names(cl)),names(bt))
