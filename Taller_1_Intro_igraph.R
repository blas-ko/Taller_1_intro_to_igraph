#' ---	
#' title: 'Social Network Analysis'	
#' subtitle: "Workshop 1. Intro to network analysis in R"	
#' institute:	
#'   - Department of Mathematics, UC3M | Institute of Data Science and Society, MIT	
#'   - Master in Computational Social Science	
#'   - Last updated `r Sys.Date()`	
#' author: "Esteban Moro"	
#' format: 	
#'   revealjs:	
#'     theme: [mytheme.scss]	
#'     code-overflow: wrap	
#'     slide-number: true	
#' #    embed-resources: true	
#'     chalkboard: true	
#' code-line-numbers: false	
#' execute:	
#'   echo: true	
#' editor: visual	
#' logo: img/uc3m.png	
#' link-external-icon: true	
#' link-external-newwindow: true	
#' title-slide-attributes:	
#'   data-background-image: img/background1.png	
#'   data-background-size: contain	
#'   data-background-opacity: "0.3"	
#' ---	
#' 	
#' 	
knitr::opts_chunk$set(cache=TRUE,fig.align='center',message=FALSE,warning=FALSE)	
rm(list = ls());gc()	
library(tidyverse)	
library(igraph)	
library(igraphdata)	
library(jsonlite)	
library(visNetwork)	
library(widgetframe)	
library(ggthemes)	
theme_set(theme_hc(base_size=16))	
#' 	
#' 	
#' ## Objective	
#' 	
#' The objective of this workshop is to give a small introduction to the `igraph` analysis library in `R` for graphs. We will learn:	
#' 	
#' -   The basic concepts of graph analysis using `igraph`	
#' -   To visualize graphs using the libraries `igraph`, `ggraph` and `visNetwork`	
#' -   To export graphs and visualize them using `gephi`	
#' 	
#' 	
require(visNetwork)	
frameWidget(visIgraph(barabasi.game(100),physics = T))	
#' 	
#' 	
#' ## Network Analysis in R	
#' 	
#' In `R` there are many options to study graphs. We will use the `igraph` library <http://igraph.org>/	
#' 	
#' -   Is a **open-sourced** package to build, manipulate and study graphs.	
#' -   Implements the **newest and most efficient algorithms**.	
#' -   Supports **different graph formats**.	
#' -   Implemented in `C`, `python` and of course `R`	
#' -   Has many options to **visualize graphs**.	
#' 	
#' We will also use the `ggraph` package to visualize graphs using the `ggplot` grammar and the `visNetwork` package which allows interactive visualization of graphs <http://dataknowledge.github.io/visNetwork/>	
#' 	
#' -   It is based on the `vis.js` library	
#' -   Based on `htmlwidgets`	
#' -   Works in **RStudio** and many browsers	
#' 	
#' ## Introduction to igraph: the graph object	
#' 	
#' The basic object in `igraph` is the `graph` object	
#' 	
#' 	
require(igraph)	
g <- graph( c(1,2, 2,3, 3,4, 3,5))	
g	
class(g)	
is.igraph(g)	
#' 	
#' 	
#' When defined, graphs can be directed or not. igraph cannot handle mixed graphs	
#' 	
#' 	
g <- graph( c(1,2, 2,3, 3,4, 3,5),directed=F)	
g	
#' 	
#' 	
#' ## Introduction to igraph: the graph object	
#' 	
#' Basically, the graph object is a wrapper for the nodes and edges data frames.	
#' 	
#' 	
E(g) # edge table	
V(g) # node table	
#' 	
#' 	
#' Each of these sets/tables can have different attributes	
#' 	
#' 	
E(g)$weight <- c(0.2,0.3,0.2,0.5) #the `weight` attribute is a reserved one	
V(g)$name <- c("juan","lola","pepe","saul","ana") #the `name` attribute is a reserved one	
V(g)$color <- c("red","blue","blue","red","blue")	
#' 	
#' 	
#' By giving weights to the edges, the graph becomes *weighted*	
#' 	
#' 	
g	
#' 	
#' 	
#' ## Building a graph from data	
#' 	
#' -   From `data.frames`	
#' 	
#' 	
g <- graph.data.frame(edges ,vertices=nodes)	
#' 	
#' 	
#' where `edges` and `nodes` are data.frames:	
#' 	
#' -   First two columns of edges contains the edges names or ids	
#' -   First column of `nodes` contains the names of the nodes. They have to coincide with the ones in `edges`	
#' -   Rest of the columns in `edges` and `nodes` are considered attributes of edges and nodes.	
#' 	
#' 	
edges <- data.frame(from=c(1,1,2,2,3,5),to=c(2,3,3,4,2,4),peso=c(1,1,1,2,2,3))	
nodes <- data.frame(id=c(1,2,3,4,5),nombre=c("juan","clara","luis","raul","alex"))	
g <- graph.data.frame(edges,vertices=nodes)	
g	
#' 	
#' 	
#' ## Building a graph from graph files or packages	
#' 	
#' The `read.graph` function is able to read graphs in various formats	
#' 	
#' 	
g <- read.graph(file, format = c("edgelist", "pajek", "ncol",	
"lgl","graphml", "dimacs", "graphdb", "gml", "dl"), ...)	
#' 	
#' 	
#' We can also export our graph in different formats	
#' 	
#' 	
write.graph(g,format="Pajek",file="g.net")	
#' 	
#' 	
#' Finally we have some packages with loaded graphs	
#' 	
#' 	
require("igraphdata")	
data(enron) #cargamos el grafo de los emails de enron	
enron	
#' 	
#' 	
#' ## Exercise 1: The Starwars network	
#' 	
#' Generate the StarWars characters' graph using the interactions between characters. The data can be downloaded from: <http://evelinag.com/blog/2015/12-15-star-wars-social-network/index.html#how> or <https://github.com/evelinag/StarWars-social-network>	
#' 	
#' Use	
#' 	
#' -   The file `/networks/starwars-full-interactions-allCharacters-merged.json` in that github	
#' 	
#'     <center><img src="img/json.png" width="600px"/></center>	
#' 	
#' -   The `jsonlite` package in R to import the interactions file and create the tables `nodos` y `enlaces`	
#' 	
#' -   Generate the graph	
#' 	
#' ## Exercise 1: The Starwars network	
#' 	
#' -   Import the json file and create the `nodos` and `enlaces` tables	
#' 	
#' 	
net <- jsonlite::fromJSON(txt="./data/starwars-full-interactions-allCharacters-merged.json")	
names(net)	
#' 	
#' 	
#' -   Create those two tables from the `net` object (list)	
#' 	
#' 	
nodos <- net$nodes	
enlaces <- net$links	
#' 	
#' 	
#' -   Have a look at the tables	
#' 	
#' 	
head(enlaces,2)	
head(nodos,2)	
#' 	
#' 	
#' ## Exercise 1: The Starwars network	
#' 	
#' -   There are `r nrow(nodos)` nodos	
#' -   The ids in the `enlaces` file are numeric and run from 0 to 110.	
#' -   Remember that the first column in the table `nodos` must contain the same ids that the firs two columns in `enlaces`. This is why we add a new colum to this file	
#' 	
#' 	
nodos <- data.frame(id=seq(0,nrow(nodos)-1),nodos)	
#' 	
#' 	
#' -   With that we can generate the graph	
#' 	
#' 	
gSW <- graph.data.frame(enlaces,vertices=nodos,directed=F)	
gSW	
#' 	
#' 	
#' ## Exercise 1: The Starwars network	
#' 	
#' 	
par(mar=c(0,0,0,0))	
plot(gSW)	
#' 	
#' 	
#' ## IDs of nodes and edges	
#' 	
#' -   Vertex and edges sequences are basically numeric vectors containing vertex/edge ids.	
#' -   When creating the graph, the vertex ids can be numeric or character	
#' 	
#' 	
head(V(gSW))	
#' 	
#' 	
#' -   Vertex (edge) internal ids run from 1 to $|V|$ ($|E|$). Internal ids are used typically in functions. Original ids are stored in `V(g)$name`	
#' 	
#' 	
V(gSW)[1]	
which(V(gSW)=="DARTH VADER")	
which(V(gSW)$name=="DARTH VADER")	
#' 	
#' 	
#' ## Graph operations: subsetting	
#' 	
#' -   Nodes that are neighbors of `a`	
#' 	
#' 	
head(V(gSW)[nei("DARTH VADER")])	
#' 	
#' 	
#' -   Edges between groups of nodes (direction matters)	
#' 	
#' 	
E(gSW)[c("DARTH VADER","LUKE") %->% c("R2-D2","C-3PO")]	
#' 	
#' 	
#' ## Graph operations: subsetting	
#' 	
#' We can also use specific igraph functions for this	
#' 	
#' 	
head(neighbors(gSW,"DARTH VADER")) #get the int. ids of a node’s neighbor	
head(incident(gSW,"DARTH VADER")) #get the incident edges to a node	
#' 	
#' 	
#' ## Graph operations: operations	
#' 	
#' We can modify the graph	
#' 	
#' -   Adding/deleting vertices/edges	
#' 	
#' 	
gSW <- gSW + vertex("ANAKIN",color="blue")	
gSW <- gSW + edge("DARTH VADER","ANAKIN")	
gSW <- delete.vertices(gSW,"ANAKIN")	
#' 	
#' 	
#' See `add.edges`, `add.vertices`, `delete.edges`	
#' 	
#' -   Simplify the graph: remove loops and multiple edges	
#' 	
#' 	
gSW <- simplify(gSW,remove.multiple = T,remove.loops = T)	
#' 	
#' 	
#' ## Graph operations: subgraphs	
#' 	
#' -   Subgraphs: only specified vertices and eges between them are kept	
#' 	
#' 	
gSW_subg <- induced.subgraph(gSW,vids = c("DARTH VADER","LUKE","PADME","LEIA"))	
plot(gSW_subg)	
#' 	
#' 	
#' ## Graph operations: subgraphs	
#' 	
#' -   We can also get only the neighborhood of a given node	
#' 	
#' 	
egoDW <- make_ego_graph(gSW,order = 1,"DARTH VADER")[[1]]	
plot(egoDW)	
#' 	
#' 	
#' ## Graph operation: components	
#' 	
#' Sometimes graphs are disconnected. In `igraph` we can get the connected components using	
#' 	
#' 	
par(mar=c(0,0,0,0))	
plot(gSW)	
#' 	
#' 	
#' 	
cc <- components(gSW)	
head(cc$membership)	
head(cc$csize)	
head(cc$no)	
#' 	
#' 	
#' ## Graph operation: components	
#' 	
#' We can get the largest component (giant component)	
#' 	
#' 	
gSWGC <- igraph::decompose(gSW)[[1]]	
plot(gSWGC)	
#' 	
#' 	
#' ## Graph analysis	
#' 	
#' -   Count the number of edges, vertices	
#' 	
#' 	
vcount(gSWGC)	
ecount(gSWGC)	
#' 	
#' 	
#' -   Calculate the in/out/all degree of vertices (and show the distribution)	
#' 	
#' 	
degree(gSWGC,mode="all")	
#' 	
#' 	
#' ## Graph analysis	
#' 	
#' Distributions	
#' 	
#' 	
ggplot() + geom_density(aes(x=degree(gSWGC,mode="all"))) + labs(x="Degree",y="Density")	
#' 	
#' 	
#' ## Graph analysis	
#' 	
#' -   Calculate the diameter of the graph	
#' 	
#' 	
diameter(gSWGC)	
#' 	
#' 	
#' -   Calculate the transitivity of the graph	
#' 	
#' 	
transitivity(gSWGC)	
#' 	
#' 	
#' -   Calculate the assortativity (degree) of the graph	
#' 	
#' 	
assortativity_degree(gSWGC)	
#' 	
#' 	
#' ## Graph communities	
#' 	
#' A network is said to have a community structure if nodes can be grouped into set of nodes such that each set in **densely connected internally**	
#' 	
#' ![](img/gZachary.png) ![](img/gZacharycomm.png)	
#' 	
#' ## Graph communities {.smaller}	
#' 	
#' There are many algorithms based on different clustering, function and optimization ideas. One key idea recently introduces is that of the **modularity** of a partition. In `igraph` we have	
#' 	
#' -   Algorithms based on hierarchical clustering	
#'     -   `cluster_edge_betweenness` remove edges of high betweenness since they seem to be between communities.	
#'     -   `cluster_fast_greedy` join nodes/groups with local greedy optimization of the modularity.	
#'     -   `cluster_louvain` hierarchical optimization of the modularity by joining nodes/groups.	
#'     -   `cluster_leiden` similar to the Louvain algorithm but faster and higher quality solutions.	
#' -   Algorithms based on matrix algebra	
#'     -   `cluster_leading_eigen` use the leading vector of the modularity matrix.	
#' -   Algorithms based on process methods	
#'     -   `cluster_label_prop` find consensus in majority voting of labels in the neighborhood of a vertex.	
#'     -   `cluster_walktrap` short random walks tend to stay in the same community.	
#'     -   `cluster_infomap` find community structure that minimizes the expected description length of random walker trajectories.	
#' 	
#' ## Graph communities	
#' 	
#' Not all the methods are equal and/or valid and/or efficient	
#' 	
#' | Algorithm                  | Directed | Weighted |     Complexity     |	
#' |----------------------------|:--------:|:--------:|:------------------:|	
#' | `cluster_edge_betweenness` |   TRUE   |   TRUE   |    $|V| |E|^2$     |	
#' | `cluster_fast_greedy`      |  FALSE   |   TRUE   | $|V| |E| \log |V|$ |	
#' | `cluster_louvain`          |  FALSE   |   TRUE   |     $|V|+ |E|$     |	
#' | `cluster_leading_eigen`    |  FALSE   |  FALSE   |   $c|V|^2 + |E|$   |	
#' | `cluster_label_prop`       |  FALSE   |   TRUE   |     $|V|+ |E|$     |	
#' | `cluster_walktrap`         |   TRUE   |   TRUE   |    $|V|^2 |E|$     |	
#' | `cluster_infomap`          |  FALSE   |   TRUE   |  $|V| (|V|+ |E|)$  |	
#' 	
#' ## Graph communities	
#' 	
#' Let's see an example with the famous Karate Club network and the `fast.greedy`	
#' 	
#' 	
data(karate)	
fg <- cluster_fast_greedy(karate)	
#' 	
#' 	
#' -   We get the following partition	
#' 	
#' 	
head(membership(fg))	
#' 	
#' 	
#' -   Check the goodness of the partition	
#' 	
#' 	
modularity(fg)	
#' 	
#' 	
#' ## Graph communities	
#' 	
#' -   We can show the graph and communities together	
#' 	
#' 	
par(mar=c(0, 0, 0, 0))	
plot(fg,karate)	
#' 	
#' 	
#' ## Graph communities	
#' 	
#' Different algorithms produce different results	
#' 	
#' 	
par(mar=c(0, 0, 0, 0))	
louvain <- cluster_louvain(karate)	
plot(louvain,karate)	
#' 	
#' 	
#' ## Graph communities	
#' 	
#' We can compare different the communities found:	
#' 	
#' 	
par(mfrow=c(1,2)) 	
ll <- layout.kamada.kawai(karate)	
plot(fg,karate,layout=ll) 	
plot(louvain,karate,layout=ll)	
compare(fg, louvain,method="nmi")	
#' 	
#' 	
#' `nmi` is one of the methods to compare communities.	
#' 	
#' ## Exercise 1	
#' 	
#' Calculate the communities in the StarWars network using the Louvain method. How good is the partition found? Which is the community of Darth Vader?	
#' 	
#' Use	
#' 	
#' -   `cluster_louvain` to calculate the communities	
#' -   `membership` to get the partition	
#' -   `modularity` to see how good is the partition	
#' 	
#' ## Exercise 1	
#' 	
#' Get the communities with and without the weights	
#' 	
#' 	
comm_sin <- cluster_louvain(gSWGC,weights=NULL)	
comm_con <- cluster_louvain(gSWGC,weights = E(gSWGC)$value)	
#' 	
#' 	
#' Let's see how are the communities	
#' 	
#' 	
sizes(comm_sin)	
#' 	
#' 	
#' 	
sizes(comm_con)	
#' 	
#' 	
#' ## Exercise 1	
#' 	
#' How good are the communities?	
#' 	
#' 	
modularity(comm_sin)	
#' 	
#' 	
#' 	
modularity(comm_con)	
#' 	
#' 	
#' Plot them	
#' 	
#' 	
par(mfrow=c(1,2))  	
ll <- layout.kamada.kawai(gSWGC)	
plot(comm_sin,gSWGC,layout=ll,vertex.label="")	
plot(comm_con,gSWGC,layout=ll,vertex.label="")	
#' 	
#' 	
#' ## Exercise 1	
#' 	
#' Find Darth Vader's community:	
#' 	
#' 	
membership(comm_con) %>% enframe() %>% 	
  filter(name=="DARTH VADER")	
