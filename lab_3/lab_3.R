# Zapoznanie sie z przykadami na slajdach 3-13
# Plik do ćwiczeń lab3.zip

# - wyznaczanie srednicy sieci, wazonych, skierowanych
# - etykiety i identyfikatory wezlow
# - wyznaczanie sciezek dla grafow nieskierowanych, skierowanych i wazonych
# - closeness centrality, wazone, skierowane
# - betweeness centrality, wazone, skierowane
# - eigenvector, wazone, skierowane
# - transitivity (clustering coefficient), wazone, skierowane

## S3 Srednica i nakrotsze sciezki
library("igraph")
graph <- sample_gnm(n=10, m=10)
plot(graph, vertex.label=NA, vertex.size=18, vertex.label.cex=1.3)

# Srednica sieci
d = diameter(graph, directed=F, weights=NA)

# Najkrotsze sciezki
shortest.paths(graph)
shortest.paths(graph, 1, 10)
average.path.length(graph)
path.length.hist(graph)

# res - histogram
# unconnected - liczba par, dla których pierwszy wezel nie jest dostepny z drugiego

tab <- as.table(path.length.hist(graph)$res)
names(tab) <- 1:length(tab)
barplot(tab)


## S4 Sciezki w grafach skierowanych
graph <- sample_gnm(n=10, m=10, directed = TRUE)
plot(graph, vertex.size=18, vertex.label.cex=1.3)
# Srednica sieci
diameter(graph, directed=T, weight=NA)
get.diameter(graph, directed = TRUE)

# Najkrotsze sciezki
shortest.paths(graph, mode="out")
shortest.paths(graph, mode="in")
shortest.paths(graph, mode="all")
shortest.paths(graph, 8, 10, mode="out") # zamiast FROM TO numery wewzlow

## S5 Odczyt grafów skierowanych i wag krawdzi
setwd("C:/Dev/complex_networks/lab_3/")
graph <- read.graph("data/directed.txt", format="edgelist")

# Graf skierowany - konwersja z data frame df
df <- read.table("data/directed.txt", sep=" ", header = FALSE)
df
graph <- graph.data.frame(df)
shortest.paths(graph, mode="out")
shortest.paths(graph, mode="in")
shortest.paths(graph, mode="all")
shortest.paths(graph, 1, 7, mode="out") # zamiast FROM TO numery wewzlow

## S6 Srednica z uwzglednieniem wag
df <- read.table("data/weighted.txt", sep = " ", header = TRUE)
graph <- graph.data.frame(df, directed = FALSE)
plot(graph, edge.label = paste(df$weight1, df$weight2, sep=" "))

edge.attributes(graph)
E(graph)$weight1 <- df$weight1
E(graph)$weight2 <- df$weight2

graph <- set.edge.attribute(graph, "weight1", value=df$weight1)
graph <- set.edge.attribute(graph, "weight2", value=df$weight2)

# Wazona srednica
diameter(graph, directed = TRUE, unconnected = TRUE, weights = df$weight1)
get_diameter(graph, weights = df$weight1)
diameter(graph, directed = TRUE, unconnected = TRUE, weights = df$weight2)
get_diameter(graph, weights = df$weight2)

## S7 Grafy nazwane i nienazwane i odwolania do wezlow
# Identyfikatory wezlow graf nienazwany
graph <- sample_gnm(n=10, m=10)
V(graph)
V(graph)$name 
plot(graph)
is_named(graph)

# Identyfikatory wezlow graf nazwany
graph <- sample_gnm(n=10, m=10)
set_vertex_attr("name", value = letter[1:10])
V(graph)
V(graph)$name
plot(graph, vertex.label=V(graph)$name)
as.numeric(V(graph))

# Identyfikatory wczytywane z pliku
df <- read.table("weighted.txt", sep = " ", header = TRUE)
graph <- graph.data.frame(df, directed = FALSE)
V(graph) # 9 1 2 3 4 czyli wezel z etykieta 9 ma id 1
V(graph)$name
as.numeric(V(graph))
plot(graph, vertex.label=V(graph)$name)
plot(graph, vertex.label=as.numeric(V(graph)))
neighbors(graph, 1) # sasiedzi 9
neighbors(graph, "9")
neighbors(graph, 9)

