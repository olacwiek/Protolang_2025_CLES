library(tidyverse)
library(ggbeeswarm)
library(wizard)
library(patchwork)

# read data
d <- read_csv("../WordNet/answers_wordnet.csv")


# ConceptNet
# cn <- readxl::read_xlsx("cosine_sim.xlsx", col_names = TRUE)
cn <- read_delim("../data_conceptnet/cosine_sim.csv", delim = ";")
colnames(cn) <- as.character(cn[1,])
cn <- cn[-1,]
cn$cosine_similarity <- as.numeric(cn$cosine_similarity)

d001 <- left_join(d, cn, by = c("Right_Answer" = "Right_answer", "Answer" = "Answer"), relationship  = "many-to-many") 

# cn %>% group_by(Right_answer) %>% summarise(
#   mean = mean(na.omit(cosine_similarity))
# )
cn$Right_answer <- factor(cn$Right_answer)


cn %>% ggplot(aes(x = reorder(Right_answer, cosine_similarity, median, na.rm=T, decreasing = T), y = cosine_similarity)) +
  geom_boxplot() + xlab("Target word") +
  ylab("Cosine similarity") +
  theme(axis.text.x = element_text(angle=45, hjust=.9, size=12)) 
# ggsave("conceptnet_boxplot.png")