#' 	
#' 	
#' Who belongs to that community?	
#' 	
#' 	
membership(comm_con) %>% enframe() %>% 	
  filter(value==1)	
#' 	
#' 	
#' ## Centrality	
#' 	
#' Not all nodes in the network are equally important. `igraph` has several ways to calculate centrality of nodes and edges	
#' 	
#' -   PageRank: calculates Google's PageRank for vertices	
#' 	
#' 	
pr <- page_rank(gSWGC)	
pr$vector %>% sort(decreasing = T) %>% head()	
#' 	
#' 	
#' -   Closeness: distance (steps) to any other vertex	
#' 	
#' 	
cl <- closeness(gSWGC)	
1/cl %>% sort(decreasing = T) %>% head()	
#' 	
#' 	
#' ## Centrality	
#' 	
#' -   Betweenness: the number of shortest paths going through a vertex/edge	
#' 	
#' 	
bt <- betweenness(gSWGC)	
bt %>% sort(decreasing = T) %>% head()	
#' 	
#' 	
#' -   We can use also the weighted versions to calculate the paths or rank	
#' 	
#' 	
bt_weighted <- betweenness(gSWGC,weights = E(gSWGC)$value)	
bt_weighted %>% sort(decreasing = T) %>% head()	
#' 	
#' 	
#' ## Exercise 2	
#' 	
#' -   Calculate the centrality of the characters in the StarWars network using the degree, betweenness and page rank.	
#' 	
#' -   Who are the most important characters according to those centrality metrics?	
#' 	
#' -   How are those centrality metrics correlated across the network?	
#' 	
#' ## Exercise 2	
#' 	
#' Calculate different centrality metrics. We are going to try also the `degree strength` which is the sum of the weights of the links from/to a node:	
#' 	
#' 	
cent_degree <- degree(gSWGC,mode="all")	
cent_streng <- strength(gSWGC,weights=E(gSWGC)$value)	
cent_betw <- betweenness(gSWGC, weights=E(gSWGC)$value)	
cent_page <- page_rank(gSWGC, weights=E(gSWGC)$value)$vector	
#' 	
#' 	
#' Put them together	
#' 	
#' 	
table_cent <- data.frame(cent_degree,cent_streng,	
           cent_betw,cent_page)	