## S8 Alfanumeryczne nazwy wezlow w pliku
df <- read.table("data/weighted_abc.txt", sep = " ", header = TRUE)
graph <- graph.data.frame(df, directed = TRUE)
plot(graph, vertex.label=V(graph)$name, edge.label = paste(df$weight1, df$weight2, sep=" "))
V(graph)

shortest.paths(graph, 1, 2, weights=df$weight1, mode="out")
shortest.paths(graph, "a", "b", weights=df$weight1, mode="out")
plot(graph, vertex.label=V(graph)$name)
plot(graph, vertex.label=as.numeric(V(graph)))

## S9 Sciezki wazone i odwolania do wezlow
df <- read.table("data/weighted.txt", sep = " ", header = TRUE)
graph <- graph.data.frame(df, directed = TRUE)
plot(graph, edge.label = paste(df$weight1, df$weight2, sep=" "))
shortest.paths(graph, 1, weights=df$weight1, mode="out") # wynik wezla id=1 "9"
shortest.paths(graph, "9", weights=df$weight1, mode= "out") #wynik dla name="9"
shortest.paths(graph, 1, 7, weights=df$weight1, mode= "out") #wynik dla "9" i "6"
shortest.paths(graph, "1", "7", weights=df$weight1, mode= "out") #wynik dla "1" "7"
# in vs out weight1 np. koszt
shortest.paths(graph, "2", "3", weights=df$weight1, mode= "in")
shortest.paths(graph, "2", "3", weights=df$weight1, mode= "out")
# in vs out weight2 np. czas
shortest.paths(graph, "9", "5", weights=df$weight2, mode= "in")
shortest.paths(graph, "9", "5", weights=df$weight2, mode= "out")

## S10 Closeness dla grafow skierowanych i wazonych
graph <- sample_gnm(n=10, m=20)
plot(graph)
closeness(graph)
closeness(graph,vids=c("1","2"))

df <- read.table("data/closeness2.txt", sep = " ", header = TRUE )
graph <- graph.data.frame(df, directed = FALSE )
plot(graph, vertex.label=V(graph)$name)
closeness(graph)
closeness(graph,vids=c("1", "9"))

## S11 Closeness dla grafow skierowanych i wazonych
df <- read.table("data/closeness.txt", sep = " ", header = TRUE)
graph <- graph.data.frame(df, directed = FALSE )
plot(graph,edge.label = paste(df$weight1, df$weight2,sep=" "))
closeness(graph, weights = df$weight1)

df <- read.table("closeness.txt", sep = " ", header = TRUE )
graph <- graph.data.frame(df, directed = TRUE )
plot(graph,edge.label = paste(df$weight1, df$weight2,sep=" "))
closeness(graph)

## S12 Betweenness dla grafow skierowanych i wazonych
graph <- sample_gnm(n=10, m=20)
plot(graph)
betweenness(graph)

df <- read.table("data/closeness2.txt", sep = " ", header = TRUE )
graph <- graph.data.frame(df, directed = FALSE )
plot(graph, vertex.label=V(graph)$name)
betweenness(graph)
b <- betweenness(graph)

betweenness(graph, v = V(graph), directed = TRUE, weights = NULL,
            nobigint = TRUE, normalized = FALSE)

## S13 Eigenvector i clustering coefficient
df <- read.table("data/directed.txt", sep = " ", header = TRUE )
graph <- graph.data.frame(df, directed = FALSE )
plot(graph, vertex.label=V(graph)$name)
eigen_centrality(graph)
transitivity(graph) # clustering coefficient
page_rank(graph)

# 2. Do wyboru slajd 14 (analiza polaczen lotniczych), 
# slajd 15 (analiza korespondencji email) lub slajd 16 inna podobna siec