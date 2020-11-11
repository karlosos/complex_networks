setwd("C:/Dev/complex_networks/lab_5/")
library(igraph)

# Zadanie 1 Zapoznanie sie z podstawowymi funkcjami do przetwarzania sieci temporalnych
# - tworzenie sieci temporalnej
# - temporalny stopien wierzchoka
# - temporalne sciezki
# - wizualizacja sciezek na kompletnym grafie
# - sciezki fwd i bkw

# Sieci temporalne
install.packages("sna")
install.packages("tsna")
install.packages("ndtv")
library(sna)
library(tsna)
library(ndtv)

# Slajd 5
?cls33_10_16_96
data(McFarland_cls33_10_16_96)
tDegree(cls33_10_16_96)
mean(tDegree(cls33_10_16_96),na.rm=TRUE)

# Tempralne sciezki
?moodyContactSim
data(moodyContactSim)
v10path<-tPath(moodyContactSim,v=10,start=0)
pdf(file="./output/moody_1.pdf")
plot(v10path) # tylko wybrana ścieżka
dev.off()
pdf(file="./output/moody_2.pdf")
plotPaths(moodyContactSim,v10path) # ścieżka nałożona na graf
dev.off()
v1path<-tPath(moodyContactSim,v=1,start=0)
pdf(file="./output/moody_3.pdf")
plotPaths(moodyContactSim,list(v10path,v1path)) # nałożenie dwóch ścieżek
dev.off()

# Slajd 6 networkDynamic object
nlist<-replicate(4,list(network(matrix(rbinom(16,5,0.1),ncol=4,nrow=4))))
par(mfcol=c(2,2))
plot(nlist[[1]],displaylabels=TRUE,main='t0')
plot(nlist[[2]],displaylabels=TRUE,main='t1')
plot(nlist[[3]],displaylabels=TRUE,main='t2')
plot(nlist[[4]],displaylabels=TRUE,main='t3')

dnet<-networkDynamic(network.list= nlist)
tDegree(dnet)
par(mfcol=c(1,1))

# https://github.com/cran/tsna/blob/master/inst/doc/tsna_vignette.R
# https://www.rdocumentation.org/packages/networkDynamic/versions/0.10.1/topics/networkDynamic

# Slajd 7
# Podstawowe funkcje
setwd("C:/Dev/complex_networks/lab_5/")
StaticEdges <- read.csv("StaticEdgelist.csv")

# Wizalizacja static
thenetwork <- network(
  StaticEdges,
  directed = FALSE,
  bipartite = FALSE
)
plot(thenetwork)

# Dynamiczne wezly i krawedzie
DynamicNodes <- read.csv("DynamicNodes.csv")
DynamicEdges <- read.csv("DynamicEdges.csv")
tn <- networkDynamic(
  thenetwork,
  edge.spells = DynamicEdges,
  vertex.spells = DynamicNodes
)
network.dynamic.check(tn)
filmstrip(tn, displaylabels = FALSE)

# Slajd 8
# generowanie animacji
compute.animation(
  tn,
  animation.mode = "kamadakawai",
  slice.par = list(
    start = 1260,
    end = 1300,
    interval = 1,
    aggregate.dur = 20,
    rule = "any"
  )
)
render.d3movie(
  tn,
  displaylabels = FALSE
)

# Slajd 9
# Dynamika krawedzi
plot(tEdgeFormation(tn, time.interval = .25))

# Slajd 10
# Dynamika  betweenness centrality
dynamicBetweenness <- tSnaStats(
  tn,
  snafun = "centralization",
  start = 1260,
  end = 1320,
  time.interval = 1,
  aggregate.dur = 20,
  FUN = "betweenness"
)
plot(dynamicBetweenness)
dynamicDegree <- tSnaStats(
  tn,
  snafun = "centralization",
  start = 1260,
  end = 1320,
  time.interval = 1,
  aggregate.dur = 20,
  FUN = "degree"
)
plot(dynamicDegree)

# Slajd 11
# Osiagalnosc wezlow fwd & bkwd
# tReach(nd, direction = c("fwd","bkwd"), sample=network.size(nd), start, end, graph.step.time=0)
fwd_reach <- tReach(tn)
bkwd_reach <- tReach(tn, direction = "bkwd")
plot(fwd_reach, bkwd_reach)

# Slajd 12
# Sciezki temporalne
#tPath(nd, v, direction=c('fwd','bkwd'), type=c('earliest.arrive', 'latest.depart'), start, end, active.default = TRUE,
      graph.step.time = 0)
#is.tPath(x)

# Wizualizacja fwd
FwdPath <- tPath(
  tn,
  v = 3,
  direction = "fwd"
)
plotPaths(
  tn,
  FwdPath,
  displaylabels = FALSE,
  vertex.col = "white"
)

# Slajd 13
# Wizualizacja bkwd
BkwdPath <- tPath(
  tn,
  v = 3,
  direction = "bkwd",
  type = 'latest.depart'
)
plotPaths(
  tn,
  BkwdPath,
  path.col = rgb(0, 97, 255, max=255, alpha=166),
  displaylabels = FALSE,
  edge.label.col = rgb(0,0,0,0),
  vertex.col = "white"
)
