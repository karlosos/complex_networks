library(igraph)

pdf(file="./data/out/voles/default.pdf")
net <- read.graph("./data/voles/mammalia-voles-rob-trapping-11.edges", format = "edgelist")
plot(net)
dev.off()

pdf(file="./data/out/voles/fr.pdf")
l <- layout_with_fr(net)
plot(net, layout=l)
dev.off()

pdf(file="./data/out/voles/kk.pdf")
l <- layout_with_kk(net)
plot(net, layout=l)
dev.off()


pdf(file="./data/out/voles/degree.pdf")
deg <- degree(net, mode="all")
plot(net, vertex.size=deg*3)
dev.off()

pdf(file="./data/out/voles/hist.pdf")
hist(degree(net))
dev.off()

pdf(file="./data/out/voles/dist.pdf")
deg <- degree(net, mode="all")
deg.dist <- degree.distribution(net, cumulative=T)
plot(degree.distribution(net, cumulative=T), pch=20,xlab="degree", ylab="cumulative frequency", type="l")
dev.off()