table_cent %>% head(5)	
#' 	
#' 	
#' ## Exercise 2	
#' 	
#' We can see who are the most central according to different metrics	
#' 	
#' 	
table_cent %>% arrange(-cent_streng) %>% head(5)	
#' 	
#' 	
#' 	
table_cent %>% arrange(-cent_betw) %>% head(5)	
#' 	
#' 	
#' 	
table_cent %>% arrange(-cent_page) %>% head(5)	
#' 	
#' 	
#' ## Exercise 2	
#' 	
#' How are these measures of centrality correlated? We are going to use the *Kendall* method that are used to estimate rank-based measured of association.	
#' 	
#' 	
require(corrplot)	
cc <- cor(table_cent,method="kendall")	
corrplot(cc)	
#' 	
#' 	
#' As we can see the major differences happen with betweenness and the rest.	
#' 	
#' ## Graph visualization	
#' 	
#' -   Visualizing a graph involves calculating a **layout** for displaying the nodes in a two-dimensional figure.	
#' -   But this is a complicated task, since generally a graph is not a 2D structure.	
#' -   Thus, all layouts are projections of the graph object. There are many of them using mathematical and/or computer science methods.	
#' -   A good layout is such that:	
#'     -   Minimizes the number of crossing edges.	
#'     -   Minimizes the length of edges.	
#' 	
#' ## Graph visualization	
#' 	
#' Basically there are different groups of methods (by strategy) to obtain a good **layout**	
#' 	
#' ::: columns	
#' ::: column	
#' **Force-based layout**: use physical forces (typically spring-like) between nodes along edges (attractive) and between nodes (repulsive) and find a minimum of their energy.	
#' 	
#' -   `layout.fruchterman.reingold`	
#' -   `layout.kamada.kawai`	
#' -   `layout.spring`	
#' -   `layout.lgl`	
#' -   `layout.drl`	
#' -   `layout.graphopt`	
#' :::	
#' 	
#' ::: column	
#' **Spectral methods**:	
#' 	
#' -   `layout.svd`	
#' 	
#' **Special graphs**: for example, tree-like layout for trees.	
#' 	
#' -   `layout.reingold.tilford`	
#' 	
#' **Ordered**: place nodes in defined structures	
#' 	
#' -   `layout.random`	
#' -   `layout.circle`	
#' -   `layout.sphere`	
#' :::	
#' :::	
#' 	
#' ## Graph visualization	
#' 	
#' Caution: Computing a layout is a high intensive task. For example in force-based layouts it takes to evaluate $|E|$ attractive forces along edges and $|V|^2$ repulsive forces between nodes for each step of the minimization algorithm.	
#' 	
#' Example: running time to produce the layout of `barabasi.game(n)` with different number of nodes `n`.	
#' 	
#' <center>![](img/layouttimes.png)</center>	
#' 	
#' ## Graph visualization	
#' 	
#' We can change the visualization by changing colors, size, font, etc. of nodes and edges	
#' 	
#' -   `vertex.label = ""` sets labels to nothing	
#' -   `vertex.size = 2` set vertex symbol size to 2	
#' -   `vertex.color = colors` set vertex color to that of `colors` vector	
#' -   `edge.color = colors` same for edges	
#' -   `edge.width = wij` set edge width to vector `wij`	
#' -   `edge.arrow.size = 0.5` set size of arrows to 0.5	
#' -   `edge.curved = T` draw curved edges	
#' 	
#' ## Graph visualization	
#' 	
#' When visualizing a medium/large graph we can use some tricks to get more informative visualizations:	
#' 	
#' -   Make the size of the nodes proportional to their centrality/degree	
#' 	
#' 	
par(mar=c(0,0,0,0))	
plot(gSWGC,vertex.size=degree(gSWGC))	
#' 	
#' 	
#' ## Graph visualization	
#' 	
#' -   The width of the edges proportional to the `value` (or strength) attribute	
#' 	
#' 	
par(mar=c(0,0,0,0))	
plot(gSWGC,vertex.size=degree(gSWGC), edge.width=E(gSWGC)$value/2)	
#' 	
#' 	
#' ## Graph visualization	
#' 	
#' -   The color of the nodes as in the `colour` attribute	
#' 	
#' 	
par(mar=c(0,0,0,0))	
plot(gSWGC,vertex.size=degree(gSWGC),edge.width=E(gSWGC)$value/2,vertex.color=V(gSWGC)$colour)	
#' 	
#' 	
#' ## Graph visualization	
#' 	
#' -   Show only the nodes' label for those with degree $\geq$ 10	
#' 	
#' 	
par(mar=c(0,0,0,0))	
etiqueta <- ifelse(degree(gSWGC)>5,V(gSWGC)$name,"")	
plot(gSWGC,vertex.size=degree(gSWGC),edge.width=E(gSWGC)$value/2,vertex.color=V(gSWGC)$colour,	
     vertex.label=etiqueta)	
