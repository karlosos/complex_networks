setwd("C:/Dev/complex_networks/lab_5/")
library(igraph)
library(sna)
library(tsna)
library(ndtv)

df <- read.table("CollegeMsg.txt", sep=" ", header = FALSE)
df$V3 = as.Date(as.POSIXct(df$V3, origin="1970-01-01"))
df$month = months(df$V3)
