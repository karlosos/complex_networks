library(igraph)

fg <- make_full_graph(40) 
plot(fg, vertex.size=10, vertex.label=NA)


net <- read.graph("./data/facebook_combined.txt", format = "edgelist")
plot(net)
write_graph(net, "./data/out/file2g.txt", "edgelist")

# Generowanie grafów

pdf(file="./data/out/gl.pdf")
gl <- graph_from_literal(a-b-c-d-e-f, a-g-h-b, h-e:f:i, j)
plot(gl)
dev.off()

pdf(file="./data/out/eq.pdf")
eg <- make_empty_graph(40) e
plot(eg, vertex.size=10, vertex.label=NA)
dev.off()

pdf(file="./data/out/fg.pdf")
fg <- make_full_graph(40) 
plot(fg, vertex.size=10, vertex.label=NA)
dev.off()

pdf(file="./data/out/st.pdf")
st <- make_star(40) 
plot(st, vertex.size=10, vertex.label=NA)
dev.off()

pdf(file="./data/out/tr.pdf")
tr <- make_tree(40, children = 3, mode = "undirected")
plot(tr, vertex.size=10, vertex.label=NA)
dev.off()

pdf(file="./data/out/rn.pdf")
rn <- make_ring(40) 
plot(rn, vertex.size=10, vertex.label=NA)
dev.off()

pdf(file="./data/out/er.pdf")
er <- sample_gnm(n=100, m=40)
plot(er, vertex.size=6, vertex.label=NA)
dev.off()

pdf(file="./data/out/sw.pdf")
sw <- sample_smallworld(dim=2, size=10, nei=1, p=0.1)
plot(sw, vertex.size=6, vertex.label=NA, layout=layout_in_circle)
dev.off()

pdf(file="./data/out/ba.pdf")
ba <- sample_pa(n=100, power=1, m=1, directed=F)
plot(ba, vertex.size=6, vertex.label=NA)
dev.off()

# Layouty

pdf(file="./data/out/layouts/default.pdf")
net.bg <- sample_pa(80)
V(net.bg)$size <- 8
V(net.bg)$frame.color <- "white"
V(net.bg)$color <- "orange"
V(net.bg)$label <- ""
E(net.bg)$arrow.mode <- 0
plot(net.bg)
dev.off()

pdf(file="./data/out/layouts/kolowy.pdf")
l <- layout_in_circle(net.bg)
plot(net.bg, layout=l)
dev.off()

pdf(file="./data/out/layouts/sfery.pdf")
l <- layout_on_sphere(net.bg)
plot(net.bg, layout=l)
dev.off()

pdf(file="./data/out/layouts/fr.pdf")
l <- layout_with_fr(net.bg)
plot(net.bg, layout=l)
dev.off()

pdf(file="./data/out/layouts/kk.pdf")
l <- layout_with_kk(net.bg)
plot(net.bg, layout=l)
dev.off()

# Stopnie i rozkady

pdf(file="./data/out/degree.pdf")
net <- read.graph("./data/test_16.txt", format = "edgelist")
deg <- degree(net, mode="all")
plot(net, vertex.size=deg*3)
dev.off()

pdf(file="./data/out/hist.pdf")
net <- sample_pa(n=100, power=1, m=1, directed=F)
hist(degree(net))
dev.off()

pdf(file="./data/out/dist.pdf")
net <- sample_pa(n=100, power=1, m=1, directed=F)
deg <- degree(net, mode="all")
deg.dist <- degree.distribution(net, cumulative=T)
plot(degree.distribution(net, cumulative=T), pch=20,xlab="degree", ylab="cumulative frequency", type="l")
dev.off()