#' 	
#' 	
#' ## Graph visualization	
#' 	
#' -   Change the font family and size for the nodes' labels	
#' 	
#' 	
par(mar=c(0,0,0,0))	
etiqueta <- ifelse(degree(gSWGC)>5,V(gSWGC)$name,"")	
plot(gSWGC,vertex.size=degree(gSWGC),edge.width=E(gSWGC)$value/2,vertex.color=V(gSWGC)$colour,	
     vertex.label=etiqueta,	
     vertex.label.family="sans",vertex.label.dist=1,vertex.label.cex=0.5)	
#' 	
#' 	
#' ## Graph visualization	
#' 	
#' We can use also the `ggraph` and `graphlayouts` packages to visualize networks using the `ggplot` grammar	
#' 	
#' 	
require(ggraph)	
ggraph(gSWGC) + geom_edge_link() + geom_node_point() + theme_void()	
#' 	
#' 	
#' ## Graph visualization	
#' 	
#' Some of the `igraph` layouts work here too. And we can use some of the grammar in `ggplot`	
#' 	
#' 	
ggraph(gSWGC,layout="lgl") + geom_edge_link() + geom_node_point() + theme_void() + 	
  labs(title="Starwars Network")	
#' 	
#' 	
#' ## Graph visualization	
#' 	
#' We can change the type of edges. Visual properties for nodes and edges work too:	
#' 	
#' 	
ggraph(gSWGC,layout="lgl") + geom_edge_arc(color="gray50",width=0.8,alpha=0.5) + 	
  geom_node_point(color=V(gSWGC)$colour,size=3) + theme_void() + 	
  labs(title="Starwars Network")	
