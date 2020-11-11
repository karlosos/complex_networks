setwd("C:/Dev/complex_networks/lab_5/")
library(igraph)
library(sna)
library(tsna)
library(ndtv)

neis = c(1, 2, 1, 3, 0, 1, 4, 3, 2, 1)
networks = list()
for (i in 1:length(neis)) {
  net <- sample_smallworld(dim=1, size=10, nei=neis[i], p=0.1)
  plot(net, vertex.size=6, vertex.label=NA, layout=layout_in_circle)
  networks <- list.append(networks, network(get.adjacency(net)))
  path <- paste("./generated_network/sw", i, ".txt", sep ="") 
  write_graph(net, path, "edgelist")
}

# W kazdej iteracji
for (i in c(0:9)) {
  print(i)
  net <- network.collapse(dnet, at=i)
  path <- paste("./output/small_world", i, ".pdf", sep ="") 
  pdf(file=path)
  plot(net)
  dev.off()
}

# network dynamics
dnet<-networkDynamic(network.list=networks)
tDegree(dnet)


nlist<-replicate(4,list(network(matrix(rbinom(16,5,0.1),ncol=4,nrow=4))))
dnet<-networkDynamic(network.list= nlist)
tDegree(dnet)


# Animacja
compute.animation(
  dnet,
  animation.mode = "kamadakawai",
  slice.par = list(
    start = 1,
    end = 10,
    interval = 1,
    aggregate.dur = 1,
    rule = "any"
  )
)
render.d3movie(
  dnet,
  displaylabels = FALSE
)

# Wyznaczyć temporal degree dla 5 węzłów w różnych momentach czasu 
tDegree(dnet)

#Dla wybranych węzłów z 1,5 i 10 dnia wyznaczyć ścieżki fwd, fwd & bkwd, bakwd i je zwizualizować
FwdPath <- tPath(dnet, v = 1,direction = "fwd", start=1)
plotPaths(dnet,FwdPath,displaylabels = FALSE,vertex.col = "white")
BkwdPath <- tPath(dnet,v = 1,direction = "bkwd",type ='latest.depart',start=1)
plotPaths(dnet,BkwdPath,path.col = rgb(0, 97, 255, max=255, alpha=166),displaylabels = FALSE,edge.label.col = rgb(0,0,0,0),vertex.col = "white")

FwdPath <- tPath(dnet, v = 1,direction = "fwd", start=5)
plotPaths(dnet,FwdPath,displaylabels = FALSE,vertex.col = "white")
BkwdPath <- tPath(dnet,v = 1,direction = "bkwd",type ='latest.depart',start=5)
plotPaths(dnet,BkwdPath,path.col = rgb(0, 97, 255, max=255, alpha=166),displaylabels = FALSE,edge.label.col = rgb(0,0,0,0),vertex.col = "white")


FwdPath <- tPath(dnet, v = 1,direction = "fwd", start=10)
plotPaths(dnet,FwdPath,displaylabels = FALSE,vertex.col = "white")
BkwdPath <- tPath(dnet,v = 1,direction = "bkwd",type ='latest.depart',start=10)
plotPaths(dnet,BkwdPath,path.col = rgb(0, 97, 255, max=255, alpha=166),displaylabels = FALSE,edge.label.col = rgb(0,0,0,0),vertex.col = "white")

# Betweenness
dynamicBetweenness <- tSnaStats(
  dnet,
  snafun = "centralization",
  start = 1,
  end = 10,
  time.interval = 1,
  aggregate.dur = 1,
  FUN = "betweenness"
)
plot(dynamicBetweenness)

for (i in c(0:9)) {
  path <- paste("./output/betweenness_", i, ".pdf", sep ="") 
  pdf(file=path)
  barplot(betweenness(network.collapse(dnet, at=i)))
  dev.off()
}