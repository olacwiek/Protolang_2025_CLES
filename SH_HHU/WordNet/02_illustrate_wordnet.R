# This script creates a graph
# to illustrate the inner workings
# of WordNet with a simple example.

library(tidyverse)
library(ggraph)
library(igraph)
library(tidygraph)

# read data
d <- read_csv("wordnet_sleep_example.csv")

# remove "Synset" from column 1
d$Synset <- gsub("Synset\\(\\'|\\')", "", d$Synset)

# remove Napoleon
d <- filter(d, !grepl("napoleon", d$Synset))

# unique Synset-Lemma combinations
d_unique <- d %>% select(Lemma, Synset) %>% unique
d_unique <- d_unique[-which(duplicated(d_unique$Lemma)),]
d_unique$Synset <- factor(d_unique$Synset)

# add another vertex attribute: whether
# it is a target lemma
d_unique$Target <- ifelse(d_unique$Lemma %in% unique(d$Lemma_target), "red", "black")

# remove index column
d <- d %>% select(Synset, Lemma, Lemma_target)

# as graph

g <- d %>% select(Lemma_target, Lemma) %>% 
  graph_from_data_frame(vertices = d_unique)



p <- ggraph(g) +
  geom_edge_link() +
  geom_node_point(aes(color = vertex_attr(g)$Synset)) +
  # geom_node_text(aes(label = as_ids(V(g)))) +
  theme_graph(background = 'white') +
  guides(color = "none") +
  scale_color_viridis_d(begin = .2, end = .8)
  
p + ggnewscale::new_scale_color() + 
  geom_node_text(aes(label = as_ids(V(g)), color = (Target)),  
                   nudge_x = p$data$x * .1, 
                   nudge_y = p$data$y * .1) +
  scale_color_identity()
# ggsave("wordnet_example.png", width = 9, height = 5)