#' 	
#' 	
#' ## Graph visualization	
#' 	
#' The ggraph package also uses the traditional `ggplot2` way of mapping aesthetics	
#' 	
#' 	
ggraph(gSWGC,layout="lgl") + geom_edge_link(aes(edge_width=value),color="gray50",alpha=0.5) + 	
  geom_node_point(color=V(gSWGC)$colour,size=3) + theme_void() +	
  labs(title="Starwars Network")	
#' 	
#' 	
#' ## Graph visualization	
#' 	
#' We can add a layer with node labels using geom_node_text() or geom_node_label() which correspond to similar functions in ggplot2.	
#' 	
#' 	
ggraph(gSWGC,layout="lgl") + geom_edge_link(aes(edge_width=value),color="gray50",alpha=0.5) + 	
  geom_node_point(color=V(gSWGC)$colour,size=3) + 	
  geom_node_text(aes(label=name),size=3, color="gray50", repel=T) + theme_void() +	
  labs(title="Starwars Network")	
#' 	
#' 	
#' ## Interactive Graph visualization	
#' 	
#' Another (more recent) library for graph visualization is `visNetwork`, which allows interactive visualization. The function `visNetwork` needs two data frames	
#' 	
#' 	
visIgraph(gSWGC,physics = T) 	
#' 	
#' 	
#' 	
frameWidget(visIgraph(gSWGC,physics = T))	
#' 	
#' 	
#' ## Interactive Graph visualization	
#' 	
#' We can even highlight the neighborhood of a node or selecte a node from a list	
#' 	
#' 	
visIgraph(gSWGC,physics = T) %>%	
visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE)	
#' 	
#' 	
#' 	
frameWidget(visIgraph(gSWGC,physics = T) %>%	
visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE))	
#' 	
#' 	
#' ## Interactive Graph visualization	
#' 	
#' Or use colors for the nodes	
#' 	
#' 	
V(gSWGC)$color <- V(gSWGC)$colour	
visIgraph(gSWGC,physics = T) %>%	
visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE)	
#' 	
#' 	
#' 	
V(gSWGC)$color <- V(gSWGC)$colour	
frameWidget(visIgraph(gSWGC,physics = T) %>%	
visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE))	
#' 	
#' 	
#' ## Graph visualization	
#' 	
#' -   Check <https://datastorm-open.github.io/visNetwork/> for more options of the `visNetwork` package	
#' 	
#' -   Although `visNetwork` works well for small graphs, it is not recommended to plot very graphs ($> 1000$ nodes)	
#' 	
#' -   For those sizes we will use `Gephi`, an external application	
#' 	
#' -   To do that we expor the graph to work on `Gephi`	
#' 	
#' 	
write.graph(gSWGC,file="./data/gSWGC.graphml",format="graphml")	
#' 	
#' 	
#' ## Visualization using Gephi	
#' 	
#' Gephi is probably the most used tool to visualize graphs	
#' 	
#' -   Is an interactive visualization software	
#' -   includes some analysis metrics.	
#' -   Works in Windows Linux and MacOSX.	
#' -   It is the **photoshop** for graphs	
#' -   <http://gephi.org>	
#' 	
#' ## Visualization using Gephi	
#' 	
#' Open Gephi -\> Create new project	
#' 	
#' <center><img src="img/gephi1.png" width="800px"/></center>	
#' 	
#' ## Visualization using Gephi	
#' 	
#' Load `gSWGC.graphml`	
#' 	
#' <center><img src="img/gephi2.png" width="800px"/></center>	
#' 	
#' ## Visualization using Gephi	
#' 	
#' Choose layout (best is Atlas)	
#' 	
#' <center><img src="img/gephi3.png" width="800px"/></center>	
#' 	
#' ## Visualization using Gephi	
#' 	
#' Change properties of nodes/edges	
#' 	
#' <center><img src="img/gephi4.png" width="800px"/></center>	
#' 	
#' ## Visualization using Gephid	
#' 	
#' Once you are finished with the layout and appearance, got to "Preview" (and Refresh). You can further modify the graph and export it using PDF/PNG/SVG	
#' 	
#' <center><img src="img/gephi5.png" width="800px"/></center>	
#' 	
#' And you can export the graph using PDF/PNG/SVG	
#' 	
#' ## Visualization using Gephi	
#' 	
#' Gephi is really good for large graphs	
#' 	
#' <center><img src="img/gephi3copy.png" width="800px"/></center>	
#' 	
#' # References	
#' 	
#' -   General resources:	
#'     -   [Awesome Network Analysis](https://github.com/briatte/awesome-network-analysis#courses)	
#' -   About `igraph`	
#'     -   Material online	
#'         -   [Intro to igraph in R](https://r.igraph.org/articles/igraph.html)	
#'         -   [igraph wikidot](http://igraph.wikidot.com)	
#'     -   Libros	
#'         -   [The igraph book](https://www.amazon.com/Statistical-Analysis-Network-Data-Use-dp-3030441288/dp/3030441288/ref=dp_ob_title_bk)	
#' -   Visualization of networks	
#'     -   [Static and dynamic network visualization with R](https://kateto.net/network-visualization)	
#'     -   [Visualizing a Network Dataset Using Gephi](https://mdl.library.utoronto.ca/technology/tutorials/visualizing-network-dataset-using-gephi)	
#' 	
#' ## Graph Models	
#' 	
#' The library `igraph` contains a number of functions to create networks from statistical models.	
#' 	
#' -   Erdos-Renyi (or GNP) graph with 20 nodes and probability of a link $p= 0.1$	
#' 	
#' 	
g_er <- sample_gnp(20,0.1) 	
#' 	
#' 	
#' -   Erdos-Renyi (or GNP) graph with 20 nodes and 40 links	
#' 	
#' 	
g_er_2 <- sample_gnm(20,40)	
#' 	
#' 	
#' -   Prefferential attachement (Barabasi-Albert) network with 20 nodes	
#' 	
#' 	
g_pa <- sample_pa(20,directed = F) 	
#' 	
#' 	
#' -   Small-World network in 1 dimension with 20 nodes, with size of local neighborhood equal to 4 and rewiring probability $p=0.1$.	
#' 	
#' 	
g_sw <- sample_smallworld(1,20,4,0.1) 	
#' 	
#' 	
#' -   Configuration model with the same degrees as in the karate network	
#' 	
#' 	
g_ds <- sample_degseq(degree(karate)) 	
#' 	
#' 	
#' ## Graph Models	
#' 	
#' 	
require(patchwork)	
g1 <- ggraph(g_er,layout="kk")+geom_edge_link()+geom_node_point()+theme_void()+labs(title="Erdos-Renyi")	
g2 <- ggraph(g_pa,layout="kk")+geom_edge_link()+geom_node_point()+theme_void()+labs(title="Pref. Attachment")	
g3 <- ggraph(g_sw,layout="kk")+geom_edge_link()+geom_node_point()+theme_void()+labs(title="Small-World")	
g4 <- ggraph(g_ds,layout="kk")+geom_edge_link()+geom_node_point()+theme_void()+labs(title="Degree Seq.")	
g1 + g2 + g3 + g4	
#' 	
#' 	
#' ## Graph Models	
#' 	
#' Note that this functions generate a **sample** from the distribution of models. That is, since models like Erdos-Renyi, Pref. Attachement, Small World or Degree Sequence are stochastic, everytime we call them, they give a different realization of the model:	
#' 	
#' 	
g1 <- ggraph(sample_gnp(20,0.1),layout="kk")+geom_edge_link()+geom_node_point(col="blue")+theme_void()	
g2 <- ggraph(sample_gnp(20,0.1),layout="kk")+geom_edge_link()+geom_node_point(col="red")+theme_void()	
g3 <- ggraph(sample_gnp(20,0.1),layout="kk")+geom_edge_link()+geom_node_point(col="orange")+theme_void()	
g4 <- ggraph(sample_gnp(20,0.1),layout="kk")+geom_edge_link()+geom_node_point(col="green")+theme_void()	
g1 + g2 + g3 + g4	
#' 	
#' 	
#' ## Graph models	
#' 	
#' Graph statistical models are use to test statistical hypothesis. For example, is the transitivity/clustering that we get in a network statistically significant. In this sense graph statistical models are **null models** for those test. Typical null models are	
#' 	
#' -   Erdos-Renyi models with the same number of nodes and links as the network we are testing	
#' 	
#' -   Degree-sequence models with the same degree distribution	
#' 	
#' Choosing a different null model test different statistical hypothesis. For example: is the clustering in our network just due to the large number of links that we have? Are the communities we find in the network due to the degree sequence?	
#' 	
#' ## Graph models	
#' 	
#' Let's see an example of statistical test in networks. Suppose we use the Enron network (simplified) and get its transitivity/clustering	
#' 	
#' 	
data(enron)	
enron_sim <- simplify(enron)	
transitivity(enron_sim)	
ggraph(enron_sim,layout="kk")+geom_edge_link()+geom_node_point()+theme_void()	
#' 	
#' 	
#' ## Graph models	
#' 	
#' But the network is very heterogeneous in degree. In the Enron company some people are more connected than others	
#' 	
#' 	
ggplot()+geom_density(aes(x=degree(enron_sim,mode="all"))) + labs(x="Degree",y="Density")	
#' 	
#' 	
#' Is the large transitivity in the network just a mere consequence of the large heterogeneity in degree?	
#' 	
#' ## Graph models	
#' 	
#' Let's compare the transivity in the real newtork with the one from a degree-sequence realization with the same degree distribution as the real network	
#' 	
#' 	
transitivity(enron_sim)	
transitivity(sample_degseq(degree(enron_sim)))	
#' 	
#' 	
#' It is close. Are they different statistically speaking? In order to test this, we need to generate the distribution of clustering values from the degree-sequence models with the same degree sequence as the enron network. Let's do it for 1000 realizations	
#' 	
#' 	
trans_model <- replicate(1000,transitivity(sample_degseq(degree(enron_sim))))	
#' 	
#' 	
#' ## Graph models	
#' 	
#' And now we compare the actual value from the enron network with the distribution of values from the degree-sequence model	
#' 	
#' 	
ggplot() + geom_density(aes(x=trans_model)) +	
  geom_vline(xintercept = transitivity(enron_sim),linetype=2)	
#' 	
#' 	
#' Assuming the distribution for the degree-sequence is Gaussian, then the p-value of our hypothesis is	
#' 	
#' 	
dnorm(transitivity(enron_sim),mean=mean(trans_model),sd=sd(trans_model))	
#' 	
